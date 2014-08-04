Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward11.mail.yandex.net ([95.108.130.93]:38764 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaHDLFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 07:05:04 -0400
From: =?koi8-r?B?4c7E0sXF1yDzxdLHxco=?= <flat343@yandex.ru>
To: Larry Finger <larry.finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <53DE6036.1000903@lwfinger.net>
References: <6570401407065155@web18g.yandex.ru> <53DE6036.1000903@lwfinger.net>
Subject: Re: Problem with wpasupplicant using nl80211 driver for wi-fi stick with REALTEK 8188 chipset
MIME-Version: 1.0
Message-Id: <9590711407149913@web26j.yandex.ru> (sfid-20140804_130508_676843_4EBBD2BF)
Date: Mon, 04 Aug 2014 14:58:33 +0400
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day to all, 
Thank you Larry, 
lsusb gives the following output:
Realtek Semiconductor Corp. RTL8188CUS 802.11n WLAN Adapter. 
There is some problem with wpa_supplicant using nl80211 with this wi-fi dongle. Folks say that WEXT dirver works fine but I can not figure out how to remove usage on nl80211 completely...

03.08.2014, 20:15, "Larry Finger" <Larry.Finger@lwfinger.net>:
> On 08/03/2014 06:25 AM, áÎÄÒÅÅ× óÅÒÇÅÊ wrote:
>> šHello,
>> šA lot of folks experience problems with wpa_supplicant using nl80211 driver - tha does not work.
>> šThe particular problem is experienced on raspberry pi with wi-fi adapter on Realtek 8188 chipset.
>> šThe syslog shows the following lines:
>> ššwpa_supplicant[1118]: nl80211: 'nl80211' generic netlink not found
>> ššraspbmc wpa_supplicant[1118]: Failed to initialize driver 'nl80211'
>> ššraspbmc wpa_supplicant[1118]: rfkill: Cannot open RFKILL control device
>>
>> šI have tired to modify /etc/wpa_suppicant/functions.sh and remove nl80211 completely from code and leave only wext driver but that does not work.
>> šWould appreciate any ideas what the problem could be.
>>
>> šOS version: raspbian 3.12.21
>>
>> šWPA supplicant version: 1.0-3
>
> What exactly do you mean by an 8188 chip? There are RTL8188EE, RTL8188CE, and
> RTL8188EU chips? You likely mean the last one, as the first two PCI chips have
> mac80211 drivers.
>
> If you want to use nl80211/cfg80211 commands with driver r8188eu, you will need
> to add the necessary code for that driver to support that API. Modifying the
> supplicant is probably not the way to go.
>
> On my x86_64 system, the standard supplicant works with NetworkManager and r8188eu.
>
> Larry
