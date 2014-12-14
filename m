Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34140 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaLNJZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 04:25:48 -0500
Message-ID: <548D5799.306@broadcom.com> (sfid-20141214_102616_048665_B9A73C12)
Date: Sun, 14 Dec 2014 10:25:45 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: report new station / assoc event for the correct
 BSS
References: <1417878395-19235-1-git-send-email-zajec5@gmail.com> <CACna6rxzRg3oak6Zg=KDV2LyRQfobS40oEWdESXAqXC6YVHTJA@mail.gmail.com>
In-Reply-To: <CACna6rxzRg3oak6Zg=KDV2LyRQfobS40oEWdESXAqXC6YVHTJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/14 23:31, Rafał Miłecki wrote:
> On 6 December 2014 at 16:06, Rafał Miłecki<zajec5@gmail.com>  wrote:
>> drv->ctx always points to the first BSS and we should report event using
>> BSS related to the interface we got NL80211_CMD_NEW_STATION from.
>> This fixes STA association for drivers using NL80211_CMD_NEW_STATION and
>> multiple virtual interfaces.
>>
>> Before:
>> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0-1 (ifindex:7)
>> nl80211: New station 02:00:00:00:01:00
>> wlan0: STA 02:00:00:00:01:00 IEEE 802.11: associated
>>
>> After:
>> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0-1 (ifindex:7)
>> nl80211: New station 02:00:00:00:01:00
>> wlan0-1: STA 02:00:00:00:01:00 IEEE 802.11: associated
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>> Hi guys :)
>>
>> I recently heard about possible problems with handling BSS-es from Arend and was
>> working with nl80211 / hostapd anyway, so decided to take a look at this.
>>
>> I think I found some bug in handling events that can be exposed when using
>> multiple virtual interfaces, hardware authentication and cfg80211_new_sta (which
>> gets translated into NL80211_CMD_NEW_STATION).
>>
>> As you can see in the log called "Before", hostapd was getting event from
>> wlan0-1 but then association was happening on the wlan0. This was breaking AP
>> mode on virtual interfaces (BSS other than the first one).
>>
>> Please note, that this bug (I believe it's a bug) won't be exposed when running
>> mac80211_hwsim. In such case authentication is handled in hostapd and assoc
>> happens in handle_assoc_cb (not hostapd_notif_assoc) which handles BSS-es
>> correctly.
>>
>> If you review this patch and it appears to be OK, I guess we will need similar
>> modification for other events.
>
> Any opinions on this?

I would say you are right in your analysis. I have not tried this patch. 
I will ask Hante as he added Multiple-BSSID support. I assume this bug 
is not visible to any mac80211-based driver, right?

Regards,
Arend
