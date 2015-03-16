Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35606 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbCPM2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 08:28:42 -0400
Message-ID: <5506CC74.107@m4x.org> (sfid-20150316_132858_710676_4F90DDD6)
Date: Mon, 16 Mar 2015 20:28:36 +0800
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
To: christophe.ricard@gmail.com, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: fix st21nfca_get_iso14443_3_uid data copy
References: <54F17F43.7060605@m4x.org> <1425358732-31752-1-git-send-email-nicolas.iooss_linux@m4x.org>
In-Reply-To: <1425358732-31752-1-git-send-email-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I have not received any comments about this patch so I'm sending it
again.  Could you please review it?

Nicolas

On 03/03/2015 12:58 PM, Nicolas Iooss wrote:
> st21nfca_get_iso14443_3_uid() does not correctly copy the uid from
> uid_skb->data to its gate parameter.  "gate = uid_skb->data;" only puts
> a pointer to uid_skb->data to the local variable gate.  This means that
> in st21nfca_hci_target_from_gate() the content of "u8
> uid[NFC_NFCID1_MAXSIZE]" local variable is never initialized before
> being used in memcpy(target->nfcid1, uid, len).
> 
> Fix this by replacing the local variable assignment with a memcpy.
> 
> This was found by compiling Linux with "gcc -Wunused-but-set-parameter".
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
> 
> As I did not get any reply from https://lkml.org/lkml/2015/2/28/25 and
> got confirmation by other people that this may be a real bug, I am now
> sending a patch to fix it.
> 
>  drivers/nfc/st21nfca/st21nfca.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/st21nfca/st21nfca.c b/drivers/nfc/st21nfca/st21nfca.c
> index 24d3d240d5f4..ff70d2838b29 100644
> --- a/drivers/nfc/st21nfca/st21nfca.c
> +++ b/drivers/nfc/st21nfca/st21nfca.c
> @@ -588,7 +588,7 @@ static int st21nfca_get_iso14443_3_uid(struct nfc_hci_dev *hdev, u8 *gate,
>  		goto exit;
>  	}
>  
> -	gate = uid_skb->data;
> +	memcpy(gate, uid_skb->data, uid_skb->len);
>  	*len = uid_skb->len;
>  exit:
>  	kfree_skb(uid_skb);
> 
