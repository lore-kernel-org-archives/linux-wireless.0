Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36213 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933580AbcIVPKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 11:10:02 -0400
Received: by mail-oi0-f43.google.com with SMTP id t83so100861376oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 08:10:02 -0700 (PDT)
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
To: Jean Delvare <jdelvare@suse.de>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <20160922115116.149c599c@endymion>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net> (sfid-20160922_171006_309408_5586DDDA)
Date: Thu, 22 Sep 2016 10:09:58 -0500
MIME-Version: 1.0
In-Reply-To: <20160922115116.149c599c@endymion>
Content-Type: multipart/mixed;
 boundary="------------6E0A5384EF9FD72921A2A4AD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------6E0A5384EF9FD72921A2A4AD
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 09/22/2016 04:51 AM, Jean Delvare wrote:
> Hello,
>
> I bought an Asus PCE-N10 PCIe Wi-Fi N card to install in my wife's
> computer. This morning it stopped working suddenly. Investigating the
> kernel logs, the following error message caught my eye:
>
> rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
>
> It was printed twice, 3.5 hours apart, the second time at the moment
> the network stopped working. I guess this is not supposed to happen.
> What additional information can I provide to help you debug the issue?
> That's the device:
>
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> 	Subsystem: ASUSTeK Computer Inc. Device [1043:84b5]
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
> 	I/O ports at e800 [size=256]
> 	Memory at febfc000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: rtl8192ce
> 	Kernel modules: rtl8192ce
>
> Kernel version is 4.5.4-1-default x86_64 (openSUSE Tumbleweed.)
>
> Reloading the rtl8192ce module and restarting the network service got
> everything back up.

Unfortunately, that message is not as helpful as it might be.

Do you build your own kernel, or are you using openSUSE's supplied version? If 
the latter, I will need to think how we might debug the issue. If the former, 
please add the attached patch.

Larry


--------------6E0A5384EF9FD72921A2A4AD
Content-Type: text/x-diff;
 name="rtl8192ce_debug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192ce_debug.diff"

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 04eb5c3..e0c7d36 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -143,7 +143,7 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+			 "switch case %d not processed\n", variable);
 		break;
 	}
 }

--------------6E0A5384EF9FD72921A2A4AD--
