Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2GLRsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 13:48:37 -0400
Date: Thu, 12 Jul 2012 13:30:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>
Subject: Re: [PATCH 1/2] NFC: Set target nfcid1 for all HCI reader A targets
Message-ID: <20120712173035.GA25494@tuxdriver.com> (sfid-20120712_194841_602860_E12B4328)
References: <1342113454-23110-1-git-send-email-sameo@linux.intel.com>
 <1342113454-23110-2-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342113454-23110-2-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the bug we are preventing with this?

On Thu, Jul 12, 2012 at 07:17:33PM +0200, Samuel Ortiz wrote:
> From: Eric Lapuyade <eric.lapuyade@intel.com>
> 
> Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
> Reported-by: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  net/nfc/hci/core.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
> index e1a640d..7b1ca7d 100644
> --- a/net/nfc/hci/core.c
> +++ b/net/nfc/hci/core.c
> @@ -170,6 +170,7 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
>  	struct nfc_target *targets;
>  	struct sk_buff *atqa_skb = NULL;
>  	struct sk_buff *sak_skb = NULL;
> +	struct sk_buff *uid_skb = NULL;
>  	int r;
>  
>  	pr_debug("from gate %d\n", gate);
> @@ -205,6 +206,19 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
>  		targets->sens_res = be16_to_cpu(*(u16 *)atqa_skb->data);
>  		targets->sel_res = sak_skb->data[0];
>  
> +		r = nfc_hci_get_param(hdev, NFC_HCI_RF_READER_A_GATE,
> +				      NFC_HCI_RF_READER_A_UID, &uid_skb);
> +		if (r < 0)
> +			goto exit;
> +
> +		if (uid_skb->len == 0 || uid_skb->len > NFC_NFCID1_MAXSIZE) {
> +			r = -EPROTO;
> +			goto exit;
> +		}
> +
> +		memcpy (targets->nfcid1, uid_skb->data, uid_skb->len);
> +		targets->nfcid1_len = uid_skb->len;
> +
>  		if (hdev->ops->complete_target_discovered) {
>  			r = hdev->ops->complete_target_discovered(hdev, gate,
>  								  targets);
> @@ -240,6 +254,7 @@ exit:
>  	kfree(targets);
>  	kfree_skb(atqa_skb);
>  	kfree_skb(sak_skb);
> +	kfree_skb(uid_skb);
>  
>  	return r;
>  }
> -- 
> 1.7.10
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
