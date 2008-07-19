Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:8083 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYGSMYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 08:24:22 -0400
Received: by nf-out-0910.google.com with SMTP id d3so241557nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 05:24:21 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/4] rfkill: document the rfkill struct locking
Date: Sat, 19 Jul 2008 14:39:02 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216150327-10904-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807191439.02853.IvDoorn@gmail.com> (sfid-20080719_142425_652227_BBCAB316)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> Reorder fields in struct rfkill and add comments to make it clear
> which fields are protected by rfkill->mutex.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  include/linux/rfkill.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index c5f6e54..630b573 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -89,13 +89,14 @@ struct rfkill {
>  	const char *name;
>  	enum rfkill_type type;
>  
> -	enum rfkill_state state;
> +	void *data;
>  	bool user_claim_unsupported;
>  	bool user_claim;
>  
> +	/* the mutex serializes callbacks and also protects
> +	 * the state */

Please move/copy the comment into the kerneldoc above the
structure declaration as well.

>  	struct mutex mutex;
> -
> -	void *data;

Not a real problem, but the data pointer doesn't need to be moved,
since it is only used for the callback functions. So technically it is
under the protection of the mutex as well.

> +	enum rfkill_state state;
>  	int (*toggle_radio)(void *data, enum rfkill_state state);
>  	int (*get_state)(void *data, enum rfkill_state *state);

Ivo
