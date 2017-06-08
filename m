Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43542 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdFHXRU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 19:17:20 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Question on setting key right after the EAPOL 4/4 is sent.
Message-ID: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com> (sfid-20170609_011745_603774_E92CC5C8)
Date: Thu, 8 Jun 2017 16:17:18 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe I found a problem that may be larger than my little sandbox.

The problem I see is that sometimes (and quite often when I am using lots
of vdevs and thus the NIC is busy), the keys are set before the EAPOL 4/4
hits the air.  When the key is set, the NIC will no longer transmit the
frame because of key-length issues in the tx-descriptor (ath10k wave-2
in this case).

If I add a sleep before setting the key, then it works much more
reliably.

I suspect that there is a fundamental race between the EAPOL packet-tx
logic and the key-set logic, but supplicant appears to act as though
they are natually synchronized.

So, any suggestions on how to do this right?

Thanks,
Ben

greearb@v-f24-64 hostap]$ git diff
diff --git a/src/rsn_supp/wpa.c b/src/rsn_supp/wpa.c
index 8a1d164..50a3006 100644
--- a/src/rsn_supp/wpa.c
+++ b/src/rsn_supp/wpa.c
@@ -1423,6 +1423,11 @@ static void wpa_supplicant_process_3_of_4(struct wpa_sm *sm,
         sm->renew_snonce = 1;

         if (key_info & WPA_KEY_INFO_INSTALL) {
+               /* Well now...what if the NIC hasn't actually put the 4/4 on the air
+                * yet?  If we set the key too soon, it is liable to corrupt the pkt being
+                * sent..   I don't know a good fix, but here is a hack.
+                */
+               os_sleep(0, 10000); /* sleep 10ms */
                 if (wpa_supplicant_install_ptk(sm, key))
                         goto failed;
         }


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
