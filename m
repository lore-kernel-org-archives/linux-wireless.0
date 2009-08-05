Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46934 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbZHECEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 22:04:48 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH 1/2] ar9170: cleanup of bss_info_changed and beacon config
Date: Wed, 5 Aug 2009 04:04:45 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4A78CE98.70903@gmx.de>
In-Reply-To: <4A78CE98.70903@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908050404.47371.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 August 2009 02:13:12 Joerg Albert wrote:
> Enable/Disable the beacon in ar910_set_beacon_timers() independently
> of ar->vif, but controlled by BSS_CHANGED_BEACON_ENABLED and
> bss_conf->enable_beacon from mac80211.

no signed/cc here?

> ---
>  drivers/net/wireless/ath/ar9170/ar9170.h |    1 +
>  drivers/net/wireless/ath/ar9170/mac.c    |    4 +++-
>  drivers/net/wireless/ath/ar9170/main.c   |   15 ++++++++-------
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
> index d9f1f46..9f2801c 100644
> --- a/drivers/net/wireless/ath/ar9170/mac.c
> +++ b/drivers/net/wireless/ath/ar9170/mac.c
> @@ -388,7 +388,9 @@ int ar9170_set_beacon_timers(struct ar9170 *ar)
>  	u32 v = 0;
>  	u32 pretbtt = 0;
>  
> -	if (ar->vif) {
> +	if (ar->enable_beacon) {
> +		if (WARN_ON(!ar->vif))
> +			return -ENODEV;
>  		v |= ar->vif->bss_conf.beacon_int;
>  
>  		switch (ar->vif->type) {

err, guess that's why. (not fatal, but WARN)
 
the beacon timer isn't exclusively used to notify the driver when its 
time for a new beacon... The STA mode uses the same _timer_
in reverse to wait for the next beacon form the assoc. AP.

that said: It does not look like the firmware implements anything
in this direction... But this is a clearly MAC register and there
could be something in the silicon which does something useful with
this information.

so, to be on the safe side: why not preserve the old behavior for the
STA mode as well and simply tell the hardware about dtim & beacon interval?

The only remaining question is where to disabled the timer for STA.
(which is in some way relevant to: [PATCH 2/2] because previously,
 these timers were always disabled by remove_interface.)

I think the best place is in ar9170_op_bss_info_changed:
       if (changed & BSS_CHANGED_ASSOC) {

just when bss_conf->assoc gets "0".

Regards,
	Chr
