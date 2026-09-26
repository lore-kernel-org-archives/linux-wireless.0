Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718B23A99F
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790445635; cv=none; b=VvU1r+4rZA1Nj7i/UdnZcpxsfEa7HJGu+YUU3DNsj37p3XxV3GBhdeZujn7D6FxCJweLnZMZBuJLTnpZCaBDWTzyoYx7HHUk8lCFgWs32UDM4uJSr9o04sPgPmbBWhsJcQzeogoXSXB25lg5vSl/Ac30WhKIVwvLa9dwhEumlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790445635; c=relaxed/simple;
	bh=1I/pkH9P7doxx9wAsUhPnxXyh3YCrUbFwor1VSJVm4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tR9O326DlOseSiWxlXkrl9vXI4a2yamrZ9x8RKLqnYXIbhNVfrM4cSvC+ZVFzz+7UQHbmKcKZmiYza0yEzVK5JQaLHg8KDh4JuDaxRjYLrvyC1mM8hMKOBnoGYrvJVIfKrCfkawcZUDea980OB9F2PrYGX0ZPLrmxf9SUB4WVFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vOaSRIO6; arc=none smtp.client-ip=91.218.175.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vOaSRIO6"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1I/pkH9P7doxx9wAsUhPnxXyh3YCrUbFwor1VSJVm4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790445630; v=1; x=1791050430;
 b=vOaSRIO6fAf+mmmuVfAM1q/X1CJBDUSVjV3pbOM7UKH2lf9Ss/DpEhJi4zr0A4ptn8dqHWVl
 7LEpUqlqx/LpgNnf//z0kdVNkUVztzJZdCIkNbp5507dbjnu0/WL+EOxj/qcpOycd1bMxjkgSZT
 x89IgjL8n5t5jMhFOfL9uYLY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 78ecacf6b2f1336b;
	Sat, 26 Sep 2026 18:00:29 +0000
X-Mizu-Trace-ID: 78ecacf6b2f1336b
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	luka.gejak@linux.dev
Subject: Re: [PATCH rtw-next] wifi: rtw88: TX report with long timeout for non-PCIE devices
Date: Sat, 26 Sep 2026 18:00:07 +0000
Message-ID: <20260926180007.28030-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924004637.9958-1-pkshih@realtek.com>
References: <20260924004637.9958-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 24 Sep 2026 08:46:37 +0800, Ping-Ke Shih <pkshih@realtek.com> wrote:

> 
> Many USB and SDIO devices can't report TX status within 500 ms, and
> extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
> To avoid adding chip ID one by one, and this change looks harmless.
> Keep PCIE using short timeout, and others use long timeout.
> 
> [1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.schlehofer@gmail.com/
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/tx.c | 10 +++++-----
>  drivers/net/wireless/realtek/rtw88/tx.h |  3 ++-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
> index 4e110a457e71..701ed7c4f3f7 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.c
> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
> @@ -196,7 +196,7 @@ void rtw_tx_report_purge_timer(struct timer_list *t)
>  void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
>  {
>  	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
> -	unsigned long timeout = RTW_TX_PROBE_TIMEOUT;
> +	unsigned long timeout;
>  	unsigned long flags;
>  	u8 *drv_data;
>  
> @@ -208,10 +208,10 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
>  	__skb_queue_tail(&tx_report->queue, skb);
>  	spin_unlock_irqrestore(&tx_report->q_lock, flags);
>  
> -	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
> -	     rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
> -	    rtw_is_8723bs(rtwdev))
> -		timeout = msecs_to_jiffies(2500);
> +	if (rtwdev->hci.type == RTW_HCI_TYPE_PCIE)
> +		timeout = RTW_TX_PROBE_TIMEOUT_SHORT;
> +	else
> +		timeout = RTW_TX_PROBE_TIMEOUT_LONG;
>  
>  	mod_timer(&tx_report->purge_timer, jiffies + timeout);
>  }
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
> index d34cdeca16f1..168f48e87853 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.h
> +++ b/drivers/net/wireless/realtek/rtw88/tx.h
> @@ -7,7 +7,8 @@
>  
>  #define RTK_TX_MAX_AGG_NUM_MASK		0x1f
>  
> -#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
> +#define RTW_TX_PROBE_TIMEOUT_SHORT	msecs_to_jiffies(500)
> +#define RTW_TX_PROBE_TIMEOUT_LONG	msecs_to_jiffies(2500)
>  
>  struct rtw_tx_desc {
>  	__le32 w0;
> 
> base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
> -- 
> 2.25.1
> 
Hi Ping-Ke,

I support this change and have tested it on my rtl8723bs.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
