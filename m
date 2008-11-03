Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:51923 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYKCRU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 12:20:27 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1033418nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 09:20:13 -0800 (PST)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] rfkill: preserve state across suspend
Date: Mon, 3 Nov 2008 18:20:09 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <1225730537-2679-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1225730537-2679-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811031820.10179.IvDoorn@gmail.com> (sfid-20081103_182034_148125_28444306)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> The rfkill class API requires that the driver connected to a class
> call rfkill_force_state() on resume to update the real state of the
> rfkill controller, OR that it provides a get_state() hook.
> 
> This means there is potentially a hidden call in the resume code flow
> that changes rfkill->state (i.e. rfkill_force_state()), so the
> previous state of the transmitter was being lost.
> 
> The simplest and most future-proof way to fix this is to explicitly
> store the pre-sleep state on the rfkill structure, and restore from
> that on resume.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  include/linux/rfkill.h |    1 +
>  net/rfkill/rfkill.c    |    7 ++++++-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 4cd64b0..f376a93 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -108,6 +108,7 @@ struct rfkill {
>  
>  	struct device dev;
>  	struct list_head node;
> +	enum rfkill_state state_for_resume;
>  };
>  #define to_rfkill(d)	container_of(d, struct rfkill, dev)
>  
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index f949a48..caee717 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -511,10 +511,15 @@ static void rfkill_release(struct device *dev)
>  #ifdef CONFIG_PM
>  static int rfkill_suspend(struct device *dev, pm_message_t state)
>  {
> +	struct rfkill *rfkill = to_rfkill(dev);
> +
>  	/* mark class device as suspended */
>  	if (dev->power.power_state.event != state.event)
>  		dev->power.power_state = state;
>  
> +	/* store state for the resume handler */
> +	rfkill->state_for_resume = rfkill->state;
> +
>  	return 0;
>  }
>  
> @@ -528,7 +533,7 @@ static int rfkill_resume(struct device *dev)
>  		dev->power.power_state.event = PM_EVENT_ON;
>  
>  		/* restore radio state AND notify everybody */
> -		rfkill_toggle_radio(rfkill, rfkill->state, 1);
> +		rfkill_toggle_radio(rfkill, rfkill->state_for_resume, 1);
>  
>  		mutex_unlock(&rfkill->mutex);
>  	}


