Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:34704 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628AbZKYPhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:37:04 -0500
Received: by iwn1 with SMTP id 1so1306126iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 07:37:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911250941.10929.holgerschurig@gmail.com>
References: <200911250941.10929.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 25 Nov 2009 07:36:50 -0800
Message-ID: <43e72e890911250736l33afdf8ak1c806e5f5482f9da@mail.gmail.com>
Subject: Re: PROPOSAL: cfg80211 antenna selection
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 12:41 AM, Holger Schurig
<holgerschurig@gmail.com> wrote:
> Hi,
>
> I just wondered how we can do the antenna and diversity
> selection.
>
> Assumption: 32 antennas are enought
>
>
>
> My current idea is this:
>
>  struct cfg80211_ops {
> +int (*set_antennas)(struct wiphy *wiphy, struct net_device *dev,
> +                    u32 rx_antenna_mask, u32 tx_antenna_mask);
> +int (*get_antennas)(struct wiphy *wiphy, struct net_device *dev,
> +                    u32 *rx_antenna_mask, u32 tx_antenna_mask);
>  }
>
>  struct wiphy {
> +u8 max_antennas;
>  }

While at it might as well make this some configurable struct which the
drivers can add to the wiphy just as with the subbands. Also please
add the max antenna gain in mbi and start seeing if we can collect
this. On laptops with Atheros devices this would come from the EEPROM
so the driver should be able to set this upon initialization (probably
on hw init) and then cfg80211 can do more of the final computation to
the max eirp used.

Not sure how to get this from other cards. Anyone know how about on
b43, iwlwifi, rallink (I guess I can read the docs now :)) ?

Not sure if allowing for ops for chainmask setting would also be
helpeful here, that would need some review.

There is still one missing part to do a real final max eirp
computation on cfg80211 would be that of evaluation the CTL indexes if
there could be a common ground found amongst devices but last I tried
it seemed this was a pipe dream since other drivers do not expose any
of this, people working on certain drivers may not be aware of how
this is implemented on their devices yet or they may just use a
relatively conservative value for all edges.

Although a user should likely not be allowed to decrease the
configured eirp we *should* be able to allow user to increase it
through userspace as well to help with compliance to help adjust the
max eirp as well.

Finally, I theorize that if the antenna gain *was* indeed properly set
and this information was available even at some other level (say BIOS
and somehow we can extract that) it should technically then be
possible to put in the right code to technically allow swapping
wireless cards on laptops and perhaps then a solid argument can be
made against the silly BIOS locks put in place out there. The only
consideration which probably may not allow for this is calibration,
unless of course legislation would be OK with users doing calibration
themselves and if tools were available to the user.

  Luis
