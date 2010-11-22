Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43839 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab0KVB2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 20:28:11 -0500
Received: by iwn34 with SMTP id 34so2232097iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 17:28:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289355626-25373-32-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
	<1289355626-25373-32-git-send-email-lacombar@gmail.com>
Date: Sun, 21 Nov 2010 20:28:10 -0500
Message-ID: <AANLkTi=W+EVcy-zbooDCnTnqNV1uVcYbpx=+mZc4EcnM@mail.gmail.com>
Subject: Re: [PATCH 31/44] compat/2.6.22: add compat for couple of TCP accessors
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Nov 9, 2010 at 9:20 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/compat-2.6.22.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
> index e0cdab2..73dbbb6 100644
> --- a/include/linux/compat-2.6.22.h
> +++ b/include/linux/compat-2.6.22.h
> @@ -80,6 +80,26 @@ static inline void skb_copy_from_linear_data_offset(const struct sk_buff *skb,
>        memcpy(to, skb->data + offset, len);
>  }
>
> +static inline struct iphdr *ip_hdr(const struct sk_buff *skb)
> +{
> +       return (struct iphdr *)skb_network_header(skb);
> +}
> +
Actually, this one is already defined a few lines above, but lost in
the middle of skb accessor inlines :/ I'll remove this part.

 - Arnaud
