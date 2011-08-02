Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1HBLdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 07:33:24 -0400
Received: by iyb12 with SMTP id 12so7974559iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 04:33:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110802112314.GA2688@redhat.com>
References: <20110802112314.GA2688@redhat.com>
Date: Tue, 2 Aug 2011 13:33:23 +0200
Message-ID: <CAOZOX0VkM93sL6y0+z_7amQ7pmbkn6D5goW2NEuJpezD2V6tcg@mail.gmail.com> (sfid-20110802_133327_637325_C269C389)
Subject: Re: [PATCH] rt2x00: fix usage of NULL queue
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 2, 2011 at 1:29 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We may call rt2x00queue_pause_queue(queue) with queue == NULL. Bug
> was introduced by commit 62fe778412b36791b7897cfa139342906fbbf07b
> "rt2x00: Fix stuck queue in tx failure case" .
>
> Cc: stable@kernel.org # 3.0+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 8efab39..4ccf238 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -113,7 +113,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>         * due to possible race conditions in mac80211.
>         */
>        if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
> -               goto exit_fail;
> +               goto exit_free_skb;
>
>        /*
>         * Use the ATIM queue if appropriate and present.
> @@ -127,7 +127,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>                ERROR(rt2x00dev,
>                      "Attempt to send packet over invalid queue %d.\n"
>                      "Please file bug report to %s.\n", qid, DRV_PROJECT);
> -               goto exit_fail;
> +               goto exit_free_skb;
>        }
>
>        /*
> @@ -159,6 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>
>  exit_fail:
>        rt2x00queue_pause_queue(queue);
> + exit_free_skb:
>        dev_kfree_skb_any(skb);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_tx);
> --
> 1.7.1
>
