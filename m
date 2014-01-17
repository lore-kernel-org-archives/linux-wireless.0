Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-04.prod.phx3.secureserver.net ([173.201.192.105]:53405
	"EHLO p3plsmtpa06-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbaAQSrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 13:47:00 -0500
Date: Fri, 17 Jan 2014 11:39:03 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH 2/3] NFC: iso15693 - Add Digital Layer support for
 ISO/IEC 15693
Message-ID: <20140117183903.GA9152@animalcreek.com> (sfid-20140117_194704_460214_23A88911)
References: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
 <1389747131-2577-3-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389747131-2577-3-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 14, 2014 at 05:52:10PM -0700, Mark A. Greer wrote:

> diff --git a/net/nfc/digital_technology.c b/net/nfc/digital_technology.c
> index 251c8c7..6d3d03f 100644
> --- a/net/nfc/digital_technology.c
> +++ b/net/nfc/digital_technology.c

> @@ -473,6 +495,92 @@ int digital_in_send_sensf_req(struct nfc_digital_dev *ddev, u8 rf_tech)
>  	return rc;
>  }
>  
> +static void digital_in_recv_iso15693_inv_res(struct nfc_digital_dev *ddev,
> +		void *arg, struct sk_buff *resp)
> +{
> +	struct digital_iso15693_inv_res *res;
> +	struct nfc_target *target = NULL;
> +	int rc;
> +
> +	if (IS_ERR(resp)) {
> +		rc = PTR_ERR(resp);
> +		resp = NULL;
> +		goto out_free_skb;
> +	}
> +
> +	if (resp->len != sizeof(*res)) {
> +		rc = -EIO;
> +		goto out_free_skb;
> +	}
> +
> +	res = (struct digital_iso15693_inv_res *)resp->data;
> +
> +	if (!DIGITAL_ISO15693_RES_IS_VALID(res->flags)) {
> +		PROTOCOL_ERR("ISO15693 - 10.3.1");
> +		rc = -EINVAL;
> +		goto out_free_skb;
> +	}
> +
> +	target = kzalloc(sizeof(struct nfc_target), GFP_KERNEL);

I have rewritten this line to be:
	
	target = kzalloc(sizeof(*target), GFP_KERNEL);

> +	if (!target) {
> +		rc = -ENOMEM;
> +		goto out_free_skb;
> +	}
> +
> +	target->is_iso15693 = 1;
> +	target->iso15693_dsfid = res->dsfid;
> +	memcpy(target->iso15693_uid, &res->uid, sizeof(target->iso15693_uid));
> +
> +	rc = digital_target_found(ddev, target, NFC_PROTO_ISO15693);
> +
> +	kfree(target);
> +
> +out_free_skb:
> +	dev_kfree_skb(resp);
> +
> +	if (rc)
> +		digital_poll_next_tech(ddev);
> +}
> +
> +int digital_in_send_iso15693_inv_req(struct nfc_digital_dev *ddev, u8 rf_tech)
> +{
> +	struct digital_iso15693_inv_req *req;
> +	struct sk_buff *skb;
> +	int rc;
> +
> +	rc = digital_in_configure_hw(ddev, NFC_DIGITAL_CONFIG_RF_TECH,
> +				     NFC_DIGITAL_RF_TECH_ISO15693);
> +	if (rc)
> +		return rc;
> +
> +	rc = digital_in_configure_hw(ddev, NFC_DIGITAL_CONFIG_FRAMING,
> +				     NFC_DIGITAL_FRAMING_ISO15693_INVENTORY);
> +	if (rc)
> +		return rc;
> +
> +	skb = digital_skb_alloc(ddev, sizeof(*req));
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_put(skb, sizeof(*req) - sizeof(req->mask)); /* No mask */
> +	req = (struct digital_iso15693_inv_req *)skb->data;
> +
> +	/* Single sub-carrier, high data rate, no AFI, single slot
> +	 * Inventory command
> +	 */
> +	req->flags = DIGITAL_ISO15693_REQ_FLAG_DATA_RATE |
> +		     DIGITAL_ISO15693_REQ_FLAG_INVENTORY |
> +		     DIGITAL_ISO15693_REQ_FLAG_NB_SLOTS;
> +	req->cmd = DIGITAL_CMD_ISO15693_INVENTORY_REQ;

And added this line:

	req->mask_len = 0;

> +	rc = digital_in_send_cmd(ddev, skb, 30,
> +				 digital_in_recv_iso15693_inv_res, NULL);
> +	if (rc)
> +		kfree_skb(skb);
> +
> +	return rc;
> +}
> +
>  static int digital_tg_send_sel_res(struct nfc_digital_dev *ddev)
>  {
>  	struct sk_buff *skb;
> -- 
> 1.8.3.4
> 
