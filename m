Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39597 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYIPDaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 23:30:23 -0400
Date: Mon, 15 Sep 2008 20:30:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
Message-ID: <20080916033010.GF659@tesla> (sfid-20080916_053028_624728_D4A096C4)
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 08:17:53PM -0700, Luis Rodriguez wrote:
> Re-enable aggregation by addressing skb->cb overwrites
> after insertion into the qdisc. Aggregation was disabled
> after the new TX multiqueue changes were introduced. Instead
> of relying on the skb->cb we use a new skb->requeue flag
> and an internal mac80211 is_part_amdu().
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> I haven't tested this patch as its late and I should go home already.
> 
>  drivers/net/wireless/ath9k/main.c         |    2 +-
>  drivers/net/wireless/ath9k/xmit.c         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-4965.c   |    6 ++++--
>  drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 ++++--
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++++----
>  drivers/net/wireless/iwlwifi/iwl-tx.c     |    4 ++--
>  include/linux/skbuff.h                    |    4 ++++
>  include/net/mac80211.h                    |   15 ++++++++++++---
>  net/mac80211/main.c                       |    7 ++-----
>  net/mac80211/rx.c                         |    7 ++-----
>  net/mac80211/tx.c                         |    6 ++----
>  net/mac80211/wme.c                        |   19 ++++---------------
>  12 files changed, 42 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index c5107f2..878e45f 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1241,7 +1241,7 @@ static int ath_attach(u16 devid,
>         /* FIXME: Have to figure out proper hw init values later */
> 
>         hw->queues = 4;
> -       hw->ampdu_queues = 1;
> +       hw->ampdu_queues = 8;

Ignore this hunk ;) We just have to figure out why we are using a
tid for the AP after we assign our IP address. This is also why this
"ampdu queue" for aggregation is kind of ackward.

  Luis
