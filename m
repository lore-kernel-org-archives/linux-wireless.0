Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37682 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab3CQVqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 17:46:32 -0400
Message-ID: <514639B3.4050700@openwrt.org> (sfid-20130317_224642_950575_751C3FCF)
Date: Sun, 17 Mar 2013 22:46:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org> <20130312094119.GA23062@magnum.frso.rivierawaves.com> <1363361818.8656.20.camel@jlt4.sipsolutions.net> <20130317212302.GA6886@gobelin>
In-Reply-To: <20130317212302.GA6886@gobelin>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-17 10:23 PM, Karl Beldan wrote:
> On Fri, Mar 15, 2013 at 04:36:58PM +0100, Johannes Berg wrote:
>> On Tue, 2013-03-12 at 10:41 +0100, Karl Beldan wrote:
>> > On Wed, Feb 13, 2013 at 10:51:08AM +0100, Felix Fietkau wrote:
>> > > When MCS rates start to get bad in 2.4 GHz because of long range or
>> > > strong interference, CCK rates can be a lot more robust.
>> > > 
>> > > This patch adds a pseudo MCS group containing CCK rates (long preamble
>> > > in the lower 4 slots, short preamble in the upper slots).
>> > > 
>> > With this, mac80211 might send CCK rates with IEEE80211_TX_CTL_AMPDU set.
>> > For aggregates, if we don't currently set NO_CCK, at the very least the
>> > 1st rate index should belong to an MCS_GROUP.
>> 
>> I guess that depends on how you expect rate control to work ... I'd
>> kinda expect the driver to skip aggregation then? I think only ath9k
>> even uses minstrel + aggregation?
>> 
> 
> This changes the meaning of IEEE80211_TX_CTL_AMPDU.
> With this there are more possible RC feedback pitfalls with the tx statuses 
> IEEE80211_TX_{CTL,STAT}_AMPDU flags.
> Regarding the drivers using minstrel + aggregation I can't really say, I
> know ath9k runs ok with it and at work I settled for minstrel too with a
> driver for our IP on a demo board.
It's important that the IEEE80211_TX_CTL_AMPDU flag is still set,
because the frame is still part of the BlockAck window, just sent with a
rate that doesn't allow aggregating it with other frames, so it is still
part of the A-MPDU session.
If there are any drivers that cannot easily be changed to support that,
we should have an explicit flag to disable using CCK with 802.11n stations.

- Felix
