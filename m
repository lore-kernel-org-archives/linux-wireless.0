Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:38664 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3GAIfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 04:35:05 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>
Cc: <linux-wireless@vger.kernel.org>
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org>
In-Reply-To: <51CF3EC9.3000707@openwrt.org>
Subject: RE: [RFC v2] mac80211: Use libnl-configurable values for retry counts
Date: Mon, 1 Jul 2013 10:34:57 +0200
Message-ID: <000401ce7635$de99d1d0$9bcd7570$@acksys.fr> (sfid-20130701_103511_429445_849EB5AA)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Felix.

I am using the ath9k, but I have seen this in the b43 driver:

                rates[0].count = dev->wl->hw->conf.short_frame_max_tx_count;

Do you think that short/long_frame_max_tx_count should rather be applied at
the driver level (not mac80211) ?
The ath9k driver currently enforces a minimum retry count of 30 (constant),
it could be replaced with short/long_frame_max_tx_count ?

Jean-Pierre

> -----Message d'origine-----
> De : Felix Fietkau [mailto:nbd@openwrt.org]
> Envoyé : samedi 29 juin 2013 22:09
> À : Jean-Pierre Tosoni
> Cc : linux-wireless@vger.kernel.org
> Objet : Re: [RFC v2] mac80211: Use libnl-configurable values for retry
> counts
> 
> On 2013-06-27 6:40 PM, Jean-Pierre Tosoni wrote:
> > From: J.P. Tosoni <jp.tosoni@acksys.fr>
> >
> > In the rate control algorithms, the maximum retry count is limited by
> > a) a constant value obtained from the hardware driver
> > b) a constant limit (6ms) on the time allowed for all
> >    retries of each frame.
> >
> > Replace the retry count by existing configurable values from nl80211.
> > Use wiphy->retry_long for frames whose length exceed rts_threshold.
> > Use wiphy->retry_short for all other frames.
> > Check that the configured value does not exceed driver capabilities.
> > Use the new values as soon as the next frame is transmitted.
> >
> > Caveat: the retry count for frames sent outside the context of a STA is
> > still taken from the hardware driver.
> > ---
> > What I am seeking with this patch:
> > I believe the configuration of the retries will help making recovery
> > much faster when an AP (in infrastructure mode) or a peer (in mesh
> > mode) suddenly disappears.
> I'm all for reducing retries, but I think the way you're applying the
> limit is problematic.
> If minstrel decides to use many retries for a high rate and you're
> simply cutting off all retries that exceed the configured limit, you're
> potentially inviting quite a bit of unnecessary packet loss.
> I'm planning to remove the use of retry rate slot 4 (fallback to lowest
> rate) from minstrel, since max_prob_rate should already provide quite
> decent reliability.
> 
> - Felix

