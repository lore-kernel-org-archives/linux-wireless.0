Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33261 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932741AbcI3M4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:56:51 -0400
Received: by mail-lf0-f43.google.com with SMTP id t81so37852637lfe.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2016 05:56:50 -0700 (PDT)
Subject: Re: [PATCH 1/3] cw1200: Don't leak memory if krealloc failes
To: Johannes Thumshirn <jthumshirn@suse.de>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1475237495-15030-1-git-send-email-jthumshirn@suse.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <25a38254-f0e3-1f4e-de46-688d9fd1b736@cogentembedded.com> (sfid-20160930_145711_645124_2F15C033)
Date: Fri, 30 Sep 2016 15:56:45 +0300
MIME-Version: 1.0
In-Reply-To: <1475237495-15030-1-git-send-email-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 9/30/2016 3:11 PM, Johannes Thumshirn wrote:

> The call to krealloc() in wsm_buf_reserve() directly assigns the newly
> returned memory to buf->begin. This is all fine except when krealloc()
> failes we loose the ability to free the old memory pointed to by

    Fails.

> buf->begin. If we just create a temporary variable to assign memory to
> and assign the memory to it we can mitigate the memory leak.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/net/wireless/st/cw1200/wsm.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/wsm.c b/drivers/net/wireless/st/cw1200/wsm.c
> index 680d60e..12fad99 100644
> --- a/drivers/net/wireless/st/cw1200/wsm.c
> +++ b/drivers/net/wireless/st/cw1200/wsm.c
> @@ -1807,16 +1807,18 @@ static int wsm_buf_reserve(struct wsm_buf *buf, size_t extra_size)
>  {
>  	size_t pos = buf->data - buf->begin;
>  	size_t size = pos + extra_size;
> +	u8 *tmp;
>
>  	size = round_up(size, FWLOAD_BLOCK_SIZE);
>
> -	buf->begin = krealloc(buf->begin, size, GFP_KERNEL | GFP_DMA);
> -	if (buf->begin) {
> -		buf->data = &buf->begin[pos];
> -		buf->end = &buf->begin[size];
> -		return 0;
> -	} else {
> -		buf->end = buf->data = buf->begin;
> +	tmp = krealloc(buf->begin, size, GFP_KERNEL | GFP_DMA);
> +	if (tmp) {

    !tmp, you mean?

> +		wsm_buf_deinit(buf);
>  		return -ENOMEM;
>  	}
> +
> +	buf->begin = tmp;
> +	buf->data = &buf->begin[pos];
> +	buf->end = &buf->begin[size];
> +	return 0;
>  }

MBR, Sergei
