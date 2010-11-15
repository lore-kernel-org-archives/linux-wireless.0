Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65176 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab0KOL2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 06:28:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 03:27:53 -0800
Date: Mon, 15 Nov 2010 16:57:52 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 11/13] ath9k: block new AMPDU sessions if SC_OP_TXAGGR
	is not set
Message-ID: <20101115112752.GA25277@vasanth-laptop>
References: <1289744413-20789-2-git-send-email-nbd@openwrt.org> <1289744413-20789-3-git-send-email-nbd@openwrt.org> <1289744413-20789-4-git-send-email-nbd@openwrt.org> <1289744413-20789-5-git-send-email-nbd@openwrt.org> <1289744413-20789-6-git-send-email-nbd@openwrt.org> <1289744413-20789-7-git-send-email-nbd@openwrt.org> <1289744413-20789-8-git-send-email-nbd@openwrt.org> <1289744413-20789-9-git-send-email-nbd@openwrt.org> <1289744413-20789-10-git-send-email-nbd@openwrt.org> <1289744413-20789-11-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289744413-20789-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 14, 2010 at 07:50:11PM +0530, Felix Fietkau wrote:
> This makes further tx path cleanups easier
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 8464ca3..50bdb5d 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1992,6 +1992,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
>  	case IEEE80211_AMPDU_RX_STOP:
>  		break;
>  	case IEEE80211_AMPDU_TX_START:
> +		if (!(sc->sc_flags & SC_OP_TXAGGR))
> +			return -EOPNOTSUPP;

SC_OP_TXAGGR is set when the hw supports tx AMPDU, I think
mac80211 does not call drv_ampdu_action() if hw does not
support AMPDU.

Vasanth
