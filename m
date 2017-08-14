Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdHNEyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 00:54:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 05/11] rsi: handle station connection in AP mode
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
        <1502458889-9690-6-git-send-email-amitkarwar@gmail.com>
Date: Mon, 14 Aug 2017 07:54:42 +0300
In-Reply-To: <1502458889-9690-6-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Fri, 11 Aug 2017 19:11:23 +0530")
Message-ID: <87k226da0d.fsf@kamboji.qca.qualcomm.com> (sfid-20170814_065454_524365_BC7545C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Station structures are maintained in driver with required
> fields. When mac80211 callback sta_add is called, driver
> iterates through list of connected stations to check available
> index and assigns station id which is important for further
> communication to that station. Then peer notify frame is send
> to firmware to inform the firmware about new station connection.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> @@ -1157,18 +1159,81 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
>  {
>  	struct rsi_hw *adapter = hw->priv;
>  	struct rsi_common *common = adapter->priv;
> +	bool sta_exist = false;
> +	struct rsi_sta *rsta;
> +
> +	print_hex_dump(KERN_INFO, "Station add: ", DUMP_PREFIX_OFFSET,
> +		       16, 1, sta->addr, ETH_ALEN, 0);

The driver should not spam the logs every time a client connects, so
this should be a debug message.

-- 
Kalle Valo
