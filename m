Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57910 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753742AbdBNNva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:51:30 -0500
Subject: Re: [PATCH 06/10] rt2x00: fixup fill_tx_status for nomatch case
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
 <1487076368-7020-7-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ede59ed8-5ffe-f188-4761-d90db2b9138a@nbd.name> (sfid-20170214_145301_078894_0146C478)
Date: Tue, 14 Feb 2017 14:51:28 +0100
MIME-Version: 1.0
In-Reply-To: <1487076368-7020-7-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-14 13:46, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   | 6 +++++-
>  drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 1 +
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 90fc259..258d94d 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -357,6 +357,9 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
>  	if (i < (IEEE80211_TX_MAX_RATES - 1))
>  		tx_info->status.rates[i].idx = -1; /* terminate */
>  
> +	if (!test_bit(TXDONE_ACK_REQ, &txdesc->flags))
> +		tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
> +
Since nothing sets TXDONE_ACK_REQ, this will probably create a regression.

- Felix
