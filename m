Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:46242 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab3IMN2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 09:28:42 -0400
Message-ID: <523312D0.3020001@ilande.co.uk> (sfid-20130913_153254_970901_AE23167C)
Date: Fri, 13 Sep 2013 14:27:44 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
References: <5232DAF0.6040907@ilande.co.uk> <52330CB4.7020902@ilande.co.uk>
In-Reply-To: <52330CB4.7020902@ilande.co.uk>
Subject: Re: rtl8192cu: testing with EdiMax USB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/09/13 14:01, Mark Cave-Ayland wrote:

>> I spent a bit more time tinkering further with debug=0x5, forgetting
>> that I had left your last diagnostic patch applied. Based upon when the
>> beacon output disappears in the logs (after updating the power
>> registers), it does seem likely that is a power-related problem.
>
> FWIW I just tried a quick test where I commented out the entire
> rtl92c_dm_txpower_tracking_callback_thermalmeter() function to make it a
> nop, and that didn't seem to make any difference...

Aha! The following diff to remove the call to rtl92c_dm_diginit() keeps 
me associated to the AP:

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c 
b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index d2d57a2..c18362d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1275,7 +1275,7 @@ void rtl92c_dm_init(struct ieee80211_hw *hw)
         struct rtl_priv *rtlpriv = rtl_priv(hw);

         rtlpriv->dm.dm_type = DM_TYPE_BYDRIVER;
-       rtl92c_dm_diginit(hw);
+       //rtl92c_dm_diginit(hw);
         rtl92c_dm_init_dynamic_txpower(hw);
         rtl92c_dm_init_edca_turbo(hw);
         rtl92c_dm_init_rate_adaptive_mask(hw);

However, dhclient still takes a very long time get an IP address and the 
connection seems extremely lossy, much like it was when I could get a 
connection before. Perhaps there are two different bugs here, one for 
the association and one for the data loss?


ATB,

Mark.
