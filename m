Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:53927 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYDNVFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 17:05:03 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1702353fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 14:04:59 -0700 (PDT)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: mac80211 hardware encryption
Date: Mon, 14 Apr 2008 23:07:48 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <200804141827.50991.IvDoorn@gmail.com> <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
In-Reply-To: <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804142307.48550.IvDoorn@gmail.com> (sfid-20080414_220655_459325_212C3ADC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 April 2008, Tomas Winkler wrote:
> On Mon, Apr 14, 2008 at 7:27 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Hi,
> >
> > I've implemented the steps for hardware encryption
> > including the part where the IV/EIV is being moved around.
> >
> > I now have a different problem, the hw_key_idx is u8,
> > so is very limited to what can be stored in it. I am trying
> > to find a solution for the following problem without increasing
> > the size of hw_key_idx since it is also used in the ieee80211_tx_control
> > structure which should remain as small as possible to fix in skb->cb.
> >
> > The problem is as follows:
> > rt61pci, rt73usb, rt2800pci and rt2800usb support both shared keys
> > as well as pairwise keys. When the "address" argument of set_key()
> > is a valid MAC address, then the key is considered to be pairwise,
> > otherwise it is a shared key.
> >
> > rt61pci and rt73usb supports:
> > shared keys: 16 (4 per allowed virtual interface)
> > pairwise keys: 64 (16 per allowed virtual interface)
> >
> > rt2800pci and rt2800usb supports:
> > shared keys: 32 (4 per allowed virtual interface)
> > pairwise keys: 256 (32 per allowed virtual interface)
> >
> > This means that the hw_key_idx with rt2800 hardware is already
> > full when all keys are being supported. I am thinking of adding a flag
> > to the key structure and ieee80211_tx_control structure to indicate
> > if the key is shared or pairwise. This will safe 1 bit that otherwise has
> > to be reserved from the hw_key_idx.
> > Do you agree with such a flag addition, or should the driver not care
> > about pairwise vs. shared.
> >
> > But now the fun part begins, the hardware needs the ieee80211_key_alg value
> > for encryption (don't ask why, the algorithm is also stored in the register
> > so it should be easy for the hardware to look it up directly).
> > What should be the best way to obtain this algorithm, should a callback
> > function be added, or should the driver keep a list in memory for all
> > added keys (which would be memory duplication since mac80211 also
> > has it in memory).
> >
> > Thanks,
> >
> >
> Not sure what was intention for hw_key_idx but currently there are assignment
> from key->conf.keyidx to hw_key_idx and visa versa.  keyidx is used
> for 802.11 key index [1..4]
> So it's quit risky to use it for something else

That souds like a bug in mac80211 then. hw_key_idx is for internal use for the driver,
and mac80211 should never expect the driver to set it to a particular value.
Otherwise drivers won't be able to differentiate between keys for particular interfaces,
or pairwise keys, which should be supported since mac80211 passes the address argument
for a reason ;)

Ivo
