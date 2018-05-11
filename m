Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbeEKVwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 17:52:54 -0400
Date: Fri, 11 May 2018 21:52:50 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jessica Yu <jeyu@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-integrity@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Rodriguez <andresx7@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/6] firmware: differentiate between signed regulatory.db
 and other firmware
Message-ID: <20180511215250.GJ27853@wotan.suse.de> (sfid-20180511_235308_730353_29D1512B)
References: <20180508173404.GG27853@wotan.suse.de>
 <1525865428.3551.175.camel@linux.vnet.ibm.com>
 <20180509191508.GR27853@wotan.suse.de>
 <1525895838.3551.247.camel@linux.vnet.ibm.com>
 <20180509212212.GX27853@wotan.suse.de>
 <1525903617.3551.281.camel@linux.vnet.ibm.com>
 <20180509234814.GY27853@wotan.suse.de>
 <1525917658.3551.322.camel@linux.vnet.ibm.com>
 <20180510232639.GF27853@wotan.suse.de>
 <1526014826.3414.46.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1526014826.3414.46.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2018 at 01:00:26AM -0400, Mimi Zohar wrote:
> On Thu, 2018-05-10 at 23:26 +0000, Luis R. Rodriguez wrote:
> > On Wed, May 09, 2018 at 10:00:58PM -0400, Mimi Zohar wrote:
> > > On Wed, 2018-05-09 at 23:48 +0000, Luis R. Rodriguez wrote:
> > > > On Wed, May 09, 2018 at 06:06:57PM -0400, Mimi Zohar wrote:
> > > 
> > > > > > > Yes, writing regdb as a micro/mini LSM sounds reasonable.  The LSM
> > > > > > > would differentiate between other firmware and the regulatory.db based
> > > > > > > on the firmware's pathname.
> > > > > > 
> > > > > > If that is the only way then it would be silly to do the mini LSM as all
> > > > > > calls would have to have the check. A special LSM hook for just the
> > > > > > regulatory db also doesn't make much sense.
> > > > > 
> > > > > All calls to request_firmware() are already going through this LSM
> > > > > hook.  I should have said, it would be based on both READING_FIRMWARE
> > > > > and the firmware's pathname.
> > > > 
> > > > Yes, but it would still be a strcmp() computation added for all
> > > > READING_FIRMWARE. In that sense, the current arrangement is only open coding the
> > > > signature verification for the regulatory.db file.  One way to avoid this would
> > > > be to add an LSM specific to the regulatory db
> > > 
> > > Casey already commented on this suggestion.
> > 
> > Sorry but I must have missed this, can you send me the email or URL where he did that?
> > I never got a copy of that email I think.
> 
> My mistake.  I've posted similar patches for kexec_load and for the
> firmware sysfs fallback, both call security_kernel_read_file().
> Casey's comment was in regards to kexec_load[1], not for the sysfs
> fallback mode.  Here's the link to the most recent version of the
> kexec_load patches.[2]
> 
> [1] http://kernsec.org/pipermail/linux-security-module-archive/2018-May/006690.html
> [2] http://kernsec.org/pipermail/linux-security-module-archive/2018-May/006854.html

It seems I share Eric's concern on these threads are over general architecture,
below some notes which I think may help for the long term on that regards.

In the firmware_loader case we have *one* subsystem which as open coded firmware
signing -- the wireless subsystem open codes firmware verification by doing two
request_firmware() calls, one for the regulatory.bin and one for regulatory.bin.p7s,
and then it does its own check. In this patch set you suggested adding
a new READING_FIRMWARE_REGULATORY_DB. But your first patch in the series also
adds READING_FIRMWARE_FALLBACK for the fallback case where we enable use of
the old syfs loading facility.

My concerns are two fold for this case:

a) This would mean adding a new READING_* ID tag per any kernel mechanism which open
codes its own signature verification scheme.

b) The way it was implemented was to do (just showing
READING_FIRMWARE_REGULATORY_DB here):

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index eb34089e4299..d7cdf04a8681 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -318,6 +318,11 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv)
                        break;
                }

+#ifdef CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
+               if ((strcmp(fw_priv->fw_name, "regulatory.db") == 0) ||
+                   (strcmp(fw_priv->fw_name, "regulatory.db.p7s") == 0))
+                       id = READING_FIRMWARE_REGULATORY_DB;
+#endif
                fw_priv->size = 0;
                rc = kernel_read_file_from_path(path, &fw_priv->data, &size,
                                                msize, id);

This is eye-soring, and in turn would mean adding yet more #ifdefs for any
code on the kernel which open codes other firmware signing efforts with
its own kconfig...

I gather from reading the threads above that Eric's concerns are the re-use of
an API for security to read files for something which is really not a file, but
a binary blob of some sort and Casey's rebuttal is adding more hooks for small
things is a bad idea.

In light of all this I'll say that the concerns Eric has are unfortunately
too late, that ship has sailed eons ago. The old non-fd API for module loading
init_module() calls       security_kernel_read_file(NULL, READING_MODULE). Your
patch in this series adds security_kernel_read_file(NULL, READING_FIRMWARE_FALLBACK)
for the old syfs loading facility.

So in this regard, I think we have no other option but what you suggested, to
add a wrapper, say a security_kernel_read_blob() wrapper that calls
security_kernel_read_file(NULL, id); and make the following legacy calls use
it:

  o kernel/module.c for init_module()
  o kexec_load()
  o firmware loader sysfs facility

I think its fair then to add a new READING entry per functionality here
*but* with the compromise that we *document* that such interfaces are
discouraged, in preference for interfaces where at least the fd can be
captured some how. This should hopefully put a stop gap to such interfaces.

Then as for my concern on extending and adding new READING_* ID tags
for other future open-coded firmware calls, since:

a) You seem to be working on  a CONFIG_IMA_APPRAISE_FIRMWARE which would
enable similar functionality as firmware signing but in userspace

b) CONFIG_CFG80211_REQUIRE_SIGNED_REGDB was added to replace needing
CRDA, with an in-kernel interface. CRDA just did a signature check on
the regulatory.bin prior to tossing regulatory data over the kernel.

c) We've taken a position to *not* implement generic firmware singing
upstream in light of the fact that UEFI has pushed hw manufacturers
to implement FW singing in hardware, and for devices outside of these
we're happy to suggest IMA use.

d) It may be possible to have CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
depend on !CONFIG_IMA_APPRAISE_FIRMWARE this way we'd take a policy
that CONFIG_IMA_APPRAISE_FIRMWARE replaces in-kernel open coded
firmware singing facilities

Then I think it makes sense to adapt a policy of being *very careful* allowing
future open coded firmware signing efforts such as
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB, and recommend folks to do work for things
like this through IMA with CONFIG_IMA_APPRAISE_FIRMWARE. This would limit our
needs to extend READING_* ID tags for new open coded firmwares.

Then as for the eye-sore you added for CONFIG_CFG80211_REQUIRE_SIGNED_REGDB,
in light of all this, I accept we have no other way to deal with it but with
#ifdefs.. however it could be dealt with, as helpers where if
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB is not set we just set the id to
READING_FIRMWARE, ie, just keep the #ifdefs out of the actual code we read.
Perhaps it makes sense to throw this check into the helper:

        /* Already populated data member means we're loading into a buffer */
        if (fw_priv->data) {
                id = READING_FIRMWARE_PREALLOC_BUFFER;
                msize = fw_priv->allocated_size;
        }

PS: the work Alexei is doing with fork_usermode_blob() may sound similar
to the above legacy cases, but as I have noted before -- it already uses
an LSM hook to vet the data loaded as the data gets loaded as module.

  Luis
