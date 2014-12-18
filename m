Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41589 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLRNvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 08:51:50 -0500
Message-ID: <1418910705.6134.7.camel@sipsolutions.net> (sfid-20141218_145153_594429_B03B997C)
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Date: Thu, 18 Dec 2014 14:51:45 +0100
In-Reply-To: <CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com> (sfid-20141218_144439_055976_B01A1198)
References: <1418907095-10224-1-git-send-email-arend@broadcom.com>
	 <CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com>
	 (sfid-20141218_144439_055976_B01A1198)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-18 at 15:44 +0200, Eliad Peller wrote:
> >         u32 flags, regulatory_flags, features;
> > +       u8 ext_features[1];
> >
> i think it would be nicer to use unsigned long (instead of u8) along
> with BITS_TO_LONGS

That works in the kernel, but not in the userspace API. We can do it on
the kernel side, but then we have to write a translation loop in
nl80211. I'm not sure that's worth it.

> >  /**
> > + * enum nl80211_ext_feature_index - bit index of extended features.
> > + *
> > + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
> > + */
> > +enum nl80211_ext_feature_index {
> > +       NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
> > +};
> 
> just add the standard LAST/MAX defines here, and the bitmap size will
> be allocated automatically.

If you add a max here then we just have to hope that in userspace nobody
abuses it ... but I guess we can and should do that to size the flags
array properly automatically. The problem is that if somebody tries to
use it in userspace for parsing, like
  u8 eflags[DIV_ROUND_UP(FEATURE_MAX, 8)];
  memcpy(eflags, nla_data(attr), nla_len(attr));

then surely that will cause memory corruption... so we should probably
add a note or something there.

> and these (or only the implementations) could be replaced by set_bit/test_bit.

They could - but as I said above then we have to translate this to
userspace. The problem with the unsigned long array thing is that the
size of unsigned long varies on different platforms (32 vs 64 bit) and
not all platforms are little endian where that wouldn't matter ...

Maybe the better choice would be to create u8 bitmap helper functions -
after all we already have them in at least 2 other places in wifi:
 * TIM IE
 * extended capabilities IE

Probably there are others elsewhere?

johannes

