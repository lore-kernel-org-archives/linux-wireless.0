Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:52063 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbbG2IDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 04:03:11 -0400
Date: Wed, 29 Jul 2015 10:03:06 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Driver for Mediatek MT7630E
Message-ID: <20150729100306.7d5d20af@north> (sfid-20150729_100432_193515_BACFBE4B)
In-Reply-To: <CACRpkdYTJWS7mbw_OJtW78ThQ6jZ7aSoM5uR1SLihV4L+E5vtQ@mail.gmail.com>
References: <55B80F21.3090803@gmail.com>
	<CACRpkdYTJWS7mbw_OJtW78ThQ6jZ7aSoM5uR1SLihV4L+E5vtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 29 Jul 2015 09:38:04 +0200, Linus Walleij wrote:
> On Wed, Jul 29, 2015 at 1:24 AM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
> > Linus Walleij wrote:
> >
> >> Did anything ever happen to this?
> >>
> >> My daughter has this device in her laptop it seems, sigh.
> >>
> >> I might start fiddling with it unless someone else is already
> >> doing it.
> >
> > Jakub Kicinski was working on it at: https://github.com/kuba-moo/mt7630e
> 
> Ah yeah that is what I have running. It's a fork of rt2x00 so it's
> missing all fixes since 3.11 or so, just a question of when this
> becomes unsupportable.

The rt2x00 does not change that much itself so it's not a biggie.
However, we are missing all the mac80211-related changes :/
 
> This code is a complete mashup of Linux and duct-taped Windows
> NDIS-based driver code, my eyes are bleeding from looking at it.
> 
> The defines etc patched in have obvious gaps due to other unsupported
> chips such as MT7601u I suspect. I guess it's necessary to also
> look at this in order to not screw things up for 7601.
> https://github.com/porjo/mt7601

The problem with this hardware is that it's a something between old
Ralink stuff and new AC devices which Felix is supporting in mt76,
just like mt7601u.  I started hacking on mt76 to add support but not
sure if Felix is interested in merging support for old chips there.

So the support for mt7630e could be added in three places,
theoretically: (1) rt2x00, (2) mt7601u, (3) mt76.  IMO they're all bad
choices.

Also MediaTek has no interest in supporting Open Source driver for this
device.
