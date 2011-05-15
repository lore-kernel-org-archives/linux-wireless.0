Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57994 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1EOSKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 14:10:23 -0400
Message-ID: <4DD01708.3000603@hauke-m.de> (sfid-20110515_201027_591006_DB0A90CE)
Date: Sun, 15 May 2011 20:10:16 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Clemens Noss <cnoss@gmx.de>
CC: linux-wireless@vger.kernel.org, arend@broadcom.com,
	rvossen@broadcom.com, henryp@broadcom.com, brudley@broadcom.com
Subject: Re: [PATCH] staging: brcm80211: fix cast to pointer from integer
References: <1305479060-22755-1-git-send-email-cnoss@gmx.de>
In-Reply-To: <1305479060-22755-1-git-send-email-cnoss@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2011 07:04 PM, Clemens Noss wrote:
> bcm_pktq_flush and related functions only ever get 0 or a pointer for
> arg, so make it a pointer.
> 
> This might fix a crash on 64bit.
> 
> Signed-off-by: Clemens Noss <cnoss@gmx.de>
> ---
>  drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |    2 +-
>  drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    4 ++--
>  drivers/staging/brcm80211/brcmsmac/wlc_main.c  |    4 ++--
>  drivers/staging/brcm80211/include/bcmutils.h   |    6 +++---
>  drivers/staging/brcm80211/util/bcmutils.c      |    4 ++--
>  5 files changed, 10 insertions(+), 10 deletions(-)

> ....

> diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
> index 5b041a6..0d93bd6 100644
> --- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
> +++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
> @@ -1225,7 +1225,7 @@ void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
>  /*
>   * callback function that helps flushing ampdu packets from a priority queue
>   */
> -static bool cb_del_ampdu_pkt(void *p, int arg_a)
> +static bool cb_del_ampdu_pkt(void *p, void *arg_a)
>  {
>  	struct sk_buff *mpdu = (struct sk_buff *)p;
>  	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(mpdu);
Why don't you use the correct pointer type here instead of casting then
around and the parameter names are meaningless too.

static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, struct
cb_del_ampdu_pars *ampdu_pars)

The signature of dma_cb_fn_ampdu(void *txi, void *arg_a) should be
changed too.

> ...

Hauke
