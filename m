Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:62350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKCRUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 12:20:24 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1785907ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 09:20:21 -0800 (PST)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] rfkill: always call get_state() hook on resume
Date: Mon, 3 Nov 2008 18:20:18 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <1225730537-2679-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1225730537-2679-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811031820.18533.IvDoorn@gmail.com> (sfid-20081103_182030_063738_F435C331)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> We "optimize" away the get_state() hook call on rfkill_toggle_radio
> when doing a forced state change.  This means the resume path is not
> calling get_state() as it should.
> 
> Call it manually on the resume handler, as we don't want to mess with
> the EPO path by removing the optimization.  This has the added benefit
> of making it explicit that rfkill->state could have been modified
> before we hit the rfkill_toggle_radio() call in the class resume
> handler.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index caee717..7a82a35 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -526,6 +526,7 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
>  static int rfkill_resume(struct device *dev)
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
> +	enum rfkill_state newstate;
>  
>  	if (dev->power.power_state.event != PM_EVENT_ON) {
>  		mutex_lock(&rfkill->mutex);
> @@ -533,6 +534,9 @@ static int rfkill_resume(struct device *dev)
>  		dev->power.power_state.event = PM_EVENT_ON;
>  
>  		/* restore radio state AND notify everybody */
> +		if (rfkill->get_state &&
> +		    !rfkill->get_state(rfkill->data, &newstate))
> +			rfkill->state = newstate;
>  		rfkill_toggle_radio(rfkill, rfkill->state_for_resume, 1);
>  
>  		mutex_unlock(&rfkill->mutex);


