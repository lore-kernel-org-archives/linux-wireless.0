Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:38744 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbbLALIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 06:08:31 -0500
Date: Tue, 1 Dec 2015 13:08:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
Message-ID: <20151201110827.GA4362@w1.fi> (sfid-20151201_120835_551617_2D35CEAC)
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
 <1448447567-12189-9-git-send-email-arend@broadcom.com>
 <87si3nkb2l.fsf@kamboji.qca.qualcomm.com>
 <565D5B77.7050501@broadcom.com>
 <87d1uqijnz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d1uqijnz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 01, 2015 at 11:48:32AM +0200, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
> > It solves a problem for us, but admittedly it is not something that is
> > very usable by user-space apps. So I guess what you are suggesting
> > here is to come up with a nl80211 api for this. On the mailing list
> > (or hostap list) the topic pops up from time to time so there are
> > people who would like to have such a knob to play with. Still would
> > like to keep the module parameter although its use may change when
> > nl80211 api is added.
> 
> I don't know what is the best approach, that's why I would like to hear
> opinions from others. Personally I don't like the idea of adding 802.11
> level configuration options to module parameters, but on the other hand
> I don't have any strong opinions about this.

I would like to see this as a new attribute to NL80211_CMD_CONNECT to
provide parameters for offloaded (driver and/or firmware) BSS selection
and roaming. If there is a driver that uses roaming offload with
NL80211_CMD_ASSOCIATE, the same attribute could be used there (but I'm
not sure how exact such offloading would work in practice since I'd
expect both authentication and (re)association to be offloaded).

> I guess we have two different designs, one where the roaming logic is in
> firmware and other where wpasupplicant is responsible for this. (And I
> assume that brcfmac belongs to the former group.) Ideally it would be
> nice that we would have a same configuration knob for both but I don't
> know if that's really feasible.

Both of these would work as long as wpa_supplicant has means for
providing such configuration to the driver in a generic manner. That
NL80211_CMD_CONNECT extension with a new optional attribute would be
such a generic design.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
