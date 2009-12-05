Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60643 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZLEIcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 03:32:25 -0500
Received: by ewy19 with SMTP id 19so3718567ewy.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 00:32:30 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix trimming of L2 padded frames.
Date: Sat, 5 Dec 2009 09:32:27 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
References: <1259962577-25135-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259962577-25135-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912050932.27897.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 December 2009, Gertjan van Wingerde wrote:
> Ensure that frames without payload are properly trimmed in
> rt2x00queue_insert_l2pad.
> 
> This should fix the bug reported by Benoit Papillault in:
> http://marc.info/?l=linux-wireless&m=125974773006734&w=2
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 7452fa8..3d8fb68 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -180,7 +180,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>  	unsigned int payload_length = skb->len - header_length;
>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
> -	unsigned int l2pad = L2PAD_SIZE(header_length);
> +	unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
>  
>  	/*
>  	 * Adjust the header alignment if the payload needs to be moved more


