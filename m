Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:42728 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYHCHmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:42:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so587970nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:42:14 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/8] rfkill: add __must_check annotations
Date: Sun, 3 Aug 2008 10:05:37 +0200
Cc: linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217700664-20792-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031005.37299.IvDoorn@gmail.com> (sfid-20080803_094219_561615_30E01F03)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> rfkill is not a small, mere detail in wireless support.  Once it starts
> supporting rfkill and users start counting on that support, a wireless
> device is at risk of operating in dangerous conditions should rfkill
> support fail to properly activate.
> 
> Therefore, add the required __must_check annotations on some key functions
> of the rfkill API, for which the wireless drivers absolutely MUST handle
> the failure mode safely in order to avoid a potentially dangerous situation
> where the wireless transmitter is left enabled when the user don't want it
> to.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Matthew Garrett <mjg@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  include/linux/rfkill.h |    5 +++--
>  net/rfkill/rfkill.c    |    5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index aa3c7d5..e92d8e9 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -110,9 +110,10 @@ struct rfkill {
>  };
>  #define to_rfkill(d)	container_of(d, struct rfkill, dev)
>  
> -struct rfkill *rfkill_allocate(struct device *parent, enum rfkill_type type);
> +struct rfkill * __must_check rfkill_allocate(struct device *parent,
> +					     enum rfkill_type type);
>  void rfkill_free(struct rfkill *rfkill);
> -int rfkill_register(struct rfkill *rfkill);
> +int __must_check rfkill_register(struct rfkill *rfkill);
>  void rfkill_unregister(struct rfkill *rfkill);
>  
>  int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index c1901fb..5320210 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -653,7 +653,8 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
>   * NOTE: If registration fails the structure shoudl be freed by calling
>   * rfkill_free() otherwise rfkill_unregister() should be used.
>   */
> -struct rfkill *rfkill_allocate(struct device *parent, enum rfkill_type type)
> +struct rfkill * __must_check rfkill_allocate(struct device *parent,
> +					     enum rfkill_type type)
>  {
>  	struct rfkill *rfkill;
>  	struct device *dev;
> @@ -724,7 +725,7 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
>   * structure needs to be registered. Immediately from registration the
>   * switch driver should be able to service calls to toggle_radio.
>   */
> -int rfkill_register(struct rfkill *rfkill)
> +int __must_check rfkill_register(struct rfkill *rfkill)
>  {
>  	static atomic_t rfkill_no = ATOMIC_INIT(0);
>  	struct device *dev = &rfkill->dev;


