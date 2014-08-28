Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46789 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaH1SpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 14:45:17 -0400
Date: Thu, 28 Aug 2014 14:40:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Marc Yang <yangyang@marvell.com>
Subject: Re: [PATCH 1/4] mwifiex: avoid processing RX packets with invalid
 length
Message-ID: <20140828184036.GO13758@tuxdriver.com> (sfid-20140828_204550_797504_B8A198EC)
References: <CBACCFA0AEB13A41977475BCF3E896FC4781147C21@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC4781147C21@SC-VEXCH2.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does not apply...

On Mon, Aug 18, 2014 at 02:07:10AM -0700, Avinash Patil wrote:
> If rx_len received in interface header from FW is more than
> RX buffer size, skb_put for such length results into skb_panic.
> Avoid this by not processing such packets. We just print a warning
> for such packets and free skb.
> 
> Reviewed-by: Paul Stewart <pstew@chromium.org>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Marc Yang <yangyang@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/pcie.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index c16dd2c..fbb0550 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -1271,12 +1271,20 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
>                  */
>                 pkt_len = *((__le16 *)skb_data->data);
>                 rx_len = le16_to_cpu(pkt_len);
> -               skb_put(skb_data, rx_len);
> -               dev_dbg(adapter->dev,
> -                       "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
> -                       card->rxbd_rdptr, wrptr, rx_len);
> -               skb_pull(skb_data, INTF_HEADER_LEN);
> -               mwifiex_handle_rx_packet(adapter, skb_data);
> +               if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
> +                           rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
> +                       dev_err(adapter->dev,
> +                               "Invalid RX len %d, Rd=%#x, Wr=%#x\n",
> +                               rx_len, card->rxbd_rdptr, wrptr);
> +                       dev_kfree_skb_any(skb_data);
> +               } else {
> +                       skb_put(skb_data, rx_len);
> +                       dev_dbg(adapter->dev,
> +                               "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
> +                               card->rxbd_rdptr, wrptr, rx_len);
> +                       skb_pull(skb_data, INTF_HEADER_LEN);
> +                       mwifiex_handle_rx_packet(adapter, skb_data);
> +               }
> 
>                 skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
>                 if (!skb_tmp) {
> -- 
> 1.8.1.4
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
