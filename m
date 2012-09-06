Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11589 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab2IFQCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 12:02:06 -0400
Message-ID: <5048C901.5010704@linux.intel.com> (sfid-20120906_180210_645498_9B4A9ADD)
Date: Thu, 06 Sep 2012 18:02:09 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
CC: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	sameo@linux.intel.com, eric.lapuyade@intel.com
Subject: Re: [linux-nfc] [PATCH 1/2] NFC: Remove crc generation from shdlc
 layer
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldemar,

On 09/06/2012 12:22 PM, Waldemar Rymarkiewicz wrote:
> Checksum is specific for a chip spcification and it varies
> (in size and type) between different hardware. It should be
> handled in the driver then.
> 
> Moreover, shdlc spec doesn't mention crc as a part of the frame.
> 
> Update pn544_hci driver as well.
> 
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> ---
>  drivers/nfc/pn544_hci.c |   19 ++++++++++++++++++-
>  net/nfc/hci/shdlc.c     |   27 ++-------------------------
>  2 files changed, 20 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
> index 9458d53..4e0716c 100644
> --- a/drivers/nfc/pn544_hci.c
> +++ b/drivers/nfc/pn544_hci.c
> @@ -128,6 +128,7 @@ static struct nfc_hci_gate pn544_gates[] = {
>  
>  /* Largest headroom needed for outgoing custom commands */
>  #define PN544_CMDS_HEADROOM	2
> +#define PN544_CMDS_TAILROOM	2
>  
>  struct pn544_hci_info {
>  	struct i2c_client *i2c_dev;
> @@ -576,6 +577,20 @@ static int pn544_hci_ready(struct nfc_shdlc *shdlc)
>  	return 0;
>  }
>  
> +static void pn544_hci_add_len_crc(struct sk_buff *skb)
> +{
> +	u16 crc;
> +	int len;
> +
> +	len = skb->len + 2;
> +	*skb_push(skb, 1) = len;
> +
> +	crc = crc_ccitt(0xffff, skb->data, skb->len);
> +	crc = ~crc;
> +	*skb_put(skb, 1) = crc & 0xff;
> +	*skb_put(skb, 1) = crc >> 8;
> +}
> +
>  static int pn544_hci_xmit(struct nfc_shdlc *shdlc, struct sk_buff *skb)
>  {
>  	struct pn544_hci_info *info = nfc_shdlc_get_clientdata(shdlc);
> @@ -584,6 +599,8 @@ static int pn544_hci_xmit(struct nfc_shdlc *shdlc, struct sk_buff *skb)
>  	if (info->hard_fault != 0)
>  		return info->hard_fault;
>  
> +	pn544_hci_add_len_crc(skb);
> +
>  	return pn544_hci_i2c_write(client, skb->data, skb->len);
>  }
>  
> @@ -874,7 +891,7 @@ static int __devinit pn544_hci_probe(struct i2c_client *client,
>  
>  	info->shdlc = nfc_shdlc_allocate(&pn544_shdlc_ops,
>  					 &init_data, protocols,
> -					 PN544_CMDS_HEADROOM, 0,
> +					 PN544_CMDS_HEADROOM, PN544_CMDS_TAILROOM,
>  					 PN544_HCI_LLC_MAX_PAYLOAD,
>  					 dev_name(&client->dev));
>  	if (!info->shdlc) {
> diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
> index d4fe5e9..8a5f034 100644
> --- a/net/nfc/hci/shdlc.c
> +++ b/net/nfc/hci/shdlc.c
> @@ -22,7 +22,6 @@
>  #include <linux/sched.h>
>  #include <linux/export.h>
>  #include <linux/wait.h>
> -#include <linux/crc-ccitt.h>
>  #include <linux/slab.h>
>  #include <linux/skbuff.h>
>  
> @@ -30,7 +29,6 @@
>  #include <net/nfc/shdlc.h>
>  
>  #define SHDLC_LLC_HEAD_ROOM	2
> -#define SHDLC_LLC_TAIL_ROOM	2
>  
>  #define SHDLC_MAX_WINDOW	4
>  #define SHDLC_SREJ_SUPPORT	false
> @@ -94,28 +92,13 @@ static struct sk_buff *nfc_shdlc_alloc_skb(struct nfc_shdlc *shdlc,
>  	struct sk_buff *skb;
>  
>  	skb = alloc_skb(shdlc->client_headroom + SHDLC_LLC_HEAD_ROOM +
> -			shdlc->client_tailroom + SHDLC_LLC_TAIL_ROOM +
> -			payload_len, GFP_KERNEL);
> +			shdlc->client_tailroom + payload_len, GFP_KERNEL);
>  	if (skb)
>  		skb_reserve(skb, shdlc->client_headroom + SHDLC_LLC_HEAD_ROOM);
>  
>  	return skb;
>  }
>  
> -static void nfc_shdlc_add_len_crc(struct sk_buff *skb)
> -{
> -	u16 crc;
> -	int len;
> -
> -	len = skb->len + 2;
> -	*skb_push(skb, 1) = len;
> -
> -	crc = crc_ccitt(0xffff, skb->data, skb->len);
> -	crc = ~crc;
> -	*skb_put(skb, 1) = crc & 0xff;
> -	*skb_put(skb, 1) = crc >> 8;
> -}
> -
>  /* immediately sends an S frame. */
>  static int nfc_shdlc_send_s_frame(struct nfc_shdlc *shdlc,
>  				  enum sframe_type sframe_type, int nr)
> @@ -131,8 +114,6 @@ static int nfc_shdlc_send_s_frame(struct nfc_shdlc *shdlc,
>  
>  	*skb_push(skb, 1) = SHDLC_CONTROL_HEAD_S | (sframe_type << 3) | nr;
>  
> -	nfc_shdlc_add_len_crc(skb);
> -
>  	r = shdlc->ops->xmit(shdlc, skb);
>  
>  	kfree_skb(skb);
> @@ -151,8 +132,6 @@ static int nfc_shdlc_send_u_frame(struct nfc_shdlc *shdlc,
>  
>  	*skb_push(skb, 1) = SHDLC_CONTROL_HEAD_U | uframe_modifier;
>  
> -	nfc_shdlc_add_len_crc(skb);
> -
>  	r = shdlc->ops->xmit(shdlc, skb);
>  
>  	kfree_skb(skb);
> @@ -510,8 +489,6 @@ static void nfc_shdlc_handle_send_queue(struct nfc_shdlc *shdlc)
>  			 shdlc->nr);
>  	/*	SHDLC_DUMP_SKB("shdlc frame written", skb); */
>  
> -		nfc_shdlc_add_len_crc(skb);
> -
>  		r = shdlc->ops->xmit(shdlc, skb);
>  		if (r < 0) {
>  			shdlc->hard_fault = r;
> @@ -881,7 +858,7 @@ struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
>  
>  	shdlc->hdev = nfc_hci_allocate_device(&shdlc_ops, init_data, protocols,
>  					      tx_headroom + SHDLC_LLC_HEAD_ROOM,
> -					      tx_tailroom + SHDLC_LLC_TAIL_ROOM,
> +					      tx_tailroom,
>  					      max_link_payload);
>  	if (shdlc->hdev == NULL)
>  		goto err_allocdev;
> 

You are certainly right that the CRC belongs to the driver.

Acked-by: Eric Lapuyade <eric.lapuyade@intel.com>
