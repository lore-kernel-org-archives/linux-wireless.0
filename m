Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50475 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753168AbeGJM60 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 08:58:26 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCHv2] mac80211: add stop/start logic for software TXQs
In-Reply-To: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org>
References: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org>
Date: Tue, 10 Jul 2018 14:58:18 +0200
Message-ID: <87o9ffcknp.fsf@toke.dk> (sfid-20180710_145829_561983_5C35EC5A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 172aeae..d07f7f9 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -818,6 +818,7 @@ enum txq_info_flags {
>  	IEEE80211_TXQ_STOP,
>  	IEEE80211_TXQ_AMPDU,
>  	IEEE80211_TXQ_NO_AMSDU,
> +	IEEE80211_TXQ_PAUSED,
>  };

I think it would be a good idea to either rename the flags, or at least
add an explanation somewhere of the difference between a paused and a
stopped queue...

>  /**
> @@ -1226,6 +1227,7 @@ struct ieee80211_local {
>  
>  	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
>  	struct tasklet_struct tx_pending_tasklet;
> +	struct tasklet_struct wake_txqs_tasklet;

It's not quite clear to me why a tasklet is needed? Couldn't you just
call the ieee80211_wake_txqs() function at the same place where you
currently schedule the tasklet?

-Toke
