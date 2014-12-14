Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39873 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaLNULN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 15:11:13 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so9652655ieb.21
        for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2014 12:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548D5799.306@broadcom.com>
References: <1417878395-19235-1-git-send-email-zajec5@gmail.com>
	<CACna6rxzRg3oak6Zg=KDV2LyRQfobS40oEWdESXAqXC6YVHTJA@mail.gmail.com>
	<548D5799.306@broadcom.com>
Date: Sun, 14 Dec 2014 21:11:12 +0100
Message-ID: <CACna6rzaYZux2070CpL_z5_ARSzZAnHfTRXaxauRhPnE48A9LQ@mail.gmail.com> (sfid-20141214_211118_958987_1DD8CB9F)
Subject: Re: [PATCH] nl80211: report new station / assoc event for the correct BSS
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 December 2014 at 10:25, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/13/14 23:31, Rafał Miłecki wrote:
>>
>> On 6 December 2014 at 16:06, Rafał Miłecki<zajec5@gmail.com>  wrote:
>>>
>>> drv->ctx always points to the first BSS and we should report event using
>>> BSS related to the interface we got NL80211_CMD_NEW_STATION from.
>>> This fixes STA association for drivers using NL80211_CMD_NEW_STATION and
>>> multiple virtual interfaces.
>>>
>>> Before:
>>> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0-1
>>> (ifindex:7)
>>> nl80211: New station 02:00:00:00:01:00
>>> wlan0: STA 02:00:00:00:01:00 IEEE 802.11: associated
>>>
>>> After:
>>> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0-1
>>> (ifindex:7)
>>> nl80211: New station 02:00:00:00:01:00
>>> wlan0-1: STA 02:00:00:00:01:00 IEEE 802.11: associated
>>>
>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>> ---
>>> Hi guys :)
>>>
>>> I recently heard about possible problems with handling BSS-es from Arend
>>> and was
>>> working with nl80211 / hostapd anyway, so decided to take a look at this.
>>>
>>> I think I found some bug in handling events that can be exposed when
>>> using
>>> multiple virtual interfaces, hardware authentication and cfg80211_new_sta
>>> (which
>>> gets translated into NL80211_CMD_NEW_STATION).
>>>
>>> As you can see in the log called "Before", hostapd was getting event from
>>> wlan0-1 but then association was happening on the wlan0. This was
>>> breaking AP
>>> mode on virtual interfaces (BSS other than the first one).
>>>
>>> Please note, that this bug (I believe it's a bug) won't be exposed when
>>> running
>>> mac80211_hwsim. In such case authentication is handled in hostapd and
>>> assoc
>>> happens in handle_assoc_cb (not hostapd_notif_assoc) which handles BSS-es
>>> correctly.
>>>
>>> If you review this patch and it appears to be OK, I guess we will need
>>> similar
>>> modification for other events.
>>
>>
>> Any opinions on this?
>
>
> I would say you are right in your analysis. I have not tried this patch. I
> will ask Hante as he added Multiple-BSSID support. I assume this bug is not
> visible to any mac80211-based driver, right?

Yes. What I wrote about mac80211_hwsim applies to (almost?) all
mac80211 drivers (they usually don't handle authentication in
hardware).

-- 
Rafał
