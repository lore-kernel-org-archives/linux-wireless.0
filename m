Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36860 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbJAPmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 11:42:16 -0400
Subject: Re: rtl8821ae bisected regression between 4.1 and 4.2
To: =?UTF-8?Q?Jo=c3=a3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CA+A7VXW02GyRaFYw34CSim=WJrvF_fff5oK73JT1+bhRbv_B9g@mail.gmail.com>
Cc: Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stable <stable@vger.kernel.org>,
	Daniel Drake <drake@endlessm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <560D5455.8060400@lwfinger.net> (sfid-20151001_174220_928835_85E36087)
Date: Thu, 1 Oct 2015 10:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+A7VXW02GyRaFYw34CSim=WJrvF_fff5oK73JT1+bhRbv_B9g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040702090205060700050408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040702090205060700050408
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/01/2015 08:17 AM, João Paulo Rechi Vita wrote:
> Hello linux-wirelless (cc'ing stable since the original patch had
> cc:stable as well),
>
> I'm experiencing a CPU soft lockup while downloading when rtl8821ae is
> loaded (even when downloading through other adapters) on a vanilla 4.2
> kernel. The problem did not happen on vanilla 4.1. Bisecting shows the
> first bad commit being "rtlwifi: Remove the clear interrupt routine
> from all drivers" (1277fa2ab2f9a624a4b0177119ca13b5fd65edd0).
> Reverting that commit makes the problem go away.
>
> The system is perfectly stable until I start downloading, when the UI
> becomes unresponsive, sometimes leading to a complete freeze. When the
> system does not completely freezes and I'm able to kill the download,
> everything seems to go back to normal after killing it, and I am able
> to continue to use the computer as long as I do not download anything.
> Most of the time either a soft or a hard lockup is detected, but not
> always, although the freeze always occurs.
>
> This is the kernel log with lockdep enabled (although sometimes the
> problem does not occur with lockdep enabled):
> https://gist.github.com/jprvita/3aa2c0c9a66793e1fad1
>
> I have the laptop where this happens as a test machine sitting on my
> desk, so I'm available to test any patches or gather more information
> if needed. Please advise on how I can help debugging this further.

I cannot duplicate your result, and neither can the Realtek team; however, I 
have prepared and attached a patch to temporarily re-add the interrupt clear 
routine for rtl8821ae. Please try it and report the results.

Larry



--------------040702090205060700050408
Content-Type: text/x-patch;
 name="0001-rtlwifi-rtl8821ae-Trial-patch-to-reinstall-interrupt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-rtl8821ae-Trial-patch-to-reinstall-interrupt.pa";
 filename*1="tch"

>From 97ecd2789dc71b158467fc57d0326641a4581f0d Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 1 Oct 2015 10:37:49 -0500
Subject: [PATCH] rtlwifi: rtl8821ae: Trial patch to reinstall interrupt clear
 routine

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index b7f18e21..6d2caa8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -2253,11 +2253,27 @@ void rtl8821ae_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
+static void rtl8821ae_clear_interrupt(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 tmp = rtl_read_dword(rtlpriv, REG_HISR);
+
+	rtl_write_dword(rtlpriv, REG_HISR, tmp);
+
+	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
+	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
+
+	tmp = rtl_read_dword(rtlpriv, REG_HSISR);
+	rtl_write_dword(rtlpriv, REG_HSISR, tmp);
+}
+
 void rtl8821ae_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
+	rtl8821ae_clear_interrupt(hw);/*clear it here first*/
+
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
 	rtlpci->irq_enabled = true;
-- 
2.1.4


--------------040702090205060700050408--
