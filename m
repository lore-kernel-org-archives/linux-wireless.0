Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:46596 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGCQTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:19:46 -0400
Received: by yw-out-2324.google.com with SMTP id 9so372161ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2008 09:19:45 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] rfkill: some minor kernel-doc changes for rfkill_toggle_radio
Date: Thu, 3 Jul 2008 18:24:51 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1215101697-30576-1-git-send-email-hmh@hmh.eng.br> <1215101697-30576-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1215101697-30576-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807031824.51204.IvDoorn@gmail.com> (sfid-20080703_181949_689476_8C9CEA6D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 July 2008, Henrique de Moraes Holschuh wrote:
> Improve rfkill_toggle_radio's kernel-doc header a bit.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ce0e231..aa7039d 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -130,17 +130,19 @@ static void update_rfkill_state(struct rfkill *rfkill)
>  
>  /**
>   * rfkill_toggle_radio - wrapper for toggle_radio hook
> - * calls toggle_radio taking into account a lot of "small"
> - * details.
> + *
>   * @rfkill: the rfkill struct to use
>   * @force: calls toggle_radio even if cache says it is not needed,
>   *	and also makes sure notifications of the state will be
>   *	sent even if it didn't change
>   * @state: the new state to call toggle_radio() with
>   *
> - * This wrappen protects and enforces the API for toggle_radio
> - * calls.  Note that @force cannot override a (possibly cached)
> - * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
> + * Calls rfkill->toggle_radio, enforcing the API for toggle_radio
> + * calls and handling all the red tape such as issuing notifications
> + * if the call is successful.
> + *
> + * Note that @force cannot override a (possibly cached) state of
> + * RFKILL_STATE_HARD_BLOCKED.  Any device making use of
>   * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
>   * rfkill_force_state(), so the cache either is bypassed or valid.
>   *


