Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59252 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZDNXHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 19:07:51 -0400
Received: by fxm2 with SMTP id 2so2659941fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 16:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910904141547h129f379aoc6f632a6858e981b@mail.gmail.com>
References: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com>
	<1239748653.4205.27.camel@johannes.local> <69e28c910904141547h129f379aoc6f632a6858e981b@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 15 Apr 2009 01:07:34 +0200
Message-ID: <69e28c910904141607n1e36472fg2c921afc0afe154e@mail.gmail.com> (sfid-20090415_010756_070483_CCB716C7)
Subject: Re: [PATCH RFC] mac80211: don't ask drivers to retry transmitting
	NO_ACK frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/15 G=E1bor Stefanik <netrolller.3d@gmail.com>:
> 2009/4/15 Johannes Berg <johannes@sipsolutions.net>:
>> On Wed, 2009-04-15 at 00:34 +0200, G=E1bor Stefanik wrote:
>>> Set the total count of TX tries to 1 if IEEE80211_TX_CTL_NO_ACK is
>>> set. This fixes a bug where mac80211 allowed the RC algo to request
>>> drivers to forcibly retransmit NO_ACK (e.g. multicast) frames until
>>> the excessive-retries limit is reached.
>>
>> Why not fix the rate control algorithms to use the no-ack flag inste=
ad
>> of is_multicast?
>
> I was thinking about that originally, but we have 5 RC algorithms
> (minstrel, pid, iwl-3945-rs, iwl-agn-rs & ath9k-rs) right now, with
> possibly more to come for future N-based devices. Fixing them all
> one-by-one would be much more tedious, and we will still not be
> future-proof (that is, there is always the risk of getting a new
> driver released with its own, specific RC algorithm that suffers from
> this bug). This way, if e.g. Whatevercom releases a driver for its
> WhateWIFI UltraMIMO1337 chipset with its own, buggy "whatever-rs"
> algorithm, NO_ACK will still work properly for that driver.

BTW, Minstrel specifically forces NO_ACK packets to be retried the
maximal allowed number of times.

rc80211_minstrel.c, line 246:
>	if (!sta || !mi || use_low_rate(skb)) {
>		ar[0].idx =3D rate_lowest_index(sband, sta);
>		ar[0].count =3D mp->max_retry;
>		return;
>	}

mp->max_retry =3D hw->max_rate_tries, or 7 if hw->max_rate_tries is 0.
The use_low_rate function is basically a check for NO_ACK.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
