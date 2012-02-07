Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53602 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2BGXed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 18:34:33 -0500
Received: by iacb35 with SMTP id b35so10779549iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 15:34:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BC8BC73D12649F439B502B4CB6FD58B1053E2D3F@BE23.exg4.exghost.com>
References: <BC8BC73D12649F439B502B4CB6FD58B1053E2D3F@BE23.exg4.exghost.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Feb 2012 10:34:13 +1100
Message-ID: <CAGRGNgWPzrBw27SAhpvgwpv-=WpPE49KJDJBK6iHXCXDgBNgUA@mail.gmail.com> (sfid-20120208_003437_276957_4529135D)
Subject: Re: [PATCH] rtlwifi: Hopefully not mangled this time -- Handle
 previous allocation failures when freeing device memory
To: Simon Graham <simon.graham@virtualcomputer.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon,

It's still mangled.

There's a file in Documentation that details how to get the best out of mailers.

I'm guessing you're using some variant of Microsoft Outlook (as your
mail is going through an Exchange server) which, IIRC simply refuses
not to mangle patches.

Also, remember that the subject of the email (everything except the
[PATCH] at the start) becomes part of the commit log, so if you want
to mark that a patch is being re-sent, do it after the '---' line in
the commit log, and change the [PATCH] in the subject to [PATCH v2] or
whatever.

Thanks,

Julian Calaby

On Wed, Feb 8, 2012 at 10:23, Simon Graham
<simon.graham@virtualcomputer.com> wrote:
> Handle previous allocation failures when freeing device memory
>
> Signed-off-by: Simon Graham <simon.graham@virtualcomputer.com>
> ---
>  drivers/net/wireless/rtlwifi/pci.c |   24 ++++++++++++++----------
>  1 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c
> b/drivers/net/wireless/rtlwifi/pci.c
> index c5f6a32..fb84707 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1148,10 +1148,12 @@ static void _rtl_pci_free_tx_ring(struct
> ieee80211_hw *hw,
>                ring->idx = (ring->idx + 1) % ring->entries;
>        }
>
> -       pci_free_consistent(rtlpci->pdev,
> -                           sizeof(*ring->desc) * ring->entries,
> -                           ring->desc, ring->dma);
> -       ring->desc = NULL;
> +       if (ring->desc) {
> +               pci_free_consistent(rtlpci->pdev,
> +                               sizeof(*ring->desc) * ring->entries,
> +                               ring->desc, ring->dma);
> +               ring->desc = NULL;
> +       }
>  }
>
>  static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci)
> @@ -1175,13 +1177,14 @@ static void _rtl_pci_free_rx_ring(struct rtl_pci
> *rtlpci)
>                        kfree_skb(skb);
>                }
>
> -               pci_free_consistent(rtlpci->pdev,
> -
> sizeof(*rtlpci->rx_ring[rx_queue_idx].
> -                                          desc) * rtlpci->rxringcount,
> -                                   rtlpci->rx_ring[rx_queue_idx].desc,
> -                                   rtlpci->rx_ring[rx_queue_idx].dma);
> -               rtlpci->rx_ring[rx_queue_idx].desc = NULL;
> +               if (rtlpci->rx_ring[rx_queue_idx].desc) {
> +                       pci_free_consistent(rtlpci->pdev,
> +
> sizeof(*rtlpci->rx_ring[rx_queue_idx].
> +                                              desc) *
> rtlpci->rxringcount,
> +
> rtlpci->rx_ring[rx_queue_idx].desc,
> +
> rtlpci->rx_ring[rx_queue_idx].dma);
> +                       rtlpci->rx_ring[rx_queue_idx].desc = NULL;
> +               }
>        }
>  }
>
> --
> 1.7.8.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
