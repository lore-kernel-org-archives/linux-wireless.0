Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYGVQyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 12:54:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so708172nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 09:54:53 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 6/6] rfkill: yet more minor kernel-doc fixes
Date: Tue, 22 Jul 2008 19:11:32 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-7-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216685902-9373-7-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807221911.32602.IvDoorn@gmail.com> (sfid-20080722_185456_488277_039477C8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 July 2008, Henrique de Moraes Holschuh wrote:
> For some stupid reason, I sent and old version of the patch minor kernel
> doc-fix patch, and it got merged before I noticed the problem. This is an
> incremental fix on top.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ac205ec..c6f2f38 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -130,7 +130,6 @@ static void update_rfkill_state(struct rfkill *rfkill)
>  
>  /**
>   * rfkill_toggle_radio - wrapper for toggle_radio hook
> - *
>   * @rfkill: the rfkill struct to use
>   * @force: calls toggle_radio even if cache says it is not needed,
>   *	and also makes sure notifications of the state will be
> @@ -141,8 +140,8 @@ static void update_rfkill_state(struct rfkill *rfkill)
>   * calls and handling all the red tape such as issuing notifications
>   * if the call is successful.
>   *
> - * Note that @force cannot override a (possibly cached) state of
> - * RFKILL_STATE_HARD_BLOCKED.  Any device making use of
> + * Note that the @force parameter cannot override a (possibly cached)
> + * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
>   * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
>   * rfkill_force_state(), so the cache either is bypassed or valid.
>   *
> @@ -200,12 +199,12 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  
>  /**
>   * rfkill_switch_all - Toggle state of all switches of given type
> - * @type: type of interfaces to be affeceted
> + * @type: type of interfaces to be affected
>   * @state: the new state
>   *
> - * This function toggles state of all switches of given type unless
> - * a specific switch is claimed by userspace in which case it is
> - * left alone.
> + * This function toggles the state of all switches of given type,
> + * unless a specific switch is claimed by userspace (in which case,
> + * that switch is left alone).
>   */
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  {
> @@ -540,9 +539,10 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
>   * @type: type of the switch (RFKILL_TYPE_*)
>   *
>   * This function should be called by the network driver when it needs
> - * rfkill structure. Once the structure is allocated the driver shoud
> - * finish its initialization by setting name, private data, enable_radio
> + * rfkill structure.  Once the structure is allocated the driver should
> + * finish its initialization by setting the name, private data, enable_radio
>   * and disable_radio methods and then register it with rfkill_register().
> + *
>   * NOTE: If registration fails the structure shoudl be freed by calling
>   * rfkill_free() otherwise rfkill_unregister() should be used.
>   */
> @@ -574,7 +574,7 @@ EXPORT_SYMBOL(rfkill_allocate);
>   * rfkill_free - Mark rfkill structure for deletion
>   * @rfkill: rfkill structure to be destroyed
>   *
> - * Decrements reference count of rfkill structure so it is destroyed.
> + * Decrements reference count of the rfkill structure so it is destroyed.
>   * Note that rfkill_free() should _not_ be called after rfkill_unregister().
>   */
>  void rfkill_free(struct rfkill *rfkill)


