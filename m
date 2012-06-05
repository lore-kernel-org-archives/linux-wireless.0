Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36442 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2FEQjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 12:39:24 -0400
Received: by obbtb18 with SMTP id tb18so8968412obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 09:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338877544-12827-1-git-send-email-qasimj@gmail.com>
References: <1338877544-12827-1-git-send-email-qasimj@gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 5 Jun 2012 09:39:03 -0700
Message-ID: <CAPjQAd_BcCDQiGNMa3uP+dgTwLhBmFRERSR6uqp227JWAOZc0g@mail.gmail.com> (sfid-20120605_183940_430431_4D251685)
Subject: Re: [PATCH] mac80211_hwsim: Set IEEE80211_STAT_ACK flag when
 userspace indicates that the frame has been acknowledged.
To: Qasim Javed <qasimj@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 4, 2012 at 11:25 PM, Qasim Javed <qasimj@gmail.com> wrote:
> The station fail average is not updated correctly since the IEEE80211_STAT_ACK flag is not set when using wmediumd with mac80211_hwsim. Set this flag when wmediumd indicates that the frame was successfully transmitted (eventually).
>
> Signed-off-by: Qasim Javed <qasimj@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>

> ---
>  drivers/net/wireless/mac80211_hwsim.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 4c9336c..a0b7cfd 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1555,6 +1555,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
>                        hdr = (struct ieee80211_hdr *) skb->data;
>                        mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
>                }
> +               txi->flags |= IEEE80211_TX_STAT_ACK;
>        }
>        ieee80211_tx_status_irqsafe(data2->hw, skb);
>        return 0;
> --
> 1.7.1
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
