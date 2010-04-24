Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57111 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0DXDpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 23:45:55 -0400
Message-ID: <4BD2696D.9030509@openwrt.org>
Date: Sat, 24 Apr 2010 05:45:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Subject: Re: [PATCH] ath9k: Avoid corrupt frames being forwarded to mac80211.
References: <1272007564-6265-1-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1272007564-6265-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-23 9:26 AM, Vivek Natarajan wrote:
> If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
> with WEP or TKIP, eventhough the received frame may be a CRC failed
> corrupted frame.
> 
> Cc: stable@kernel.org
> Reported-by: Johan Hovold <johan.hovold@lundinova.se>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h |    2 +-
>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
> index cd953f6..025c31a 100644
> --- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
> @@ -249,7 +249,7 @@ static const u32 ar5416Common[][2] = {
>      { 0x00008258, 0x00000000 },
>      { 0x0000825c, 0x400000ff },
>      { 0x00008260, 0x00080922 },
> -    { 0x00008264, 0xa8000010 },
> +    { 0x00008264, 0x88000010 },
I don't think this is enough. This register is called
AR_MAC_PCU_LOGIC_ANALYZER and the field you're modifying
(AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768) is being touched by the function
ar9002_hw_enable_async_fifo() in ar9002_hw.c.
So unless this AR9287 v1.2 or later is unaffected by this issue, the
REG_SET_BIT call should be removed as well.
By the way, is this change in the other Atheros codebases as well? If
so, maybe this change should go into the ini override functions instead,
to make it easier to keep initvals in sync.

- Felix
