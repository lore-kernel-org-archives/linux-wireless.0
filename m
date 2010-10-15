Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53525 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0JPA2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 20:28:11 -0400
Received: by bwz15 with SMTP id 15so1306393bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 17:28:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/7] drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure
Date: Fri, 15 Oct 2010 17:49:07 +0200
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1287147610-8041-3-git-send-email-julia@diku.dk>
In-Reply-To: <1287147610-8041-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201010151749.07851.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 October 2010 15:00:06 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In this code, 0 is returned on memory allocation failure, even though other
> failures return -ENOMEM or other similar values.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression ret;
> expression x,e1,e2,e3;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = \(kmalloc\|kcalloc\|kzalloc\)(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

> ---
>  drivers/net/wireless/p54/eeprom.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -u -p a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
> --- a/drivers/net/wireless/p54/eeprom.c
> +++ b/drivers/net/wireless/p54/eeprom.c
> @@ -261,8 +261,10 @@ static int p54_generate_channel_lists(st
>  	list->max_entries = max_channel_num;
>  	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
>  				 max_channel_num, GFP_KERNEL);
> -	if (!list->channels)
> +	if (!list->channels) {
> +		ret = -ENOMEM;
>  		goto free;
> +	}
>  
>  	for (i = 0; i < max_channel_num; i++) {
>  		if (i < priv->iq_autocal_len) {
> 
> 
