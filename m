Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:48829 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932347Ab3BIBQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 20:16:00 -0500
Message-ID: <1360372559.13487.14.camel@joe-AO722> (sfid-20130209_021606_157221_9EB1D50F)
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
From: Joe Perches <joe@perches.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 17:15:59 -0800
In-Reply-To: <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 15:31 -0500, Solomon Peachy wrote:
> Signed-off-by: Solomon Peachy <pizza@shaftnet.org>

Could you please run your patches through
scripts/checkpatch.pl --strict

> diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c

> +static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
> +				const void *buf, size_t buf_len, int buf_id)
> +{
> +	u16 addr_sdio;
> +	u32 sdio_reg_addr_17bit ;

Odd layout with space before semi

[]

> +int cw1200_data_read(struct cw1200_common *priv, void *buf, size_t buf_len)
> +{
> +	int ret, retry = 1;
> +	priv->sbus_ops->lock(priv->sbus_priv);
> +	{

> +		int buf_id_rx = priv->buf_id_rx;

declare buf_id_rx at the top of the function please
and avoid the extra indentation level.

> +		while (retry <= MAX_RETRY) {
> +			ret = __cw1200_reg_read(priv,
> +					ST90TDS_IN_OUT_QUEUE_REG_ID, buf,
> +					buf_len, buf_id_rx + 1);
> +			if (!ret) {
> +				buf_id_rx = (buf_id_rx + 1) & 3;
> +				priv->buf_id_rx = buf_id_rx;
> +				break;
> +			} else {
> +				retry++;
> +				mdelay(1);
> +				pr_err("%s,error :[%d]\n",
> +						__func__, ret);

This would fit on a single line if indented correctly.

If you are always going to use "%s", __func__
you should probably instead add

#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__

before any include and remove all the "%s"/__func__
uses from the logging messages.

[]

> +int cw1200_apb_write(struct cw1200_common *priv, u32 addr, const void *buf,
> +			size_t buf_len)
> +{
> +	int ret;
> +
> +	if ((buf_len / 2) >= 0x1000) {
> +		pr_err("%s: Can't wrire more than 0xfff words.\n",
> +		       __func__);

write

Consider using netdev_err instead of pr_err

etc.


