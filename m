Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61659 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3BUODp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 09:03:45 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so7603186wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2013 06:03:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511E44B8.3000308@qca.qualcomm.com>
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
	<87ehghanxe.fsf@kamboji.qca.qualcomm.com>
	<CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com>
	<511E44B8.3000308@qca.qualcomm.com>
Date: Thu, 21 Feb 2013 15:03:43 +0100
Message-ID: <CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com> (sfid-20130221_150352_741943_52CEFF57)
Subject: Re: ath6kl: AR6004 failed to start on computer boot
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I just find a quick and dirty patch to workaround this issue.
I just reset the device on initialization failure.

I hope this helps to understand the real issue.

[    7.012514] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/bdata.bin
[    7.035276] cfg80211: World regulatory domain updated:
[    7.035287] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    7.035299] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.037916] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/fw-3.bin
[    9.378940] ath6kl: f59afe4c
[    9.379054] ath6kl: f59afe6c
[    9.379391] ath6kl_usb: probe of 1-7:1.0 failed with error -5
Here I reset the device.

[    9.380081] usbcore: registered new interface driver ath6kl_usb
[   10.396824] usb 1-7: USB disconnect, address 7
[   10.712160] usb 1-7: new high speed USB device using ehci_hcd and address 8
[   10.832491] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/bdata.bin
[   10.838218] usb 1-7: firmware: requesting ath6k/AR6004/hw1.3/fw-3.bin
[   11.026652] ath6kl: f5287c50

and it works..

---
drivers/net/wireless/ath/ath6kl/main.c | 1 +
drivers/net/wireless/ath/ath6kl/usb.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c
b/drivers/net/wireless/ath/ath6kl/main.c
index d0080b3..9060380 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -375,6 +375,7 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	if (status)
 		ath6kl_err("failed to reset target\n");
 }
+EXPORT_SYMBOL(ath6kl_reset_device);

 static void ath6kl_install_static_wep_keys(struct ath6kl_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c
b/drivers/net/wireless/ath/ath6kl/usb.c
index c7b87be..910bef9 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1121,6 +1121,7 @@ static int ath6kl_usb_probe(struct usb_interface
*interface,
 	ret = ath6kl_core_init(ar, ATH6KL_HTC_TYPE_PIPE);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core: %d\n", ret);
+                ath6kl_reset_device(ar, ar->target_type, true, true);
 		goto err_core_free;
 	}

--
Regards,
Julien
