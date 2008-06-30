Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3352 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764658AbYF3VrN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 17:47:13 -0400
Date: Mon, 30 Jun 2008 17:35:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: drago01 <drago01@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support
Message-ID: <20080630213522.GC878@tuxdriver.com> (sfid-20080630_234729_791527_A007E649)
References: <f6ca9fed0806291020j151c64fbx7705fe568b42adff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0806291020j151c64fbx7705fe568b42adff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 29, 2008 at 07:20:21PM +0200, drago01 wrote:

> diff --git a/drivers/net/wireless/b43/rfkill.c
> b/drivers/net/wireless/b43/rfkill.c
> index 4cca203..4c0dd99 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -43,6 +43,23 @@ static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>  	return 0;
>  }
> 
> +/* Update the rfkill state */
> +static void b43_rfkill_update_state(struct b43_wldev *dev)
> +{
> +	struct b43_rfkill *rfk = &(dev->wl->rfkill);

<snip>


> diff --git a/drivers/net/wireless/b43legacy/rfkill.c
> b/drivers/net/wireless/b43legacy/rfkill.c
> index 8935a30..19dabb7 100644
> --- a/drivers/net/wireless/b43legacy/rfkill.c
> +++ b/drivers/net/wireless/b43legacy/rfkill.c
> @@ -44,6 +44,23 @@ static bool b43legacy_is_hw_radio_enabled(struct
> b43legacy_wldev *dev)
>  	return 0;
>  }
> 
> +/* Update the rfkill state */
> +static void b43legacy_rfkill_update_state(struct b43legacy_wldev *dev)
> +{
> +	struct b43_rfkill *rfk = &(dev->wl->rfkill);

In b43legacy the structure name is 'b43legacy_rfkill'.  Please make
sure you compile patches before submitting them.

John
-- 
John W. Linville
linville@tuxdriver.com
