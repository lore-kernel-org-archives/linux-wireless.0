Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:54109 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcE0PIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 11:08:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wl3501_cs: avoid bogus gcc-6 warning
Date: Fri, 27 May 2016 17:08:33 +0200
Message-ID: <4731273.LDpWBaOjNT@wuerfel> (sfid-20160527_170859_037912_E167C290)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-6 on x86 started warning about wl3501_get_encode when building
with -O2:

drivers/net/wireless/wl3501_cs.c: In function ‘wl3501_get_encode’:
drivers/net/wireless/wl3501_cs.c:1769:5: warning: ‘implemented’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1686:19: warning: ‘threshold’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1702:20: warning: ‘threshold’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1719:23: warning: ‘txpow’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1752:20: warning: ‘retry’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1806:25: warning: ‘pwr_state’ may be used uninitialized in this function
drivers/net/wireless/wl3501_cs.c:1383:24: warning: ‘value’ may be used uninitialized in this function

I could not figure out what exactly confuses gcc here, but splitting the
wl3501_get_mib_value function into two helps the compiler to figure out
that the variables are not actually used uninitialized, and makes it
slightly clearer to a human reader what the function actually does and
which parts of it are under the spinlock.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 13fd734b61ec..82d94f83b6b4 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -378,8 +378,7 @@ static int wl3501_esbq_exec(struct wl3501_card *this, void *sig, int sig_size)
 	return rc;
 }
 
-static int wl3501_get_mib_value(struct wl3501_card *this, u8 index,
-				void *bf, int size)
+static int wl3501_request_mib(struct wl3501_card *this, u8 index, void *bf)
 {
 	struct wl3501_get_req sig = {
 		.sig_id	    = WL3501_SIG_GET_REQ,
@@ -395,20 +394,32 @@ static int wl3501_get_mib_value(struct wl3501_card *this, u8 index,
 			wl3501_set_to_wla(this, ptr, &sig, sizeof(sig));
 			wl3501_esbq_req(this, &ptr);
 			this->sig_get_confirm.mib_status = 255;
-			spin_unlock_irqrestore(&this->lock, flags);
-			rc = wait_event_interruptible(this->wait,
-				this->sig_get_confirm.mib_status != 255);
-			if (!rc)
-				memcpy(bf, this->sig_get_confirm.mib_value,
-				       size);
-			goto out;
+			rc = 0;
 		}
 	}
 	spin_unlock_irqrestore(&this->lock, flags);
-out:
+
 	return rc;
 }
 
+static int wl3501_get_mib_value(struct wl3501_card *this, u8 index,
+				void *bf, int size)
+{
+	int rc;
+
+	rc = wl3501_request_mib(this, index, bf);
+	if (rc)
+		return rc;
+
+	rc = wait_event_interruptible(this->wait,
+		this->sig_get_confirm.mib_status != 255);
+	if (rc)
+		return rc;
+
+	memcpy(bf, this->sig_get_confirm.mib_value, size);
+	return 0;
+}
+
 static int wl3501_pwr_mgmt(struct wl3501_card *this, int suspend)
 {
 	struct wl3501_pwr_mgmt_req sig = {

