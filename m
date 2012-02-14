Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2BNVET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 16:04:19 -0500
Received: by iacb35 with SMTP id b35so419881iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 13:04:19 -0800 (PST)
Message-ID: <4F3ACC50.2000201@lwfinger.net> (sfid-20120214_220423_753666_60D90CB2)
Date: Tue, 14 Feb 2012 15:04:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ronald Wahl <ronald.wahl@raritan.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi/rtl8192cu: scheduling while atomic / sleeping function
 called from invalid context
References: <4F3A7F71.6000008@raritan.com>
In-Reply-To: <4F3A7F71.6000008@raritan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 09:36 AM, Ronald Wahl wrote:
> Hi,
>
> I just got the below traces with the rtlwifi driver in linux 3.2.5 and a
> rtl8192cu chip. It looks like that _usb_read_sync() and kmalloc(...,
> GFP_KERNEL) is called while the rcu lock is held inside
> rtl92c_dm_refresh_rate_adaptive_mask.

--snip--

> I hope you can fix this.

Thanks to your analysis, it was easy. Routine 
rtl92c_dm_refresh_rate_adaptive_mask() makes a callback to 
rtlpriv->cfg->ops->update_rate_tbl() with the lock held. For rtl8192ce, it is 
OK, but rtl8192cu kmallocs a data buffer. The irony is that rtl8192cu does not 
use the ieee80211_sta struct, which is what is being locked. The quick fix is to 
release the lock in the affected routine and reacquire it before the exit. The 
real fix will be to redefine the callback routines. That will be done for 3.4, 
but we need to get 3.2 and 3.3 fixed first.

Could you please test this patch?

Thanks,

Larry

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -2010,6 +2010,7 @@ void rtl92cu_update_hal_rate_table(struc
  	u8 curshortgi_20mhz = mac->sgi_20;
  	enum wireless_mode wirelessmode = mac->mode;

+	rcu_read_unlock();
  	ratr_value |= ((*(u16 *) (mcsrate))) << 12;
  	switch (wirelessmode) {
  	case WIRELESS_MODE_B:
@@ -2061,6 +2062,7 @@ void rtl92cu_update_hal_rate_table(struc
  	rtl_write_dword(rtlpriv, REG_ARFR0 + ratr_index * 4, ratr_value);
  	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
  		 rtl_read_dword(rtlpriv, REG_ARFR0));
+	rcu_read_lock();
  }

  void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
