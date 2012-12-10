Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53225 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2LJVgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:36:20 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so2129011qaq.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:36:20 -0800 (PST)
Message-ID: <50C655D1.8070608@lwfinger.net> (sfid-20121210_223624_555065_B5693885)
Date: Mon, 10 Dec 2012 15:36:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 8192cu misbehaviours with RTL8188RU chipset
References: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com> <50C61570.6040006@lwfinger.net> <CAMfPB_xV4fCK=G12EYKxgEDBYnOEEe45AmTFCBx67pKP4y+aYQ@mail.gmail.com> <CAMfPB_xBUDwmoHy4RiPZiCN7itYTHW9+n9eMj89YRrg-FkZrgQ@mail.gmail.com> <50C65059.9000501@lwfinger.net> <CAMfPB_xvLQk2Z1iD7e49iPhhxv+J2J8ZKmmr0+vjaXQ-xdcAsg@mail.gmail.com>
In-Reply-To: <CAMfPB_xvLQk2Z1iD7e49iPhhxv+J2J8ZKmmr0+vjaXQ-xdcAsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 03:16 PM, Alessandro Lannocca wrote:
> 2012/12/10 Larry Finger <Larry.Finger@lwfinger.net>:
>> modinfo rtl8172cu | grep -v alias
>
> Here you are:
>
> <snip>
>
> filename:
> /lib/modules/3.5.0-19-generic/updates/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
> firmware:       rtlwifi/rtl8192cufw.bin
> description:    Realtek 8192C/8188C 802.11n USB wireless
> license:        GPL
> author:         Larry Finger    <Larry.Finger@lwfinger.net>
> author:         Ziv Huang    <ziv_huang@realtek.com>
> author:         Georgia        <georgia@realtek.com>
> srcversion:     DB3CA4D8CA86F098980FA95
> depends:        rtlwifi,mac80211,rtl8192c-common,compat
> vermagic:       3.5.0-19-generic SMP mod_unload modversions 686
> parm:           swenc:Set to 1 for software crypto (default 0)
>   (bool)
> parm:           debug:Set debug level (0-5) (default 0) (int)

Your configuration probably does not include "CONFIG_RTLWIFI_DEBUG=y". Without 
that parameter being set, *ALL* the debug statements compile away.

Larry



