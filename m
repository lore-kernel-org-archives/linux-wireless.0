Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17348 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbYLCCXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:23:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:23:40 -0800
Date: Tue, 2 Dec 2008 18:23:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 1/2] ath9k: Check for pci_map_single() errors
Message-ID: <20081203022338.GK9351@tesla> (sfid-20081203_032350_003876_5A234184)
References: <1228270866-21516-1-git-send-email-lrodriguez@atheros.com> <1228270866-21516-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228270866-21516-2-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2008 at 06:21:05PM -0800, Luis Rodriguez wrote:
> pci_map_single() can fail so detect those errors with
> pci_dma_mapping_error() and deal with them accordingly.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath9k/beacon.c |   16 +++++++++++++++-
>  drivers/net/wireless/ath9k/recv.c   |   15 +++++++++++++++
>  drivers/net/wireless/ath9k/xmit.c   |   23 +++++++++++++++++++++--
>  3 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
> index e80d9b9..a393761 100644
> --- a/drivers/net/wireless/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath9k/beacon.c
> @@ -192,6 +192,13 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
>                 pci_map_single(sc->pdev, skb->data,
>                                skb->len,
>                                PCI_DMA_TODEVICE);
> +       if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
> +               dev_kfree_skb(skb);

Bleh, these are all wrong, they should be dev_kfree_skb_any(skb).

  Luis

