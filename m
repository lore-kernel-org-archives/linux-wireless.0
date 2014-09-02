Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61700 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaIBHCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140901172729.GA6549@mwanda>
References: <20140901172729.GA6549@mwanda>
Date: Tue, 2 Sep 2014 09:02:36 +0200
Message-ID: <CAH6sp9NXUtOpagcaKOTJUH4m=2YcdeVoKDU4AHSvzyr+qcsFTA@mail.gmail.com> (sfid-20140902_090244_227130_9A16BC59)
Subject: Re: [patch -RESEND] NFC: potential overflows in microread_target_discovered()
From: Frans Klaver <fransklaver@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
	kernel-janitors@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Sep 1, 2014 at 7:27 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Smatch says that skb->data is untrusted so we need to check to make sure
> that the memcpy() doesn't overflow.
>
> Fixes: cfad1ba87150 ('NFC: Initial support for Inside Secure microread')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I sent this in January but never received any response.  I don't know
> the subsystem very well but it looks like it could have security
> implications.
>
> Compile tested only.
>
> diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
> index f868333271aa..963a4a5dc88e 100644
> --- a/drivers/nfc/microread/microread.c
> +++ b/drivers/nfc/microread/microread.c
> @@ -501,9 +501,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
>                 targets->sens_res =
>                          be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
>                 targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
> -               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
> -                      skb->data[MICROREAD_EMCF_A_LEN]);
>                 targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
> +               if (targets->nfcid1_len > sizeof(targets->nfcid1)) {

You should probably compare against sizeof(*targets->nfcid1).


> +                       r = -EINVAL;
> +                       goto exit_free;
> +               }
> +               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
> +                      targets->nfcid1_len);
>                 break;
>         case MICROREAD_GATE_ID_MREAD_ISO_A_3:
>                 targets->supported_protocols =
> @@ -511,9 +515,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
>                 targets->sens_res =
>                          be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
>                 targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
> -               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
> -                      skb->data[MICROREAD_EMCF_A3_LEN]);
>                 targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
> +               if (targets->nfcid1_len > sizeof(targets->nfcid1)) {

Same here.

> +                       r = -EINVAL;
> +                       goto exit_free;
> +               }
> +               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
> +                      targets->nfcid1_len);
>                 break;
>         case MICROREAD_GATE_ID_MREAD_ISO_B:
>                 targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
