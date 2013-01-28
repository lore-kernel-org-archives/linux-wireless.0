Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35445 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab3A1S6S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 13:58:18 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Cyril Roelandt <tipecaml@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 28 Jan 2013 10:53:33 -0800
Subject: RE: [PATCH] mwifiex: avoid out of bounds access in
 mwifiex_get_common_rates.
Message-ID: <477F20668A386D41ADCC57781B1F70430D142545EE@SC-VEXCH1.marvell.com> (sfid-20130128_195823_078972_FD523BE3)
References: <1359326568-17022-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1359326568-17022-1-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cyril,

Thanks for your patch.

> Check that the array indexes are in-bounds before accessing the rate2 and tmp
> arrays.
> 
> Found with the following semantic patch:
> 
> <smpl>
> @@
> identifier t;
> identifier idx;
> expression E;
> statement S;
> @@
> * for (... ; <+... t[idx] ...+> && idx < E ; ...)
> S
> </smpl>
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/join.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
> index 893d809..f0a634d 100644
> --- a/drivers/net/wireless/mwifiex/join.c
> +++ b/drivers/net/wireless/mwifiex/join.c
> @@ -157,8 +157,8 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
> 
>  	memset(rate1, 0, rate1_size);
> 
> -	for (i = 0; rate2[i] && i < rate2_size; i++) {
> -		for (j = 0; tmp[j] && j < rate1_size; j++) {
> +	for (i = 0; i < rate2_size && rate2[i]; i++) {
> +		for (j = 0; j < rate1_size && tmp[j]; j++) {
>  			/* Check common rate, excluding the bit for
>  			   basic rate */
>  			if ((rate2[i] & 0x7F) == (tmp[j] & 0x7F)) {
> --
> 1.7.10.4

