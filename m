Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33084 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2DSRjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 13:39:08 -0400
Received: by ghrr11 with SMTP id r11so4642182ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 10:39:07 -0700 (PDT)
Message-ID: <4F904DB7.7030007@lwfinger.net> (sfid-20120419_193920_108510_5F995AC1)
Date: Thu, 19 Apr 2012 12:39:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Rtlwifi with hostapd
References: <CAKa7sPSOBYmaoCRZZa=R0UT59bD+cxmtSPqxZ6754CmarNfXzA@mail.gmail.com> <CAKa7sPQYpgmh+=nLWGNzaXRL4_wHmpY4pScuwk4kTmYKCyU6dg@mail.gmail.com>
In-Reply-To: <CAKa7sPQYpgmh+=nLWGNzaXRL4_wHmpY4pScuwk4kTmYKCyU6dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2012 03:25 AM, Viktar Palstsiuk wrote:
> Hello
>
> I'm trying to run RTL8192DE-based wifi module in AP mode using hostapd.
> RTL8192DE is connected to Marvell Kirkwood CPU using PCI Express bus.
> But the kernel hangs right after hostapd was started.
> In STA mode it is possible to scan for networks in 2.4 GHz band and it
> discovers ~10 APs.
> Was rtlwifi driver tested to work with hostapd?
> I've tried compat-wireless-2011-12-01 and
> 92ce_se_de_linux_mac80211_0005.1230.2011.tar.gz from Realtek site.

without knowing any details of the kernel hangs, it is impossible to know what 
might be wrong. If you switch to the logging console immediately upon starting 
hostapd, is anything reported on the screen?

I have not used the RTL8192DE as an AP, but the SE variety does work. There are 
some important fixes for AP mode that are not in compat-wireless as old as the 
one you are using. Please try a version from this week. Those fixes are also not 
included in the driver on the Realtek site.

What kernel version are you using? Is there a possibility to switch to the 
kernel from the wireless-testing git tree?

Larry

