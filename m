Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36961 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2APUyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 15:54:50 -0500
Subject: Re: [PATCH v2] NFC: Download TI NFC init script
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326296420-3568-1-git-send-email-ilane@ti.com>
References: <1326296420-3568-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 22:00:43 +0100
Message-ID: <1326747643.22824.23.camel@sortiz-mobl> (sfid-20120116_215502_813197_BA8C3149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Wed, 2012-01-11 at 17:40 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Download TI NFC init script during nfcwilink open operation,
> after the NFC channel is registered with TI shared transport.
> TI NFC init script is written in BTS format.
> First, read the chip version via a special vendor specific command.
> Second, we request the relevant BTS file from the user space, and
> then send the BTS commands to the chip.

Some nitpicks again:


> +static int nfcwilink_download_fw(struct nfcwilink *drv)
> +{
> +	unsigned char file_name[BTS_FILE_NAME_MAX_SIZE];
> +	const struct firmware *fw;
> +	__u16 action_type, action_len;
> +	__u8 *ptr;
> +	int len, rc;
> +
> +	nfc_dev_dbg(&drv->pdev->dev, "download_fw entry");
> +
> +	set_bit(NFCWILINK_FW_DOWNLOAD, &drv->flags);
> +
> +	rc = nfcwilink_get_bts_file_name(drv, file_name);
> +	if (rc)
> +		goto exit;
> +
> +	rc = request_firmware(&fw, file_name, &drv->pdev->dev);
> +	if (rc) {
> +		nfc_dev_err(&drv->pdev->dev, "request_firmware failed %d", rc);
> +
> +		/* if the file is not found, don't exit with failure */
> +		if (rc == -ENOENT)
> +			rc = 0;
> +
> +		goto exit;
> +	}
> +
> +	len = fw->size;
> +	ptr = (__u8 *)fw->data;
> +
> +	if ((len == 0) || (ptr == NULL)) {
> +		nfc_dev_dbg(&drv->pdev->dev,
> +				"request_firmware returned size %d", len);
> +		goto release_fw;
> +	}
> +
> +	if (__le32_to_cpu(((struct bts_file_hdr *)ptr)->magic) !=
> +			BTS_FILE_HDR_MAGIC) {
> +		nfc_dev_err(&drv->pdev->dev, "wrong bts magic number");
> +		rc = -EINVAL;
> +		goto release_fw;
> +	}
> +
> +	/* remove the BTS header */
> +	len -= sizeof(struct bts_file_hdr);
> +	ptr += sizeof(struct bts_file_hdr);
> +
> +	while (len > 0) {
> +		action_type =
> +			__le16_to_cpu(((struct bts_file_action *)ptr)->type);
> +		action_len =
> +			__le16_to_cpu(((struct bts_file_action *)ptr)->len);
> +
> +		nfc_dev_dbg(&drv->pdev->dev, "bts_file_action type %d, len %d",
> +				action_type, action_len);
> +
> +		switch (action_type) {
> +		case BTS_FILE_ACTION_TYPE_SEND_CMD:
> +			rc = nfcwilink_send_bts_cmd(drv,
> +					((struct bts_file_action *)ptr)->data,
> +					action_len);
> +			if (rc)
> +				goto release_fw;
> +			break;
> +		}
> +
> +		/* advance to the next action */
> +		len -= (sizeof(struct bts_file_action) + action_len);
> +		ptr += (sizeof(struct bts_file_action) + action_len);
> +	}
I would somehow agree with Ohad here by saying that the BTS handling
could (even though this one seems to be a simplified one) be factorized
somehow. But I'm not going to comment any further on the ST code ;)



> @@ -208,11 +489,13 @@ static int nfcwilink_send(struct sk_buff *skb)
>  
>  	nfc_dev_dbg(&drv->pdev->dev, "send entry, len %d", skb->len);
>  
> -	if (!test_bit(NFCWILINK_RUNNING, &drv->flags))
> -		return -EBUSY;
> +	if (!test_bit(NFCWILINK_RUNNING, &drv->flags)) {
> +		kfree_skb(skb);
> +		return -EINVAL;
> +	}
This is not related to this patch.


>  	/* add the ST hdr to the start of the buffer */
> -	hdr.len = skb->len;
> +	hdr.len = cpu_to_le16(skb->len);
Same here.


>  	memcpy(skb_push(skb, NFCWILINK_HDR_LEN), &hdr, NFCWILINK_HDR_LEN);
>  
>  	/* Insert skb to shared transport layer's transmit queue.
> @@ -239,7 +522,7 @@ static int nfcwilink_probe(struct platform_device *pdev)
>  {
>  	static struct nfcwilink *drv;
>  	int rc;
> -	u32 protocols;
> +	__u32 protocols;
Ditto.

Cheers,
Samuel.

