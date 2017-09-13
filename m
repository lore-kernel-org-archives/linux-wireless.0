Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34739 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750993AbdIMPBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Sep 2017 11:01:39 -0400
Received: by mail-oi0-f66.google.com with SMTP id v66so363111oig.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Sep 2017 08:01:39 -0700 (PDT)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: James Cameron <quozl@laptop.org>, linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170912220916.GB32211@us.netrek.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net> (sfid-20170913_170143_324901_1D343B8D)
Date: Wed, 13 Sep 2017 10:01:37 -0500
MIME-Version: 1.0
In-Reply-To: <20170912220916.GB32211@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2017 05:09 PM, James Cameron wrote:
> Summary: 40b368af4b75 ("rtlwifi: Fix alignment issues") breaks
> rtl8821ae keep alive, causing "Connection to AP lost" and deauth, but
> why?
> 
> Wireless connection is lost after a few seconds or minutes, on every
> OLPC NL3 laptop with rtl8821ae, with any stable kernel after 4.10.1,
> and any kernel with 40b368af4b75.
> 
> dmesg contains
> 
>    wlp2s0: Connection to AP 2c:b0:5d:a6:86:eb lost
> 
> iw event shows
> 
>    wlp2s0: del station 2c:b0:5d:a6:86:eb
>    wlp2s0 (phy #0): deauth 74:c6:3b:09:b5:0d -> 2c:b0:5d:a6:86:eb reason 4: Disassociated due to inactivity
>    wlp2s0 (phy #0): disconnected (local request)
> 
> Workaround is to bounce the link, then reconnect;
> 
>    ip link set wlp2s0 down
>    ip link set wlp2s0 up
>    iw dev wlp2s0 connect qz
> 
> A nearby monitor host captures a deauthentication packet sent by the
> device.
> 
> Bisection showed cause is 40b368af4b75 ("rtlwifi: Fix alignment
> issues") which changes the width of DBI register read.
> 
> On the face of it, 40b368af4b75 looks correct, especially compared
> against same function in rtl8723be.
> 
> I've no idea why reverting fixes the problem.  I'm hoping someone here
> might speculate and suggest ways to test.
> 
> As keep alive is set through this path, my guess is that keep alive is
> not being set in the device.  Or perhaps reading 16-bits perturbs
> another register.  Is there a way to test?
> 
> http://dev.laptop.org/~quozl/z/1drtGD.txt dmesg of 4.13
> 
> http://dev.laptop.org/~quozl/z/1drt7c.txt dmesg with 4.13 and revert
> of 40b368af4b75

James,

Thank you very much for making the effort to bisect this problem. I know that 
several people have reported the problem, which we cannot duplicate; however, 
most of them just say it drops the connection and do nothing more. In fact, we 
are lucky to have them even report which kernel version they are running!

As we do not see the problem, we will be relying on you to help diagnose the 
issue. Merely changing the read from 8 to 16 bits should not cause any change.

As _rtl8821ae_dbi_read() is only called from _rtl8821ae_enable_aspm_back_door(), 
we want to test turning off ASPM. The following patch will accomplish this. 
Unfortunately, the patch is white-space damaged, thus you will need to apply it 
manually. Please try it to see if it helps your connection loss. Note that ASPM 
settings are preserved through a module unload/reload sequence. Thus you will 
need to reboot after rebuilding the driver.

diff --git a/rtl8821ae/hw.c b/rtl8821ae/hw.c
index 305b3abbf..755d3704b 100644
--- a/rtl8821ae/hw.c
+++ b/rtl8821ae/hw.c
@@ -1982,8 +1982,8 @@ int rtl8821ae_hw_init(struct ieee80211_hw *hw)
         ppsc->rfpwr_state = ERFON;

         rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
-       _rtl8821ae_enable_aspm_back_door(hw);
-       rtlpriv->intf_ops->enable_aspm(hw);
+       //_rtl8821ae_enable_aspm_back_door(hw);
+       //rtlpriv->intf_ops->enable_aspm(hw);

         if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE &&
             (rtlhal->rfe_type == 1 || rtlhal->rfe_type == 5))


Thanks,

Larry
