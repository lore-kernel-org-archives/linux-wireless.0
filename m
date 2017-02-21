Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55437 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751043AbdBUCXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 21:23:43 -0500
Date: Tue, 21 Feb 2017 03:23:37 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        "jeyu@redhat.com" <jeyu@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/5] iwlwifi: fix request_module() use
Message-ID: <20170221022337.GG31264@wotan.suse.de> (sfid-20170221_032410_653081_5907BC1E)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-3-mcgrof@kernel.org>
 <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AE27@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AE27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2017 at 09:47:59AM +0000, Grumbach, Emmanuel wrote:
> > 
> > The return value of request_module() being 0 does not mean that the driver
> > which was requested has loaded. To properly check that the driver was
> > loaded each driver can use internal mechanisms to vet the driver is now
> > present. The helper try_then_request_module() was added to help with
> > this, allowing drivers to specify their own validation as the first argument.
> > 
> > On iwlwifi the use case is a bit more complicated given that the value we
> > need to check for is protected with a mutex later used on the
> > module_init() of the module we are asking for. If we were to lock and
> > request_module() we'd deadlock. iwlwifi needs its own wrapper then so it
> > can handle its special locking requirements.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> 
> I don't see the problem with the current code. We don't assume that everything has been
> loaded immediately after request_module returns. We just free the intermediate firmware
> structures that won't be using anymore. What happens here is that after request_module
> returns, we patiently wait until it is loaded, and when that happens, iwl{d,m}vm's init function
> will be called.

Right I get that.

The code today complains if its respective opmode module was not loaded
if request_module() did not return 0. As the commit log explains, relying
on a return code of 0 to ensure a module loads is not sufficient. So the
current print is almost pointless, so best we either:

a) just remove the print and use instead request_module_nowait() (this is more
   in alignment of what your code actually does today; or

b) fix the request_module() use so that the error print matches the expected
   and proper recommended use of request_module() (what this patch does)

I prefer a) actually but I had to show what b) looked like first :)

The only issue with a) is today we have no *slim* way to let drivers
load a module asynchronously and then later verify it did get loaded.
>From a *quick* look this grammatical form of request_module_nowait() and
a verifier is essentially is not widely popular or not present at all
today. A verifier seems reasonable if you use request_module_nowait()
though and want to be pedantic about ensuring the module is there.

What this might look like for iwlwifi? Something like this:

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index be466a074c1d..8059e1dab061 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -137,11 +137,16 @@ static struct iwlwifi_opmode_table {
 	const char *name;			/* name: iwldvm, iwlmvm, etc */
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
 	struct list_head drv;		/* list of devices using this op_mode */
+	bool load_requested;		/* Do we need to load a driver ? */
+	struct iwl_drv *drv_req;	/* Device that set load_requested */
 } iwlwifi_opmode_table[] = {		/* ops set when driver is initialized */
 	[DVM_OP_MODE] = { .name = "iwldvm", .ops = NULL },
 	[MVM_OP_MODE] = { .name = "iwlmvm", .ops = NULL },
 };
 
+static void iwlwifi_load_opmode(struct work_struct *work);
+static DECLARE_DELAYED_WORK(iwl_opload_work, iwlwifi_load_opmode);
+
 #define IWL_DEFAULT_SCAN_CHANNELS 40
 
 /*
@@ -1231,6 +1236,43 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
+static void iwlwifi_load_opmode(struct work_struct *work)
+{
+	struct iwl_drv *drv = NULL;
+	struct iwlwifi_opmode_table *op;
+	unsigned int i;
+
+	mutex_lock(&iwlwifi_opmode_table_mtx);
+	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
+		op = &iwlwifi_opmode_table[i];
+		if (!op->load_requested)
+			continue;
+		drv = op->drv_req;
+
+		if (!op->ops && drv) {
+			IWL_ERR(drv,
+				"failed to load module %s, is dynamic loading enabled?\n",
+				op->name);
+			complete(&drv->request_firmware_complete);
+			device_release_driver(drv->trans->dev);
+			mutex_unlock(&iwlwifi_opmode_table_mtx);
+			return;
+		}
+
+		op->load_requested = false;
+		op->drv_req = NULL;
+	}
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
+
+
+	/*
+	 * Complete the firmware request last so that
+	 * a driver unbind (stop) doesn't run while we
+	 * are doing the opmode start().
+	 */
+	complete(&drv->request_firmware_complete);
+}
+
 /**
  * iwl_req_fw_callback - callback when firmware was loaded
  *
@@ -1250,7 +1292,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
-	bool load_module = false;
 	bool usniffer_images = false;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
@@ -1455,31 +1496,26 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			goto out_unbind;
 		}
 	} else {
-		load_module = true;
+		op->load_requested = true;
+		op->drv_req = drv;
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 	/*
-	 * Complete the firmware request last so that
-	 * a driver unbind (stop) doesn't run while we
-	 * are doing the start() above.
-	 */
-	complete(&drv->request_firmware_complete);
-
-	/*
 	 * Load the module last so we don't block anything
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
+	 *
+	 * Always try loading it, even if we were built-in as
+	 * in built-in cases this will be a no-op and so will
+	 * the verifier check.
 	 */
-	if (load_module) {
-		err = request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
+	err = request_module_nowait("%s", op->name);
+	if (err)
+		goto out_unbind;
+
+	schedule_delayed_work(&iwl_opload_work, HZ);
+
 	goto free;
 
  try_again:

So consider this for your driver -- if you agree today's print is rather
pointless upon failure then you'd be OK in just using request_module_nowait()
and removing the print -- and not adding a verifier step 2 like the above.

Only -- it seems you want a verifier.

So you have 2 options with a suboptions:

  1) keep sync request and add the verifier -- as in the original patch in this e-mail
  2) use async request and
	2a) add verifier
	2b) ignore the verifier

I don't see why you'd want 2b) is what I'm trying to say and the point of this
path is to show what a 1) would look like.

The point of this email also is to highlight what it would look like in general
if we wanted verifiers for module request for async_schedule() calls, given
they cannot use request_module() and *must* use request_module_nowait() and
that ultimately begs the question if they want verifiers or not as well.

For iwlwifi and wireless this is only generally relevant for the async
callback for firmware requests, but it seems only iwlwifi uses this form.
I used async_schedule() for the driver data API which I'm developing,
and as such 2a or a solution for 1) was needed in such a way it was
compatible.

> That one is the one that continues the flow by calling:
> 
> 	ret = iwl_opmode_register("iwlmvm", &iwl_mvm_ops);
> 
> (for the iwlmvm case).
> 
> Where am I wrong here?

You are right, but note the 2 possible ways in which the alternative path
can be taken in the prior code we discussed, this should ensure we complain
if upon a load the module is really not present. From what I recall from
my testing it turns out though that in practice this *still* is still allowing
for the case where iwlmvm loads prior to iwlwifi's async fw callback code
checks for the opmode. One can test this with a loop of:

modprobe -r iwlmvm; while true; do modprobe iwlmvm; modprobe -r iwlmvm; dmesg -c && echo ; done

Prior to this add a check for an empty list on the opmode registration, if its
empty then we've hit the path discussed. In the loop above we are *triggering*
the load of iwlmvm first, that's why it *can* load first. If we wanted to ensure
iwlmvm and other other opmode load second we can add a simply symbol dependency
from the opmodes to the iwlwifi driver.

  Luis
