Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:53482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDNWsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 18:48:12 -0400
Received: by fg-out-1718.google.com with SMTP id e12so849276fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 15:48:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239748653.4205.27.camel@johannes.local>
References: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com>
	<1239748653.4205.27.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 15 Apr 2009 00:47:55 +0200
Message-ID: <69e28c910904141547h129f379aoc6f632a6858e981b@mail.gmail.com> (sfid-20090415_004819_505142_9D129DE8)
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

2009/4/15 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-04-15 at 00:34 +0200, G=E1bor Stefanik wrote:
>> Set the total count of TX tries to 1 if IEEE80211_TX_CTL_NO_ACK is
>> set. This fixes a bug where mac80211 allowed the RC algo to request
>> drivers to forcibly retransmit NO_ACK (e.g. multicast) frames until
>> the excessive-retries limit is reached.
>
> Why not fix the rate control algorithms to use the no-ack flag instea=
d
> of is_multicast?

I was thinking about that originally, but we have 5 RC algorithms
(minstrel, pid, iwl-3945-rs, iwl-agn-rs & ath9k-rs) right now, with
possibly more to come for future N-based devices. Fixing them all
one-by-one would be much more tedious, and we will still not be
future-proof (that is, there is always the risk of getting a new
driver released with its own, specific RC algorithm that suffers from
this bug). This way, if e.g. Whatevercom releases a driver for its
WhateWIFI UltraMIMO1337 chipset with its own, buggy "whatever-rs"
algorithm, NO_ACK will still work properly for that driver.

>
>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>>
>> ---
>> Patch also available as attachment in case Gmail linewraps it.
>
> You need to get a proper MUA.

Well, if you know any MUA that does Gmail-style conversation
threading, and can sync its conversations with the Gmail web interface
(I need access to Gmail on the go, including from public computers
where I can't install a MUA), tell me immediately. So far, I've seen
no such thing.

>
> johannes
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
