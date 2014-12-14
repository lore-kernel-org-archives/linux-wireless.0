Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:47928 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaLNPqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 10:46:33 -0500
Date: Sun, 14 Dec 2014 17:46:29 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: report new station / assoc event for the
 correct BSS
Message-ID: <20141214154629.GC13745@w1.fi> (sfid-20141214_164638_021471_B31C1401)
References: <1417878395-19235-1-git-send-email-zajec5@gmail.com>
 <CACna6rxzRg3oak6Zg=KDV2LyRQfobS40oEWdESXAqXC6YVHTJA@mail.gmail.com>
 <548D5799.306@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <548D5799.306@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 14, 2014 at 10:25:45AM +0100, Arend van Spriel wrote:
> On 12/13/14 23:31, Rafał Miłecki wrote:
> >On 6 December 2014 at 16:06, Rafał Miłecki<zajec5@gmail.com>  wrote:
> >>drv->ctx always points to the first BSS and we should report event using
> >>BSS related to the interface we got NL80211_CMD_NEW_STATION from.
> >>This fixes STA association for drivers using NL80211_CMD_NEW_STATION and
> >>multiple virtual interfaces.

> >>As you can see in the log called "Before", hostapd was getting event from
> >>wlan0-1 but then association was happening on the wlan0. This was breaking AP
> >>mode on virtual interfaces (BSS other than the first one).

> >>If you review this patch and it appears to be OK, I guess we will need similar
> >>modification for other events.

> I would say you are right in your analysis. I have not tried this
> patch. I will ask Hante as he added Multiple-BSSID support. I assume
> this bug is not visible to any mac80211-based driver, right?

I think this is the first time I've heard of anyone using the multi-BSS
design where multiple BSSes are maintained within a single struct
hostapd_data instance with a driver that does not use hostapd as the AP
SME and MLME.  As such, this is getting to areas that have never been
even assumed to work.. Not that I have anything against making this
work, but it should be understood that this was not part of the criteria
for the event message design and yes, this would indeed require fixing
number of other places as well.

In practice, all cases where the driver takes care of authentication and
association frame exchanges have used multi-BSS design in a way that
hostapd gets two "radios" configured (e.g., two configuration files on
the command line, each pointing to a separate virtual interface). I'd
assume that could be used with nl80211 as well, but it may be reasonable
to extend the internal BSS control case (bss=<ifname> in hostapd.conf)
to provide a more consistent alternative for all drivers using the
nl80211 interface.

-- 
Jouni Malinen                                            PGP id EFC895FA
