Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:12948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbbA3AHq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 19:07:46 -0500
Date: Fri, 30 Jan 2015 01:07:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: clement.perrochaud@effinnov.com
Cc: linux-nfc@lists.01.org,
	=?iso-8859-1?Q?Cl=E9ment?= Perrochaud
	<clement.perrochaud@nxp.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver
Message-ID: <20150130000738.GB20998@ribalta.ger.corp.intel.com> (sfid-20150130_010818_351575_38F8AE27)
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
 <1421940460-14049-4-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1421940460-14049-4-git-send-email-clement.perrochaud@effinnov.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clement,

On Thu, Jan 22, 2015 at 04:27:39PM +0100, clement.perrochaud@effinnov.com wrote:
> From: Clément Perrochaud <clement.perrochaud@nxp.com>
> 
> Signed-off-by: Clément Perrochaud <clement.perrochaud@nxp.com>
> Signed-off-by: Clément Perrochaud <clement.perrochaud@effinnov.com>
Are you sure you want both S-O-B lines ?


> +static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
> +			       struct sk_buff **skb)
> +{
> +	struct i2c_client *client = phy->i2c_dev;
> +	u16 header;
> +	size_t frame_len;
> +	int r;
> +
> +	r = i2c_master_recv(client, (u8 *) &header, NXP_NCI_FW_HDR_LEN);
> +	if (r < 0) {
> +		goto fw_read_exit;
> +	} else if (r != NXP_NCI_FW_HDR_LEN) {
> +		nfc_err(&client->dev, "Incorrect header length: %u\n", r);
> +		r = -EBADMSG;
> +		goto fw_read_exit;
> +	}
> +
> +	frame_len = (get_unaligned_be16(&header) & NXP_NCI_FW_FRAME_LEN_MASK) +
> +		    NXP_NCI_FW_CRC_LEN;
> +
> +	*skb = alloc_skb(NXP_NCI_FW_HDR_LEN + frame_len, GFP_KERNEL);
> +	if (*skb == NULL) {
> +		r = -ENOMEM;
> +		goto fw_read_exit;
> +	}
> +
> +	memcpy(skb_put(*skb, NXP_NCI_FW_HDR_LEN), &header, NXP_NCI_FW_HDR_LEN);
> +
> +	r = i2c_master_recv(client, skb_put(*skb, frame_len), frame_len);
> +	if (r != frame_len) {
> +		nfc_err(&client->dev,
> +			"Invalid frame length: %u (expected %u)\n",
> +			r, frame_len);
> +		r = -EBADMSG;
> +		goto fw_read_exit_free_skb;
> +	}
> +
> +	r = 0;
> +	goto fw_read_exit;
return 0; is enough.

> +static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
> +				struct sk_buff **skb)
> +{
> +	struct nci_ctrl_hdr header; /* May actually be a data header */
> +	struct i2c_client *client = phy->i2c_dev;
> +	int r;
> +
> +	r = i2c_master_recv(client, (u8 *) &header, NCI_CTRL_HDR_SIZE);
> +	if (r < 0) {
> +		goto nci_read_exit;
> +	} else if (r != NCI_CTRL_HDR_SIZE) {
> +		nfc_err(&client->dev, "Incorrect header length: %u\n", r);
> +		r = -EBADMSG;
> +		goto nci_read_exit;
> +	}
> +
> +	*skb = alloc_skb(NCI_CTRL_HDR_SIZE + header.plen, GFP_KERNEL);
> +	if (*skb == NULL) {
> +		r = -ENOMEM;
> +		goto nci_read_exit;
> +	}
> +
> +	memcpy(skb_put(*skb, NCI_CTRL_HDR_SIZE), (void *) &header,
> +	       NCI_CTRL_HDR_SIZE);
> +
> +	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
> +	if (r != header.plen) {
> +		nfc_err(&client->dev,
> +			"Invalid frame payload length: %u (expected %u)\n",
> +			r, header.plen);
> +		r = -EBADMSG;
> +		goto nci_read_exit_free_skb;
> +	}
> +
> +	r = 0;
> +	goto nci_read_exit;
Ditto.

> +static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
> +{
> +	struct nxp_nci_i2c_phy *phy = phy_id;
> +	struct i2c_client *client;
> +	struct nxp_nci_info *info;
> +
> +	struct sk_buff *skb = NULL;
> +	int r = 0;
> +
> +	if (!phy || !phy->ndev)
> +		goto exit_irq_none;
> +
> +	client = phy->i2c_dev;
> +
> +	if (!client || irq != client->irq)
> +		goto exit_irq_none;
> +
> +	if (phy->hard_fault != 0)
> +		goto exit_irq_handled;
> +
> +	info = nci_get_drvdata(phy->ndev);

You probably want to take the info_lock mutex here.

> +	switch (info->mode) {
> +	case NXP_NCI_MODE_NCI:
> +		r = nxp_nci_i2c_nci_read(phy, &skb);
> +		break;
> +	case NXP_NCI_MODE_FW:
> +		r = nxp_nci_i2c_fw_read(phy, &skb);
> +		break;
> +	case NXP_NCI_MODE_COLD:
> +		r = -EREMOTEIO;
> +		break;
> +	}
> +
> +	if (r == -EREMOTEIO) {
> +		phy->hard_fault = r;
> +		skb = NULL;
> +	} else if (r < 0) {
> +		nfc_err(&client->dev, "Read failed with error %d\n", r);
> +		goto exit_irq_handled;
> +	}
> +
> +	switch (info->mode) {
> +	case NXP_NCI_MODE_NCI:
> +		nci_recv_frame(phy->ndev, skb);
> +		break;
> +	case NXP_NCI_MODE_FW:
> +		nxp_nci_fw_recv_frame(phy->ndev, skb);
> +		break;
> +	case NXP_NCI_MODE_COLD:
> +		break;
> +	}
> +
> +exit_irq_handled:
> +	return IRQ_HANDLED;
> +exit_irq_none:
> +	WARN_ON_ONCE(1);
> +	return IRQ_NONE;
> +}
> +static int nxp_nci_i2c_request_gpios(struct nxp_nci_i2c_phy *phy)
> +{
> +	int r;
> +
> +	r = gpio_request(phy->gpio_en, "nxp_nci_en");
Please use the devm_gpiod_* API so that you don't need to free GPIOs
explicitely.


> +	if (r < 0)
> +		goto err_out;
> +
> +	r = gpio_direction_output(phy->gpio_en, 0);
> +	if (r < 0)
> +		goto err_gpio_en;
> +
> +	r = gpio_request(phy->gpio_fw, "nxp_nci_fw");
> +	if (r < 0)
> +		goto err_gpio_en;
> +
> +	r = gpio_direction_output(phy->gpio_fw, 0);
> +	if (r < 0)
> +		goto err_gpio_fw;
> +
> +	goto err_out;
> +
> +err_gpio_fw:
> +	gpio_free(phy->gpio_fw);
> +err_gpio_en:
> +	gpio_free(phy->gpio_en);
> +err_out:
> +	return r;
> +}
> +
> +static void nxp_nci_i2c_free_gpios(struct nxp_nci_i2c_phy *phy)
> +{
> +	gpio_free(phy->gpio_fw);
> +	gpio_free(phy->gpio_en);
> +}
You would no longer need that one with devm_gpiod_*.


