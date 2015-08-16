Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8441 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbbHPVHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 17:07:31 -0400
Date: Sun, 16 Aug 2015 23:07:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
	m.szyprowski@samsung.com, pebolle@tiscali.nl
Subject: Re: [PATCH v2] nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip
Message-ID: <20150816210725.GB17402@zurbaran.home> (sfid-20150816_230811_875885_260E436C)
References: <1438266376-11229-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438266376-11229-1-git-send-email-r.baldyga@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Thu, Jul 30, 2015 at 04:26:16PM +0200, Robert Baldyga wrote:
> +static int s3fwrn5_firmware_update(struct s3fwrn5_info *info)
> +{
> +	u32 version;
> +	bool need_update;
> +	int ret;
> +
> +	ENTER();
We have many tracing tools and frameworks in the kernel, I don't think
this is needed.


> +static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
> +	int ret;
> +
> +	ENTER();
> +
> +	mutex_lock(&info->mutex);
> +
> +	if (s3fwrn5_get_mode(info) != S3FWRN5_MODE_NCI)
Why can't we use this routine in firmware mode ?


> +		return -EINVAL;
You must unlock before returning.

> +int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
> +	enum s3fwrn5_mode mode)
> +{
> +	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
> +
> +	switch (mode) {
> +	case S3FWRN5_MODE_NCI:
> +		return info->custom_nci ?
> +			s3fwrn5_nci_recv_frame(ndev, skb) :
> +			nci_recv_frame(ndev, skb);
In NCI mode, you should not have any of this logic implemented here, but
rely on the NCI core one instead.

> +int s3fwrn5_fw_get_base_addr(struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo,
> +	u32 *base_addr)
This should be a static routine.


> +{
> +	int i;
> +	struct {
> +		u8 version[4];
> +		u32 base_addr;
> +	} match[] = {
> +		{{0x05, 0x00, 0x00, 0x00}, 0x00005000},
> +		{{0x05, 0x00, 0x00, 0x01}, 0x00003000},
> +		{{0x05, 0x00, 0x00, 0x02}, 0x00003000},
> +		{{0x05, 0x00, 0x00, 0x03}, 0x00003000},
> +		{{0x05, 0x00, 0x00, 0x05}, 0x00003000}
> +	};
> +
> +	for (i = 0; i < ARRAY_SIZE(match); ++i)
> +		if (bootinfo->hw_version[0] == match[i].version[0] &&
> +			bootinfo->hw_version[1] == match[i].version[1] &&
> +			bootinfo->hw_version[3] == match[i].version[3]) {
> +			*base_addr = match[i].base_addr;
> +			return 0;
> +		}
> +
> +	return -EINVAL;
> +}
> +
> +bool s3fwrn5_fw_is_custom(struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
> +{
> +	return !!bootinfo->hw_version[2];
> +}
This should be a static inline routine.


> +static int s3fwrn5_i2c_nci_read(struct s3fwrn5_i2c_phy *phy)
> +{
> +	struct nci_ctrl_hdr hdr;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	ENTER();
> +
> +	ret = i2c_master_recv(phy->i2c_dev, (char *)&hdr, NCI_CTRL_HDR_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret < NCI_CTRL_HDR_SIZE)
> +		return -EBADMSG;
> +
> +	skb = alloc_skb(NCI_CTRL_HDR_SIZE + hdr.plen, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	memcpy(skb_put(skb, NCI_CTRL_HDR_SIZE), &hdr, NCI_CTRL_HDR_SIZE);
> +
> +	if (hdr.plen == 0)
> +		goto out;
> +
> +	ret = i2c_master_recv(phy->i2c_dev, skb_put(skb, hdr.plen), hdr.plen);
> +	if (ret != hdr.plen) {
> +		kfree_skb(skb);
> +		return -EBADMSG;
> +	}
> +
> +out:
> +	DUMP_SKB("R:", skb);
> +
> +	return s3fwrn5_recv_frame(phy->ndev, skb, S3FWRN5_MODE_NCI);
> +}
Please factorize s3fwrn5_i2c_nci_read and s3fwrn5_i2c_fw_read. They
share the same logic, only the header sizes differ.


> +static int s3fwrn5_nci_core_reset(struct s3fwrn5_nci_info *nci_info,
> +	struct nci_core_reset_cmd *cmd)
> +{
> +	struct nci_core_reset_rsp *nci_rsp;
> +	struct sk_buff *msg, *rsp = NULL;
> +	int ret;
> +
> +	ret = s3fwrn5_nci_prep_cmd(&msg, NCI_OP_CORE_RESET_CMD,
> +		sizeof(*cmd), cmd);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = s3fwrn5_nci_send_msg(nci_info, msg, &rsp);
> +	kfree_skb(msg);
> +	if (ret < 0)
> +		goto out;
> +
> +	nci_rsp = (void *) rsp->data + NCI_CTRL_HDR_SIZE;
> +	if (nci_rsp->status != NCI_STATUS_OK)
> +		return -EIO;
> +
> +out:
> +	kfree_skb(rsp);
> +	return ret;
> +}
Please export an nci_core_reset() command from nci/core.c for that, that
would be a __nci_request(ndev, nci_reset_req) wrapper.
Your prep_cmd and send_msg routines are a duplication of the nci/core.c
code, we should avoid that.


> +static int s3fwrn5_nci_core_init_get_version(struct s3fwrn5_nci_info *nci_info,
> +	__u32 *version)
> +{
> +	struct nci_core_init_rsp_1 *nci_rsp;
> +	struct sk_buff *msg, *rsp = NULL;
> +	struct nci_ctrl_hdr *hdr;
> +	int ret;
> +
> +	ret = s3fwrn5_nci_prep_cmd(&msg, NCI_OP_CORE_INIT_CMD, 0, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = s3fwrn5_nci_send_msg(nci_info, msg, &rsp);
> +	kfree_skb(msg);
> +	if (ret < 0)
> +		goto out;
> +
> +	hdr = (void *) rsp->data;
> +	if (hdr->plen != 20) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	nci_rsp = (void *) rsp->data + NCI_CTRL_HDR_SIZE;
> +	if (nci_rsp->status != NCI_STATUS_OK) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	memcpy(version, rsp->data + NCI_CTRL_HDR_SIZE + 16, 4);
This should all be contained in ndev->manufact_id and
ndev->manufact_specific_info after nci_open_device() is done with the
init path.
If you need a hook (post_setup) for this, please add it and call it from
nci_open_device().


> +static int s3fwrn5_nci_fw_cfg(struct s3fwrn5_nci_info *nci_info,
> +	struct nci_prop_fw_cfg_cmd *cmd)
> +{
> +	struct nci_prop_fw_cfg_rsp *nci_rsp;
> +	struct sk_buff *msg, *rsp = NULL;
> +	int ret;
> +
> +	ret = s3fwrn5_nci_prep_cmd(&msg, NCI_OP_PROP_FW_CFG_CMD,
> +		sizeof(*cmd), cmd);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = s3fwrn5_nci_send_msg(nci_info, msg, &rsp);
> +	kfree_skb(msg);
> +	if (ret < 0)
> +		goto out;
> +
> +	nci_rsp = (void *) rsp->data + NCI_CTRL_HDR_SIZE;
> +	if (nci_rsp->status != NCI_STATUS_OK)
> +		ret = -EIO;
> +
> +out:
> +	kfree_skb(rsp);
> +	return ret;
> +}
Please use nci_prop_cmd for sending proprietary and register your
proprietary responses through nci_prop_ops.
See b6355e972aaab0173ce11a1650e7dba67f820918 for more details.

> +int s3fwrn5_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
> +	struct s3fwrn5_nci_info *nci_info = &info->nci_info;
> +
> +	ENTER();
> +
> +	BUG_ON(nci_info->rsp);
> +
> +	nci_info->rsp = skb;
> +
> +	complete(&nci_info->completion);
> +
> +	return 0;
> +}
This one should be entirely handled by the NCI core code.

Cheers,
Samuel.
