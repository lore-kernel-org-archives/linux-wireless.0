Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdHNE4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 00:56:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 06/11] rsi: handle station disconnection in AP mode
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
        <1502458889-9690-7-git-send-email-amitkarwar@gmail.com>
Date: Mon, 14 Aug 2017 07:55:56 +0300
In-Reply-To: <1502458889-9690-7-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Fri, 11 Aug 2017 19:11:24 +0530")
Message-ID: <87fucud9yb.fsf@kamboji.qca.qualcomm.com> (sfid-20170814_065605_365009_681E8F1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> When sta_remove of mac80211 is called, driver iterates through
> list of existing stations to get the station id. Then peer notify
> is prepared and send to firmare.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 57 +++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index cf86162..6eb93ad 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -1255,21 +1255,56 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
>  {
>  	struct rsi_hw *adapter = hw->priv;
>  	struct rsi_common *common = adapter->priv;
> +	struct ieee80211_bss_conf *bss = &vif->bss_conf;
> +	struct rsi_sta *rsta;
> +
> +	print_hex_dump(KERN_INFO, "Station Remove: ", DUMP_PREFIX_OFFSET,
> +		       16, 1, sta->addr, ETH_ALEN, 0);

Same here, please convert it to a debug message.

-- 
Kalle Valo
