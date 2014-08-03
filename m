Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41264 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaHCQPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 12:15:52 -0400
Received: by mail-oa0-f46.google.com with SMTP id m1so4330607oag.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 09:15:51 -0700 (PDT)
Message-ID: <53DE6036.1000903@lwfinger.net> (sfid-20140803_181555_198758_64623AF0)
Date: Sun, 03 Aug 2014 11:15:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?0JDQvdC00YDQtdC10LIg0KHQtdGA0LPQtdC5?=
	<flat343@yandex.ru>, linux-wireless@vger.kernel.org
Subject: Re: Problem with wpasupplicant using nl80211 driver for wi-fi stick
 with REALTEK 8188 chipset
References: <6570401407065155@web18g.yandex.ru>
In-Reply-To: <6570401407065155@web18g.yandex.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2014 06:25 AM, Андреев Сергей wrote:
> Hello,
> A lot of folks experience problems with wpa_supplicant using nl80211 driver - tha does not work. 
> The particular problem is experienced on raspberry pi with wi-fi adapter on Realtek 8188 chipset. 
> The syslog shows the following lines:
>  wpa_supplicant[1118]: nl80211: 'nl80211' generic netlink not found
>  raspbmc wpa_supplicant[1118]: Failed to initialize driver 'nl80211'
>  raspbmc wpa_supplicant[1118]: rfkill: Cannot open RFKILL control device
> 
> I have tired to modify /etc/wpa_suppicant/functions.sh and remove nl80211 completely from code and leave only wext driver but that does not work. 
> Would appreciate any ideas what the problem could be.
> 
> OS version: raspbian 3.12.21 
> 
> WPA supplicant version: 1.0-3

What exactly do you mean by an 8188 chip? There are RTL8188EE, RTL8188CE, and
RTL8188EU chips? You likely mean the last one, as the first two PCI chips have
mac80211 drivers.

If you want to use nl80211/cfg80211 commands with driver r8188eu, you will need
to add the necessary code for that driver to support that API. Modifying the
supplicant is probably not the way to go.

On my x86_64 system, the standard supplicant works with NetworkManager and r8188eu.

Larry

