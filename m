Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:39732 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbYFWUtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:49:49 -0400
Received: by ug-out-1314.google.com with SMTP id h2so602748ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 13:49:45 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 11/13] rfkill: drop current_state from tasks in rfkill-input
Date: Mon, 23 Jun 2008 22:49:42 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> <1214252588-30723-12-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1214252588-30723-12-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806232249.42769.IvDoorn@gmail.com> (sfid-20080623_225009_670300_7E510DE4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 June 2008, Henrique de Moraes Holschuh wrote:
> From: Fabien Crespel <fabien@crespel.net>
> 
> The whole current_state thing seems completely useless and a source of
> problems in rfkill-input, since state comparison is already done in rfkill,
> and rfkill-input is more than likely to become out of sync with the real
> state.
> 
> Signed-off-by: Fabien Crespel <fabien@crespel.net>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill-input.c |   15 +--------------
>  1 files changed, 1 insertions(+), 14 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 29c13d3..d285f9a 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -30,27 +30,15 @@ struct rfkill_task {
>  	spinlock_t lock; /* for accessing last and desired state */
>  	unsigned long last; /* last schedule */
>  	enum rfkill_state desired_state; /* on/off */
> -	enum rfkill_state current_state; /* on/off */
>  };
>  
>  static void rfkill_task_handler(struct work_struct *work)
>  {
>  	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
> -	enum rfkill_state state;
>  
>  	mutex_lock(&task->mutex);
>  
> -	/*
> -	 * Use temp variable to fetch desired state to keep it
> -	 * consistent even if rfkill_schedule_toggle() runs in
> -	 * another thread or interrupts us.
> -	 */
> -	state = task->desired_state;
> -
> -	if (state != task->current_state) {
> -		rfkill_switch_all(task->type, state);
> -		task->current_state = state;
> -	}
> +	rfkill_switch_all(task->type, task->desired_state);
>  
>  	mutex_unlock(&task->mutex);
>  }
> @@ -94,7 +82,6 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
>  		.mutex = __MUTEX_INITIALIZER(n.mutex),	\
>  		.lock = __SPIN_LOCK_UNLOCKED(n.lock),	\
>  		.desired_state = RFKILL_STATE_ON,	\
> -		.current_state = RFKILL_STATE_ON,	\
>  	}
>  
>  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);


