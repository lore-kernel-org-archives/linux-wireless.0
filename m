Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60583 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZDFLFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 07:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <200904061251.10965.helmut.schaa@gmail.com>
References: <1238923439.4120.9.camel@localhost.localdomain>
	 <200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi>
	 <200904061251.10965.helmut.schaa@gmail.com>
Date: Mon, 6 Apr 2009 14:05:46 +0300
Message-ID: <da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com> (sfid-20090406_130554_559920_D169E5AC)
Subject: Re: ath9k becon loss messages
From: Kalle Valo <kalle.valo@iki.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 6, 2009 at 1:51 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Montag, 6. April 2009 schrieb Kalle Valo:
>
>> But ath9k nor iwlwifi don't support beacon filtering and this is a
>> problem in mac80211. We need to disable the beacon loss check in
>> mac80211, most probably by stopping the associated timer whenever
>> scanning.
>
> Yeah, but the first execution of the timer will then also detect
> beacon loss:
>
> 1006 =A0 if (!((local->hw.flags & IEEE80211_HW_BEACON_FILTER) &&
> 1007 =A0 =A0 =A0 =A0 (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
> 1008 =A0 =A0 =A0 time_after(jiffies,
> 1009 =A0 =A0 =A0 =A0 =A0 =A0ifmgd->last_beacon + IEEE80211_MONITORING=
_INTERVAL)) {
>
> If the scan took longer then IEEE80211_MONITORING_INTERVAL (=3D2 sec)=
 this
> condition will apply just after the scan finished.

Not if we do "mod_timer(&ifmgd->timer, jiffies +
IEEE80211_MONITORING_INTERVAL)" after the scan has finished. That way
there's enought time to receive beacons before the timer triggers.

> Maybe this issue could be
> avoided by making the beacon loss detection smarter then just checkin=
g if no
> beacon was received within the last two seconds.

Definitely the beacon loss logic should be smarter, but I think that
should be improved separately. I just have tried to do small changes
at a time to avoid regressions and I didn't even consider improving
the beacon loss logic.

Kalle
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
