Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:38762 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0JFPfj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:35:39 -0400
Subject: Re: [PATCH 3/3] b43: N-PHY: don't duplicate setting channel in
 shared memory
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1286344208-32479-4-git-send-email-zajec5@gmail.com> (sfid-20101006_015010_704414_EB285C04)
References: <1286344208-32479-1-git-send-email-zajec5@gmail.com>
	 <1286344208-32479-4-git-send-email-zajec5@gmail.com>
	 (sfid-20101006_015010_704414_EB285C04)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 17:30:40 +0200
Message-ID: <1286379040.11721.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 07:50 +0200, Rafał Miłecki wrote: 
> It's already set in PHY common code.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_n.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 47c58cd..bb8cb36 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -73,8 +73,6 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
>  						u16 value, u8 core, bool off);
>  static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
>  						u16 value, u8 core);
> -static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
> -				      unsigned int new_channel);
>  
>  static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
>  {
> @@ -224,7 +222,7 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
>  	if (i)
>  		b43err(dev->wl, "radio post init timeout\n");
>  	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
> -	b43_nphy_op_switch_channel(dev, dev->phy.channel);
> +	b43_switch_channel(dev, dev->phy.channel);
>  	b43_radio_write(dev, B2055_C1_RX_BB_LPF, 0x9);
>  	b43_radio_write(dev, B2055_C2_RX_BB_LPF, 0x9);
>  	b43_radio_write(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
> @@ -3352,12 +3350,7 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
>  
>  	b43_chantab_phy_upload(dev, e);
>  
> -	tmp = chanspec.channel;
> -	if (chanspec.b_freq == 1)
> -		tmp |= 0x0100;
> -	if (chanspec.b_width == 3)
> -		tmp |= 0x0200;
> -	b43_shm_write16(dev, B43_SHM_SHARED, 0xA0, tmp);
> +	/* Don't follow specs, B43_SHM_SH_CHAN is set by b43_switch_channel */

Looks great. I dunno if a comment is really needed and whether it is
correct, though. We _do_ follow the specs. We just do it elsewhere.


> 	if (nphy->radio_chanspec.channel == 14) {
>  		b43_nphy_classifier(dev, 2, 0);
> @@ -3559,7 +3552,7 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
>  	} else {
>  		if (dev->phy.rev >= 3) {
>  			b43_radio_init2056(dev);
> -			b43_nphy_op_switch_channel(dev, dev->phy.channel);
> +			b43_switch_channel(dev, dev->phy.channel);
>  		} else {
>  			b43_radio_init2055(dev);
>  		}


-- 
Greetings Michael.

