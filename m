Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51498 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbcFURBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 13:01:25 -0400
Date: Tue, 21 Jun 2016 20:01:20 +0300
From: Jouni Malinen <j@w1.fi>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
Message-ID: <20160621170120.GA24882@w1.fi> (sfid-20160621_190131_756060_1D067478)
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi>
 <57673E10.7070706@gmail.com>
 <20160620212529.GA19076@w1.fi>
 <5768DBB6.2060501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5768DBB6.2060501@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2016 at 03:16:22PM +0900, Masashi Honma wrote:
> On 2016年06月21日 06:25, Jouni Malinen wrote:
> > What about RX side?
> 
> Previously, MGTK and IGTK was identical key.
> Now new wpa_supplicant can provide correct IGTK.

> I have tested with new IGTK, RX side can work without
> modification.

Please keep in mind that "working" here means two things:
(1) being able decrypt the frame,
(2) being able to reject the frame if it was not properly protected. It
is that (2) that is unlikely to be covered here..

We actually cover (2) for some cases by "accident" since
ieee80211_rx_h_decrypt() assigns rx->key to rx->sta->gtk[i] if one is
available. I'm not completely sure this is correct since it applies to
management frame as well, but that's the way commit
897bed8b4320774e56f282cdc1cceb4d77442797 ('mac80211: clean up RX key
checks') implemented it (Johannes: Could you please take a look whether
that gtk[] case was really supposed to apply for non-Data frames?).
Interestingly, even on the TX side, we had code that picked tx->key for
these group addressed Action frames, but that got then cleared later..

That said, if rx->sta->gtk[i] is not set for any value of i, we would
not enforce encryption of "group addressed privacy" Action frames as far
as I can tell. This may be a pretty small window since RX MGTK is
supposed to get set immediately for each peer. However, I would not be
surprised if there were indeed a window between adding the STA entry and
marking it authorized and configuring the RX MGTK. And even if this is
not possible, this should really be commented somewhere so that there is
less of a change of accidentally optimizing or cleaning up something
that is needed for this to be protected..

And when operating with PMF enabled, this is clearly broken, i.e., the
RX path accepts BIP protected version of the broadcast Mesh Action frame
while that frame needs to be rejected since it was not encrypted with
CCMP/GCMP.

To cover all these RX cases properly, I'd expect there to be RX path
changes that use ieee80211_is_group_privacy_action() and reject some
cases.. This should like be there in the !ieee80211_has_protected(fc)
case in ieee80211_rx_h_decrypt() before selecting the key and if
ieee80211_is_group_privacy_action() returns true, return RX_DROP_MONITOR
would be needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
