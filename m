Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54572 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934983Ab0KQUR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 15:17:26 -0500
Subject: Re: [RFC][PATCH] b43: rfkill: use HI enabled bit for all devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1290023808-26672-1-git-send-email-zajec5@gmail.com> (sfid-20101117_145657_975544_E473BB3F)
References: <1290023808-26672-1-git-send-email-zajec5@gmail.com>
	 (sfid-20101117_145657_975544_E473BB3F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 21:17:20 +0100
Message-ID: <1290025040.2513.69.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 20:56 +0100, Rafał Miłecki wrote: 
> Devices which use LO enabled bit are covered by b43legacy
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Is this alright to use inline for this? Is my WARN_ON OK?
> ---
>  drivers/net/wireless/b43/main.c   |    2 ++
>  drivers/net/wireless/b43/rfkill.c |   21 +++------------------
>  drivers/net/wireless/b43/rfkill.h |    4 ++--
>  3 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index fa48803..9b71bb1 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4527,6 +4527,8 @@ static int b43_op_start(struct ieee80211_hw *hw)
>  		}
>  	}
>  
> +	/* we don't expect older devices which need other RFKILL check */
> +	B43_WARN_ON(dev->dev->id.revision < 3);

Do we really need that check? The driver is full of assumptions that
the core revision is >=5.
I also think this assertion is misplaced in the interface start
handler. If you want it, do it in the rfkill check function. (for
nondebug build it's a no-op)

> 	/* XXX: only do if device doesn't support rfkill irq */
>  	wiphy_rfkill_start_polling(hw->wiphy);
>  
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index 78016ae..012ed2f 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -26,25 +26,10 @@
>  
> 
>  /* Returns TRUE, if the radio is enabled in hardware. */
> -bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
> +inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev)

inline doesn't make sense here.

> {
> -	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
> -		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
> -		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
> -			return 1;
> -	} else {
> -		/* To prevent CPU fault on PPC, do not read a register
> -		 * unless the interface is started; however, on resume
> -		 * for hibernation, this routine is entered early. When
> -		 * that happens, unconditionally return TRUE.
> -		 */
> -		if (b43_status(dev) < B43_STAT_STARTED)
> -			return 1;
> -		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
> -		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
> -			return 1;
> -	}
> -	return 0;
> +	return !(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
> +		& B43_MMIO_RADIO_HWENABLED_HI_MASK);
>  }

Getting rid of that old crap is a good idea. So ACK on this part.

> /* The poll callback for the hardware button. */
> diff --git a/drivers/net/wireless/b43/rfkill.h b/drivers/net/wireless/b43/rfkill.h
> index f046c3c..7aa8a5a 100644
> --- a/drivers/net/wireless/b43/rfkill.h
> +++ b/drivers/net/wireless/b43/rfkill.h
> @@ -4,8 +4,8 @@
>  struct ieee80211_hw;
>  struct b43_wldev;
>  
> -void b43_rfkill_poll(struct ieee80211_hw *hw);
> +inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
>  
> -bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
> +void b43_rfkill_poll(struct ieee80211_hw *hw);
>  
>  #endif /* B43_RFKILL_H_ */

doesn't make sense.

-- 
Greetings Michael.

