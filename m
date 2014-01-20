Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48930 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaATSDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:03:39 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: NFC: Initial support for Inside Secure microread
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140120142952.GB4954@elgon.mountain>
Date: Mon, 20 Jan 2014 10:03:31 -0800
Cc: eric.lapuyade@linux.intel.com,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-nfc@ml01.01.org NFC" <linux-nfc@ml01.01.org>,
	Johannes Berg <johannes@sipsolutions.net>
Message-Id: <F22F3A10-5563-4B01-BAF7-869FA6BDA43A@holtmann.org> (sfid-20140120_190353_618392_5B0CE5F0)
References: <20140120142952.GB4954@elgon.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> The patch cfad1ba87150: "NFC: Initial support for Inside Secure
> microread" from Dec 18, 2012, leads to the following
> Sparse warning:
> 
> 	drivers/nfc/microread/microread.c:534:25:
> 	warning: cast to restricted __le16"
> 
> drivers/nfc/microread/microread.c
>   512          case MICROREAD_GATE_ID_MREAD_ISO_A_3:
>   513                  targets->supported_protocols =
>   514                        nfc_hci_sak_to_protocol(skb->data[MICROREAD_EMCF_A3_SAK]);
>   515                  targets->sens_res =
>   516                           be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
>                                 ^^^^^^^^^^^
> sens_res is network (big) endian here.  We could silence the sparse
> warning by doing:
> 
> 			argets->sens_res =
> 				ntohs(*(__be16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);

wouldn't it be easier to just use get_unaligned_be16. I am not even sure that we actually have a proper alignment on all architecture here. So this might be safer anyway. Eric?

> 
>   517                  targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
>   518                  targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
>   519                  if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
>   520                          r = -EINVAL;
>   521                          goto exit_free;
>   522                  }
>   523                  memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
>   524                         targets->nfcid1_len);
>   525                  break;
>   526          case MICROREAD_GATE_ID_MREAD_ISO_B:
>   527                  targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
>   528                  memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_B_UID], 4);
>   529                  targets->nfcid1_len = 4;
>   530                  break;
>   531          case MICROREAD_GATE_ID_MREAD_NFC_T1:
>   532                  targets->supported_protocols = NFC_PROTO_JEWEL_MASK;
>   533                  targets->sens_res =
>   534                          le16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_T1_ATQA]);
>                                ^^^^^^^^^^^
> But here it is little endian.  This seems like either a horrible
> protocol or a bug in the code.
> 
>   535                  memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_T1_UID], 4);
>   536                  targets->nfcid1_len = 4;
>   537                  break;
> 
> Btw, we also don't seem to check if we are reading beyond the end of
> skb->len.  This would only be a problem if we got unlucky and skb->data
> were allocated at the end of page.  The read beyond the end of the page
> would cause an oops.

Regards

Marcel

