Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39501 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2FDXtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 19:49:09 -0400
Received: by obbtb18 with SMTP id tb18so7898287obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2012 16:49:09 -0700 (PDT)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 4 Jun 2012 16:48:49 -0700
Message-ID: <CAPjQAd-rwDM=JzuZ=EaQEPc7MQKRinXXa4r0en_fNV0j6MH6_Q@mail.gmail.com> (sfid-20120605_014913_234528_9DA75A12)
Subject: Re: [PATCH] mac80211: The station fail average is not updated
 correctly since the IEEE80211_STAT_ACK flag is not set when using wmediumd
 with mac80211_hwsim. Set this flag when wmediumd indicates that the frame was
 successfully transmitted (eventuall
To: Qasim Javed <qasimj@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quasim,

On Mon, Jun 4, 2012 at 8:03 PM, Qasim Javed <qasimj@gmail.com> wrote:
> Signed-off-by: Qasim Javed <qasimj@gmail.com>

The fix looks correct but you will have to reformat the patch: it
looks like the commit log made it into the Subject line of your patch:

Subject: [PATCH] mac80211: The station fail average is not updated
correctly since the IEEE80211_STAT_ACK flag is not set when using
wmediumd with mac80211_hwsim. Set this flag when wmediumd indicates
that the frame was successfully transmitted (eventually).

You probably want:

```
Subject: [PATCH] mac80211_hwsim: Set IEEE80211_STAT_ACK when userspace
indicates the frame has been acknowledged.

The station fail average is not updated correctly since the
IEEE80211_STAT_ACK flag is not set when using wmediumd with
mac80211_hwsim. Set this flag when wmediumd indicates that the frame
was successfully transmitted (eventually).
```

Cheers,

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
> 1.7.8.2
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
