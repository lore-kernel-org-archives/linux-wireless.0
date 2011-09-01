Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35520 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab1IASih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 14:38:37 -0400
Received: by qyk15 with SMTP id 15so292965qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 11:38:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314900067-85242-3-git-send-email-nbd@openwrt.org>
References: <1314900067-85242-1-git-send-email-nbd@openwrt.org>
 <1314900067-85242-2-git-send-email-nbd@openwrt.org> <1314900067-85242-3-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 1 Sep 2011 11:38:17 -0700
Message-ID: <CAB=NE6XWknM-8OWNtQjtnXHeA_j12rMm2_6-5bb+t34ghMBOMg@mail.gmail.com> (sfid-20110901_203842_254523_F4698630)
Subject: Re: [PATCH v12 3/5] ath9k: always call ath_reset from workqueue context
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 1, 2011 at 11:01 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 49b93c2..95bc459 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -581,8 +581,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>
>        rcu_read_unlock();
>
> -       if (needreset)
> -               ath_reset(sc, false);
> +       if (needreset) {
> +               sc->sc_flags |= SC_OP_HW_RESET;
> +               ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
> +       }
>  }

I see SC_OP_HW_RESET is set only here but not other callers that set
the reset work, why is that but not in other places?

I should also note that ieee80211_queue_work() may just return and not
queue the work in the suspend case where there is a bug in mac80211 or
the driver; in that case  SC_OP_HW_RESET would not be cleared but I
suspect upon resume we will clear it anyway.

If the goal is to check if the work is pending how about adding
ieee80211_work_pending() which uses work_pending() ?

  Luis
