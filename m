Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYGVQyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 12:54:50 -0400
Received: by nf-out-0910.google.com with SMTP id d3so708172nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 09:54:48 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/6] rfkill: document the rfkill struct locking (v2)
Date: Tue, 22 Jul 2008 19:11:28 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216685902-9373-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807221911.28873.IvDoorn@gmail.com> (sfid-20080722_185452_945450_27DFDB2B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 July 2008, Henrique de Moraes Holschuh wrote:
> Reorder fields in struct rfkill and add comments to make it clear
> which fields are protected by rfkill->mutex.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  include/linux/rfkill.h |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index c5f6e54..741d1a6 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -68,7 +68,8 @@ enum rfkill_state {
>   * @user_claim_unsupported: Whether the hardware supports exclusive
>   *	RF-kill control by userspace. Set this before registering.
>   * @user_claim: Set when the switch is controlled exlusively by userspace.
> - * @mutex: Guards switch state transitions
> + * @mutex: Guards switch state transitions.  It serializes callbacks
> + *	and also protects the state.
>   * @data: Pointer to the RF button drivers private data which will be
>   *	passed along when toggling radio state.
>   * @toggle_radio(): Mandatory handler to control state of the radio.
> @@ -89,12 +90,13 @@ struct rfkill {
>  	const char *name;
>  	enum rfkill_type type;
>  
> -	enum rfkill_state state;
>  	bool user_claim_unsupported;
>  	bool user_claim;
>  
> +	/* the mutex serializes callbacks and also protects
> +	 * the state */
>  	struct mutex mutex;
> -
> +	enum rfkill_state state;
>  	void *data;
>  	int (*toggle_radio)(void *data, enum rfkill_state state);
>  	int (*get_state)(void *data, enum rfkill_state *state);


