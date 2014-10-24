Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45830 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbaJXTLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 15:11:15 -0400
Message-ID: <544AA3EE.7080806@gmail.com> (sfid-20141024_211138_057309_350B627C)
Date: Fri, 24 Oct 2014 17:09:34 -0200
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Mike Galbraith <umgwanakikbuti@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	troy_tan@realsil.com.cn, netdev@vger.kernel.org,
	Thadeu Cascardo <cascardo@cascardo.eti.br>
Subject: Re: [PATCH V3.18] rtlwifi: Add check for get_btc_status callback
References: <1414081629-23002-1-git-send-email-Larry.Finger@lwfinger.net>	 <1414087731.5231.19.camel@marge.simpson.net>	 <5449478B.4070908@lwfinger.net> <1414116580.23080.10.camel@marge.simpson.net> <544A80B5.1090604@lwfinger.net> <544A96C0.8030107@gmail.com>
In-Reply-To: <544A96C0.8030107@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2014 04:13 PM, Murilo Opsfelder Araujo wrote:
> On 10/24/2014 02:39 PM, Larry Finger wrote:
> [...]
>>
>> Please try the attached patch. It replaces the second one I sent you. I
>> will probably redo it before submitting the final copy, but this should
>> work.
>>
>> Larry
>>
> Hi, Larry.
>
> I've tried your patch on top of next-20141023 and it is still crashing
> on my laptop:
>
> http://opsfelder.com/~murilo/lkml/next-20141023_plus_larry_patch_v2.jpg
>
It seems a get_btc_status() check was still missing:

diff --git a/drivers/net/wireless/rtlwifi/pci.c 
b/drivers/net/wireless/rtlwifi/pci.c
index a5a350a..ed3364d 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1796,7 +1796,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
         rtl_pci_reset_trx_ring(hw);

         rtlpci->driver_is_goingto_unload = false;
-       if (rtlpriv->cfg->ops->get_btc_status()) {
+       if (rtlpriv->cfg->ops->get_btc_status &&
+           rtlpriv->cfg->ops->get_btc_status()) {
                 rtlpriv->btcoexist.btc_ops->btc_init_variables(rtlpriv);
                 rtlpriv->btcoexist.btc_ops->btc_init_hal_vars(rtlpriv);
         }

With this minor change and Larry's latest fix_misc_desc patch, 
next-20141023 booted normally and kernel panic disappeared.

Now, there is no wifi network available or found by wlan0.

-- 
Murilo
