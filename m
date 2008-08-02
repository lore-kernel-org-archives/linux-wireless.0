Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:53272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYHBSCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:02:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so566020nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 11:02:34 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] rfkill: use strict_strtoul
Date: Sat, 2 Aug 2008 20:25:19 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> <1217699786-20672-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217699786-20672-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808022025.19323.IvDoorn@gmail.com> (sfid-20080802_200238_141016_BD56A2D7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Switch sysfs parsing to something that actually works properly.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 35a9994..2ec6312 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -352,12 +352,16 @@ static ssize_t rfkill_state_store(struct device *dev,
>  				  const char *buf, size_t count)
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
> -	unsigned int state = simple_strtoul(buf, NULL, 0);
> +	unsigned long state;
>  	int error;
>  
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
>  
> +	error = strict_strtoul(buf, 0, &state);
> +	if (error)
> +		return error;
> +
>  	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
>  	if (state != RFKILL_STATE_UNBLOCKED &&
>  	    state != RFKILL_STATE_SOFT_BLOCKED)
> @@ -385,7 +389,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  				  const char *buf, size_t count)
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
> -	bool claim = !!simple_strtoul(buf, NULL, 0);
> +	unsigned long claim;
>  	int error;
>  
>  	if (!capable(CAP_NET_ADMIN))
> @@ -394,6 +398,10 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (rfkill->user_claim_unsupported)
>  		return -EOPNOTSUPP;
>  
> +	error = strict_strtoul(buf, 0, &claim);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Take the global lock to make sure the kernel is not in
>  	 * the middle of rfkill_switch_all
> @@ -402,7 +410,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (error)
>  		return error;
>  
> -	if (rfkill->user_claim != claim) {
> +	if (!!rfkill->user_claim != !!claim) {
>  		if (!claim) {
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill,
> @@ -410,7 +418,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  					    0);
>  			mutex_unlock(&rfkill->mutex);
>  		}
> -		rfkill->user_claim = claim;
> +		rfkill->user_claim = !!claim;
>  	}
>  
>  	mutex_unlock(&rfkill_mutex);


