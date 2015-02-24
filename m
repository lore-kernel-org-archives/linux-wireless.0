Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:53011 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbbBXC32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 21:29:28 -0500
Received: by mail-qa0-f52.google.com with SMTP id v10so25125147qac.11
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 18:29:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
References: <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
	<CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
	<20150223224305.GA30228@w1.fi>
	<21739.50662.902775.901924@gargle.gargle.HOWL>
	<CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
Date: Tue, 24 Feb 2015 13:29:27 +1100
Message-ID: <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com> (sfid-20150224_032931_684983_163FA7FD)
Subject: Re: AR9462 problems connecting again..
From: Andrew McGregor <andrewmcgr@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Jouni Malinen <j@w1.fi>, Adrian Chadd <adrian@freebsd.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sorry to send HTML the first time... oops)

Over the weekend I found a bug in minstrel-ht that might well be
implicated here.

The last retransmit rate is meant to be a 'get the packet there
reliably' rate; minstrel-ht doesn't do that right, and can pick a
fairly flaky rate instead.

Can't generate a proper patch right now, so this diff might not apply
cleanly, but the fix is simply to change 75 to 99 in the two places
below:

@@ -437,7 +448,7 @@ minstrel_ht_set_best_prob_rate(struct mi
     (max_tp_group != MINSTREL_CCK_GROUP))
  return;

- if (mrs->prob_ewma > MINSTREL_FRAC(75, 100)) {
+ if (mrs->prob_ewma > MINSTREL_FRAC(99, 100)) {
  cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx);
  if (cur_tp_avg > tmp_tp_avg)
  mi->max_prob_rate = index;
@@ -526,7 +537,7 @@ minstrel_ht_prob_rate_reduce_streams(str
  * Rules for rate selection:
  *  - max_prob_rate must use only one stream, as a tradeoff between delivery
  *    probability and throughput during strong fluctuations
- *  - as long as the max prob rate has a probability of more than 75%, pick
+ *  - as long as the max prob rate has a probability of more than 99%, pick
  *    higher throughput rates, even if the probablity is a bit lower
  */
 static void

On Tue, Feb 24, 2015 at 11:29 AM, Sujith Manoharan <sujith@msujith.org> wrote:

> Jouni Malinen wrote:
>
> > Even I think that this goes a bit too far especially on 2.4 GHz band,
>
> > but I would actually consider limiting EAPOL frames to using non-HT/VHT
>
> > (e.g., 6 Mbps OFDM at least for EAPOL-Key frames) to avoid some
>
> > interoperability issues. I would say that the current minstrel_ht
>
> > behavior is somewhat excessive for EAPOL-Key frames in the other
>
> > direction. Using MCS 14 with fallback to something like MCS 5 for the
>
> > second Data frame after an association can certainly fail.
>
> >
>
> > Number of Linux drivers do already limit EAPOL frame TX rate, so this
>
> > specific item is mainly applicable only to driver that use minstrel from
>
> > mac80211 (e.g., ath9k). Though, that IEEE80211_TX_CTL_USE_MINRATE would
>
> > likely affect most mac80211 drivers.
>
>
> We had this in the ath9k RC, where EAPOL frames were sent out at min-rate
>
> on the VO queue. I think instead of re-introducing it in the driver,
>
> having it in minstrel is cleaner.
>
>
> Sujith
>
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
