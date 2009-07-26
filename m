Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f198.google.com ([209.85.210.198]:64771 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZGZJsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 05:48:33 -0400
Received: by yxe36 with SMTP id 36so1609042yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2009 02:48:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248482853-17032-4-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
	<1248482853-17032-4-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 26 Jul 2009 02:48:13 -0700
Message-ID: <43e72e890907260248l68e03097m184a9ca750c04b40@mail.gmail.com>
Subject: Re: [PATCH] ath9k: cancel xmit poll work at stop() callback
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 5:47 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> We forgot to cancel this work at the stop() callback.
>

<-- snip -->

> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3eb3032..fff89cc 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2100,6 +2100,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>
>        mutex_lock(&sc->mutex);
>
> +       cancel_delayed_work_sync(&sc->tx_complete_work);
> +
>        if (ath9k_wiphy_started(sc)) {
>                mutex_unlock(&sc->mutex);
>                return; /* another wiphy still in use */

This is in the right place but I see we call it upon detach. That is a
wrong place for this stuff... as well as the other cancels. Due to
virtual stuff this is more involved. We'll have to clean this better.

   Luis
