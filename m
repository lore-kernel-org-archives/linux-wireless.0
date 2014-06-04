Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:62980 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaFDCGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 22:06:13 -0400
Received: by mail-la0-f45.google.com with SMTP id s18so2023341lam.32
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2014 19:06:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 3 Jun 2014 19:05:52 -0700
Message-ID: <CAB=NE6W=FubasHV6QsAO8Jrdhbh_xM1SmYqCScvRf8g0FY4GHw@mail.gmail.com> (sfid-20140604_040617_412509_34A453E6)
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	mhocko@suse.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 12:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -478,6 +478,19 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
>                        sta->sta.addr, sta->sta.aid, ac);
>                 if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
>                         purge_old_ps_buffers(tx->local);
> +
> +               /* sync with ieee80211_sta_ps_deliver_wakeup */
> +               spin_lock(&sta->ps_lock);
> +               /*
> +                * STA woke up the meantime and all the frames on ps_tx_buf have
> +                * been queued to pending queue. No reordering can happen, go
> +                * ahead and Tx the packet.
> +                */
> +               if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> +                       spin_unlock(&sta->ps_lock);
> +                       return TX_CONTINUE;
> +               }
> +
>                 if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
>                         struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
>                         ps_dbg(tx->sdata,

This fixes the race for the case where the API introduced via commit
af81858172cc but that code also *moved* code, the API added simply
added a new way to let driver to hit a trigger to send buffered
frames, are we sure that through mechanisms that don't use this API
this race doesn't exist? That is can we not race between
ieee80211_rx_h_sta_process() and ieee80211_tx_h_unicast_ps_buf()?

  Luis
