Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403Ab1CYLKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 07:10:11 -0400
Received: by bwz15 with SMTP id 15so808757bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 04:10:09 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Fri, 25 Mar 2011 12:08:22 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <1300987930.26265.6.camel@jlt3.sipsolutions.net> <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
In-Reply-To: <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103251208.22473.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 24. März 2011 schrieb Emmanuel Grumbach:
> On Thu, Mar 24, 2011 at 19:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2011-03-24 at 14:57 +0100, Helmut Schaa wrote:
> >
> >> I guess so, yes (as I wrote before this is an Intel 5100 client running Windows
> >> Vista and the latest Intel driver). It sends a nullfunc going to sleep and returns
> >> a few hundret ms later. And in the meantime I can see my rt2800 AP sending an
> >> AMPDU to the sleeping STA which of course times out and therefore ends up as
> >> filtered frame.
> >
> > Ok so it gets reported to mac80211.
> >
> >> > Maybe the PS buffer should be larger then?
> >>
> >> 128 frames per STA is already large, no? And also it's nothing unusual
> >> that some frames get dropped if the STA stays in powersave for a long time.
> >>
> >> > I don't see how we can lose a
> >> > frame due to rx/tx processing races either, how does that happen? I
> >> > thought we had the ability to avoid all those races now.
> >>
> >> Good point. Maybe this only happens with rt2x00. The frame exchange looks
> >> basically like (if you want to see the pcap just ask ;) ):
> >>
> >> STA -> AP  nullfunc PM=1
> >> AP -> STA  AMPDU (seqnr 3106 - 3112)
> >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
> >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
> >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
> >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
> >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
> >> ...
> >> STA -> AP nullfunc PM=0
> >> ...
> 
> Hold on, why do mac80211 send a frame to a sleeping station ?
> Am I stupid or is this buggy ?
> Johannes, is this the buggy behavior in PS you were pointing out later
> in your mail ?
> 
> 
> >> AP -> STA  AMPDU (seqnr 3108)
> >> STA -> AP  BlockAck
> >> AP -> STA  AMPDU (seqnr 3109 - 3114)
> >> STA -> AP  BlockAck
> >> ...
> >>
> >> As you can see 3106 and 3107 somehow got lost and thus leave a hole in
> >> the STAs reorder buffer leading to the strange behavior I described before.
> >
> > but if they are reported to mac80211 they should be put on the queue
> > again? Are they maybe not reported back quite in the right way?
> >
> >> > I don't know, you tell me, does it? :)
> >>
> >> Ha Ha ;)
> >>
> >> Sending a BAR at this point would at least ensure that the Intel STAs RX
> >> reorder buffer gets flushed (in case we dropped any frames while the STA was
> >> sleeping, which happened in this case).
> >
> > Right, but so far this looks like it's more like a bug in the powersave
> > code rather than something we desperately need to recover from with a
> > BAR.
> >
> 
> The originator tried to send data and this data didn't get acked. In
> this case a BAR should be sent regardless the reason why this frame
> didn't get acked.
> This is done by reporting IEEE80211_TX_STAT_AMPDU_NO_BACK to mac80211.

mac80211 isn't sending a BAR in the case above because of this code
in ieee80211_tx_status (status.c):

218                 acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
219                 if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
220                         /*
221                          * The STA is in power save mode, so assume
222                          * that this TX packet failed because of that.
223                          */
224                         ieee80211_handle_filtered_frame(local, sta, skb);
225                         rcu_read_unlock();
226                         return;
227                 }
...
233                 if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
234                     (ieee80211_is_data_qos(fc))) {
235                         u16 tid, ssn;
236                         u8 *qc;
237 
238                         qc = ieee80211_get_qos_ctl(hdr);
239                         tid = qc[0] & 0xf;
240                         ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
241                                                 & IEEE80211_SCTL_SEQ);
242                         ieee80211_send_bar(sta->sdata, hdr->addr1,
243                                            tid, ssn);
244                 }

So, if a frame failed because the STA entered PS state it will be added
to the filtered frames queue and no BAR will get generated.

However, if this was the case mac80211 should send out all filtered frames
after the STA wakes up again, which does not happen in the situation
above (3106 and 3107 got lost) :(

Generating the BAR also for filtered frames might improve the situation but
looks more like a workaround to me.

Still debugging the rt2800 tx status reporting.

Helmut
