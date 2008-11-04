Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:23761 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYKDTXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 14:23:40 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1258934ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 11:23:38 -0800 (PST)
Message-ID: <43e72e890811041115v1f7901a0w36593f9852d03c86@mail.gmail.com> (sfid-20081104_202343_993574_CD7D1390)
Date: Tue, 4 Nov 2008 11:15:26 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: No ProbeResp - assume out of range
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081104181958.GA22897@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <20081104181958.GA22897@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 10:19 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Nov 02, 2008 at 01:05:56PM -0800, Luis R. Rodriguez wrote:
>> I'm curious if others are getting this frequently as I am:
>>
>> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
>>
>> I get this with ath5k and ath9k, can be triggered easily in ath5k by
>> doing a lot of consecutive:
>>
>> iwlist wlan0 scan
>>
>> I have to check if I can trigger this with ath9k by scanning too. We
>> were seeing this with ath9k but were thinking it was ath9k related as
>> it can be triggered on it after doing a large TX. Wondering if this is
>> more of a generic and mac80211 issue.
>
> I'm seeing this all the time with ath9k.  For now I'm running with the
> following local hack:
>
> Index: linux-2.6/net/mac80211/mlme.c
> ===================================================================
> --- linux-2.6.orig/net/mac80211/mlme.c  2008-11-04 18:10:41.000000000 +0100
> +++ linux-2.6/net/mac80211/mlme.c       2008-11-04 18:10:56.000000000 +0100
> @@ -972,7 +972,7 @@ static void ieee80211_associated(struct
>                                       "current AP %s - assume out of "
>                                       "range\n",
>                                       sdata->dev->name, print_mac(mac, ifsta->bssid));
> -                               disassoc = 1;
> +//                             disassoc = 1;
>                        } else
>                                ieee80211_send_probe_req(sdata, ifsta->bssid,
>                                                         ifsta->ssid,
>
> which makes the problem of an actual disassociation after this message
> go away which made wireless completely unuseable with -rc3 for.  Given
> that the message never appears a second time just increasing the time
> it appears that just increasing IEEE80211_MONITORING_INTERVAL should
> fix the problem, too.

I posted a patch which enables beacons to be received by the STA --
this however, as was pointed out by the patch that disabled the beacon
filter on ath5k (note not ath9k, but ath9k also had it disabled),
increases the number of interrupts on the device, as it seems it
enables beacons not only for the BSSID you are on but for all BSSIDs.
Not sure what other devices support and how their beacon filter, if
they have any, works. The patch I posted is a fix that works with what
mac80211 expects -- beacons. The way I'm inclined to resolve this
properly in mac80211 is so that we tell drivers to enable beacons in
STA mode (if it supports this, HW_CAP flag I guess) only after we miss
a probe reply, or while we are scanning, that way we can also listen
for beacons in case we want to roam away to another AP. Just throwing
some ideas out there. Any comments?

  Luis
