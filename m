Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36910 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZK2N10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 08:27:26 -0500
Received: by bwz27 with SMTP id 27so1950788bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 05:27:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259495278-2264-1-git-send-email-gwingerde@gmail.com>
References: <1259495278-2264-1-git-send-email-gwingerde@gmail.com>
Date: Sun, 29 Nov 2009 14:27:31 +0100
Message-ID: <a32f33a40911290527g3606b740u2713bc64e59d169e@mail.gmail.com>
Subject: Re: [PATCH v2] rt2x00: Further L2 padding fixes.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Alban Browaeys <prahal@yahoo.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 29, 2009 at 12:47 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Fix a couple of more bugs in the L2 padding code:
> 1. Compute the amount of L2 padding correctly (in 3 places).
> 2. Trim the skb correctly when the L2 padding has been applied.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>
> v2:
> - Fix bug detect by Benoit Papillault.
>
> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index b8f0954..9082fad 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>        unsigned int frame_length = skb->len;
>        unsigned int header_align = ALIGN_SIZE(skb, 0);
>        unsigned int payload_align = ALIGN_SIZE(skb, header_length);
> -       unsigned int l2pad = 4 - (payload_align - header_align);
> +       unsigned int l2pad = (4 - (header_length & 3)) & 3;

We already have this calculation on multiple locations, so perhaps it
is better to have
a L2PAD_SIZE macro in rt2x00.h (where ALIGN_SIZE() is also defined).

Ivo
