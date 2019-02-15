Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB08C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 19:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D877222D0
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 19:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpSxGPec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbfBOToY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:44:24 -0500
Received: from mail-qk1-f174.google.com ([209.85.222.174]:46337 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfBOToX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 14:44:23 -0500
Received: by mail-qk1-f174.google.com with SMTP id i5so6393089qkd.13
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 11:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ll5UBiqaKKLKWFpNWF+bANFk2AGNmR/EjvHI3XB3OCI=;
        b=DpSxGPecXovBa+0xv7xm3vFzPZ50Zk3xyklQ+o5pAW4jwJa99IJODZ+tQ5A6gWAra9
         kIquSGNVjpqt5cY3i96Mee+n1+w3ZaZTC30y9ceksg0iHKXiIvDvobGsS/juqn4Ce6At
         XBu8AEZy4qVql3xJZZqdybz5q2vFkefSm3oiaJ39SIque3I3Wf3FUXgnwIWOaHOzMnPa
         H4HPynD1FlZnXLoOWJX70wC8Z2rb7Y00shu3SSytP01Andoxq1GsKolazjgfXGs74cE0
         JVmKh59oKLJYPUHFHKh2qumwRKgdC2r1kGH0thoNu+DLNr98u7LXe/qZjhQxaHqDwgk8
         6U3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ll5UBiqaKKLKWFpNWF+bANFk2AGNmR/EjvHI3XB3OCI=;
        b=cQmi7Hr7pFJLIIBtdFX+4fFAd3xX30+ZZx3H0EZY7S5wje3vwkoqoWXxbRcjLDgQkU
         X9vGzRUfmobV8xoEfWh9Ag1maiPxd16GfhkRZNNrfnV10otM1orzB3eSFKdN2aNGD572
         pdDxTXJXzG0fftqUPlMd23LXe+9q/P7cFc1jCywdu+uOOR9wg6sGlfwEStJz4/ZBt1/5
         ilhUgwaNI1wJgD3atKF/ysB8oOUWpwC/lHWG7T6Vhp6HoFnQOwnpYu3UKI7Ul0/xOaJ1
         R+dLxQb0b45GqCSW9dKqGFi4bxrrP9m+46az7w32i21yQMtme5oE6lVwrQX+1WQ0ehyD
         C0Jg==
X-Gm-Message-State: AHQUAuZ8xTONRl+isNf9w3gSfiox1Ss/03FTZEB8eisHoAmTbP7ofiHr
        mNWMocpLmNqhry408v+JPtGSeOGkBeOZkiyVr5+/xw==
X-Google-Smtp-Source: AHgI3Ib74j4ErmhLVAZz8ic4A1h/nzej/aXaFxfRuG+qqRYZTSEIiLBIre1HrvNPBkYL9KR4Y1HAqM/2a2hcttnRCGs=
X-Received: by 2002:a37:34d2:: with SMTP id b201mr8597049qka.237.1550259861722;
 Fri, 15 Feb 2019 11:44:21 -0800 (PST)
MIME-Version: 1.0
References: <20190215170512.31512-1-toke@redhat.com>
In-Reply-To: <20190215170512.31512-1-toke@redhat.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 15 Feb 2019 11:44:07 -0800
Message-ID: <CAA93jw4cjJ=iT72P_rjQCLC5fP9Xt0=ugzWiwn5Y2QL7E0YJvQ@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [RFC/RFT] mac80211: Switch to a virtual
 time-based airtime scheduler
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 15, 2019 at 9:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This switches the airtime scheduler in mac80211 to use a virtual time-bas=
ed
> scheduler instead of the round-robin scheduler used before. This has a
> couple of advantages:
>
> - No need to sync up the round-robin scheduler in firmware/hardware with
>   the round-robin airtime scheduler.
>
> - If several stations are eligible for transmission we can schedule both =
of
>   them; no need to hard-block the scheduling rotation until the head of t=
he
>   queue has used up its quantum.

This sounds like this will support some concepts in 802.11ax much better?

Do we have any feedback from ax folk (any platform - qca, intel,
mediatek, broadcom) as to whether this will help?

> - The check of whether a station is eligible for transmission becomes
>   simpler (in ieee80211_txq_may_transmit()).
>
> The drawback is that scheduling becomes slightly more expensive, as we ne=
ed
> to maintain an rbtree of TXQs sorted by virtual time. This means that
> ieee80211_register_airtime() becomes O(logN) in the number of currently
> scheduled TXQs. However, hopefully this number rarely grows too big (it's
> only TXQs currently backlogged, not all associated stations), so it
> shouldn't be too big of an issue.

SGTM.

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> This is basically the idea I mentioned earlier for a different way to
> handle the airtime scheduling.
>
> I've tested it on ath9k, where it achieves the same fairness and
> weighing properties as the old scheduler. It would be good if you could
> test it on your ath10k setup, Rajkumar; and all of you please comment on
> whether you agree that this is better from an API point of view.
>
>  net/mac80211/debugfs.c     |  49 ++++++++-
>  net/mac80211/debugfs_sta.c |  16 +--
>  net/mac80211/ieee80211_i.h |  15 ++-
>  net/mac80211/main.c        |   2 +-
>  net/mac80211/sta_info.c    |  19 +++-
>  net/mac80211/sta_info.h    |   3 +-
>  net/mac80211/tx.c          | 217 ++++++++++++++++++++++++-------------
>  7 files changed, 225 insertions(+), 96 deletions(-)
>
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index 343ad0a915e4..93b9ed2f9451 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -150,6 +150,47 @@ static const struct file_operations aqm_ops =3D {
>         .llseek =3D default_llseek,
>  };
>
> +static ssize_t airtime_read(struct file *file,
> +                           char __user *user_buf,
> +                           size_t count,
> +                           loff_t *ppos)
> +{
> +       struct ieee80211_local *local =3D file->private_data;
> +       char buf[200];
> +       u64 v_t[IEEE80211_NUM_ACS];
> +       u64 wt[IEEE80211_NUM_ACS];
> +       int len =3D 0, ac;
> +
> +       for (ac =3D 0; ac < IEEE80211_NUM_ACS; ac++) {
> +               spin_lock_bh(&local->active_txq_lock[ac]);
> +               v_t[ac] =3D local->airtime_v_t[ac];
> +               wt[ac] =3D local->airtime_weight_sum[ac];
> +               spin_unlock_bh(&local->active_txq_lock[ac]);
> +       }
> +       len =3D scnprintf(buf, sizeof(buf),
> +                       "\tVO         VI         BE         BK\n"
> +                       "Virt-t\t%-10llu %-10llu %-10llu %-10llu\n"
> +                       "Weight\t%-10llu %-10llu %-10llu %-10llu\n",
> +                       v_t[0],
> +                       v_t[1],
> +                       v_t[2],
> +                       v_t[3],
> +                       wt[0],
> +                       wt[1],
> +                       wt[2],
> +                       wt[3]);
> +
> +       return simple_read_from_buffer(user_buf, count, ppos,
> +                                      buf, len);
> +}
> +
> +static const struct file_operations airtime_ops =3D {
> +       .read =3D airtime_read,
> +       .open =3D simple_open,
> +       .llseek =3D default_llseek,
> +};
> +
> +
>  #ifdef CONFIG_PM
>  static ssize_t reset_write(struct file *file, const char __user *user_bu=
f,
>                            size_t count, loff_t *ppos)
> @@ -384,8 +425,12 @@ void debugfs_hw_add(struct ieee80211_local *local)
>         if (local->ops->wake_tx_queue)
>                 DEBUGFS_ADD_MODE(aqm, 0600);
>
> -       debugfs_create_u16("airtime_flags", 0600,
> -                          phyd, &local->airtime_flags);
> +       if (wiphy_ext_feature_isset(local->hw.wiphy,
> +                                   NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)=
) {
> +               DEBUGFS_ADD_MODE(airtime, 0600);
> +               debugfs_create_u16("airtime_flags", 0600,
> +                                  phyd, &local->airtime_flags);
> +       }
>
>         statsd =3D debugfs_create_dir("statistics", phyd);
>
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 3aa618dcc58e..80028da27b98 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -203,7 +203,7 @@ static ssize_t sta_airtime_read(struct file *file, ch=
ar __user *userbuf,
>         size_t bufsz =3D 200;
>         char *buf =3D kzalloc(bufsz, GFP_KERNEL), *p =3D buf;
>         u64 rx_airtime =3D 0, tx_airtime =3D 0;
> -       s64 deficit[IEEE80211_NUM_ACS];
> +       u64 v_t[IEEE80211_NUM_ACS];
>         ssize_t rv;
>         int ac;
>
> @@ -214,20 +214,20 @@ static ssize_t sta_airtime_read(struct file *file, =
char __user *userbuf,
>                 spin_lock_bh(&local->active_txq_lock[ac]);
>                 rx_airtime +=3D sta->airtime[ac].rx_airtime;
>                 tx_airtime +=3D sta->airtime[ac].tx_airtime;
> -               deficit[ac] =3D sta->airtime[ac].deficit;
> +               v_t[ac] =3D sta->airtime[ac].v_t;
>                 spin_unlock_bh(&local->active_txq_lock[ac]);
>         }
>
>         p +=3D scnprintf(p, bufsz + buf - p,
>                 "RX: %llu us\nTX: %llu us\nWeight: %u\n"
> -               "Deficit: VO: %lld us VI: %lld us BE: %lld us BK: %lld us=
\n",
> +               "Virt-T: VO: %lld us VI: %lld us BE: %lld us BK: %lld us\=
n",
>                 rx_airtime,
>                 tx_airtime,
>                 sta->airtime_weight,
> -               deficit[0],
> -               deficit[1],
> -               deficit[2],
> -               deficit[3]);
> +               v_t[0],
> +               v_t[1],
> +               v_t[2],
> +               v_t[3]);
>
>         rv =3D simple_read_from_buffer(userbuf, count, ppos, buf, p - buf=
);
>         kfree(buf);
> @@ -245,7 +245,7 @@ static ssize_t sta_airtime_write(struct file *file, c=
onst char __user *userbuf,
>                 spin_lock_bh(&local->active_txq_lock[ac]);
>                 sta->airtime[ac].rx_airtime =3D 0;
>                 sta->airtime[ac].tx_airtime =3D 0;
> -               sta->airtime[ac].deficit =3D sta->airtime_weight;
> +               sta->airtime[ac].v_t =3D 0;
>                 spin_unlock_bh(&local->active_txq_lock[ac]);
>         }
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 056b16bce3b0..994a70ee0ec0 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -840,8 +840,7 @@ struct txq_info {
>         struct codel_vars def_cvars;
>         struct codel_stats cstats;
>         struct sk_buff_head frags;
> -       struct list_head schedule_order;
> -       u16 schedule_round;
> +       struct rb_node schedule_order;
>         unsigned long flags;
>
>         /* keep last! */
> @@ -1135,8 +1134,10 @@ struct ieee80211_local {
>
>         /* protects active_txqs and txqi->schedule_order */
>         spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
> -       struct list_head active_txqs[IEEE80211_NUM_ACS];
> -       u16 schedule_round[IEEE80211_NUM_ACS];
> +       struct rb_root_cached active_txqs[IEEE80211_NUM_ACS];
> +       struct rb_node *schedule_pos[IEEE80211_NUM_ACS];
> +       u64 airtime_v_t[IEEE80211_NUM_ACS];
> +       u64 airtime_weight_sum[IEEE80211_NUM_ACS];
>
>         u16 airtime_flags;
>
> @@ -1765,6 +1766,12 @@ int ieee80211_tx_control_port(struct wiphy *wiphy,=
 struct net_device *dev,
>                               const u8 *buf, size_t len,
>                               const u8 *dest, __be16 proto, bool unencryp=
ted);
>
> +void ieee80211_resort_txq(struct ieee80211_hw *hw,
> +                         struct ieee80211_txq *txq);
> +void ieee80211_unschedule_txq(struct ieee80211_hw *hw,
> +                             struct ieee80211_txq *txq);
> +
> +
>  /* HT */
>  void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata=
,
>                                      struct ieee80211_sta_ht_cap *ht_cap)=
;
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 71005b6dfcd1..f207bc284921 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -666,7 +666,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t pri=
v_data_len,
>         spin_lock_init(&local->queue_stop_reason_lock);
>
>         for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
> -               INIT_LIST_HEAD(&local->active_txqs[i]);
> +               local->active_txqs[i] =3D RB_ROOT_CACHED;
>                 spin_lock_init(&local->active_txq_lock[i]);
>         }
>         local->airtime_flags =3D AIRTIME_USE_TX | AIRTIME_USE_RX;
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 11f058987a54..9d01fdd86e2d 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -389,7 +389,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_=
if_data *sdata,
>         for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
>                 skb_queue_head_init(&sta->ps_tx_buf[i]);
>                 skb_queue_head_init(&sta->tx_filtered[i]);
> -               sta->airtime[i].deficit =3D sta->airtime_weight;
>         }
>
>         for (i =3D 0; i < IEEE80211_NUM_TIDS; i++)
> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct ieee80=
211_sta *pubsta, u8 tid,
>  {
>         struct sta_info *sta =3D container_of(pubsta, struct sta_info, st=
a);
>         struct ieee80211_local *local =3D sta->sdata->local;
> +       struct ieee80211_txq *txq =3D sta->sta.txq[tid];
>         u8 ac =3D ieee80211_ac_from_tid(tid);
> -       u32 airtime =3D 0;
> +       u64 airtime =3D 0, weight_sum;
> +
> +       if (!txq)
> +               return;
>
>         if (sta->local->airtime_flags & AIRTIME_USE_TX)
>                 airtime +=3D tx_airtime;
>         if (sta->local->airtime_flags & AIRTIME_USE_RX)
>                 airtime +=3D rx_airtime;
>
> +       /* Weights scale so the unit weight is 256 */
> +       airtime <<=3D 8;
> +
>         spin_lock_bh(&local->active_txq_lock[ac]);
> +
>         sta->airtime[ac].tx_airtime +=3D tx_airtime;
>         sta->airtime[ac].rx_airtime +=3D rx_airtime;
> -       sta->airtime[ac].deficit -=3D airtime;
> +
> +       weight_sum =3D local->airtime_weight_sum[ac] ?: sta->airtime_weig=
ht;
> +
> +       local->airtime_v_t[ac] +=3D airtime / weight_sum;
> +       sta->airtime[ac].v_t +=3D airtime / sta->airtime_weight;
> +       ieee80211_resort_txq(&local->hw, txq);
> +
>         spin_unlock_bh(&local->active_txq_lock[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_sta_register_airtime);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 05647d835894..4b901a2a998e 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -130,11 +130,12 @@ enum ieee80211_agg_stop_reason {
>  /* Debugfs flags to enable/disable use of RX/TX airtime in scheduler */
>  #define AIRTIME_USE_TX         BIT(0)
>  #define AIRTIME_USE_RX         BIT(1)
> +#define AIRTIME_GRACE 500 /* usec of grace period before reset */
>
>  struct airtime_info {
>         u64 rx_airtime;
>         u64 tx_airtime;
> -       s64 deficit;
> +       u64 v_t;
>  };
>
>  struct sta_info;
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 61c7ea9de2cc..8e125df8ade0 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1449,7 +1449,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_dat=
a *sdata,
>         codel_vars_init(&txqi->def_cvars);
>         codel_stats_init(&txqi->cstats);
>         __skb_queue_head_init(&txqi->frags);
> -       INIT_LIST_HEAD(&txqi->schedule_order);
> +       RB_CLEAR_NODE(&txqi->schedule_order);
>
>         txqi->txq.vif =3D &sdata->vif;
>
> @@ -1493,9 +1493,7 @@ void ieee80211_txq_purge(struct ieee80211_local *lo=
cal,
>         ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
>         spin_unlock_bh(&fq->lock);
>
> -       spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
> -       list_del_init(&txqi->schedule_order);
> -       spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
> +       ieee80211_unschedule_txq(&local->hw, &txqi->txq);
>  }
>
>  void ieee80211_txq_set_params(struct ieee80211_local *local)
> @@ -3640,126 +3638,191 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
>  {
>         struct ieee80211_local *local =3D hw_to_local(hw);
> +       struct rb_node *node =3D local->schedule_pos[ac];
>         struct txq_info *txqi =3D NULL;
> +       bool first =3D false;
>
>         lockdep_assert_held(&local->active_txq_lock[ac]);
>
> - begin:
> -       txqi =3D list_first_entry_or_null(&local->active_txqs[ac],
> -                                       struct txq_info,
> -                                       schedule_order);
> -       if (!txqi)
> +       if (!node) {
> +               node =3D rb_first_cached(&local->active_txqs[ac]);
> +               first =3D true;
> +       } else
> +               node =3D rb_next(node);
> +
> +       if (!node)
>                 return NULL;
>
> +       txqi =3D container_of(node, struct txq_info, schedule_order);
> +
>         if (txqi->txq.sta) {
>                 struct sta_info *sta =3D container_of(txqi->txq.sta,
>                                                 struct sta_info, sta);
>
> -               if (sta->airtime[txqi->txq.ac].deficit < 0) {
> -                       sta->airtime[txqi->txq.ac].deficit +=3D
> -                               sta->airtime_weight;
> -                       list_move_tail(&txqi->schedule_order,
> -                                      &local->active_txqs[txqi->txq.ac])=
;
> -                       goto begin;
> +               if (sta->airtime[ac].v_t > local->airtime_v_t[ac]) {
> +                       if (first)
> +                               local->airtime_v_t[ac] =3D sta->airtime[a=
c].v_t;
> +                       else
> +                               return NULL;
>                 }
>         }
>
>
> -       if (txqi->schedule_round =3D=3D local->schedule_round[ac])
> -               return NULL;
> -
> -       list_del_init(&txqi->schedule_order);
> -       txqi->schedule_round =3D local->schedule_round[ac];
> +       local->schedule_pos[ac] =3D node;
>         return &txqi->txq;
>  }
>  EXPORT_SYMBOL(ieee80211_next_txq);
>
> -void ieee80211_return_txq(struct ieee80211_hw *hw,
> +static void __ieee80211_insert_txq(struct rb_root_cached *root,
> +                                  struct txq_info *txqi, u8 ac)
> +{
> +       struct rb_node **new =3D &root->rb_root.rb_node;
> +       struct rb_node *parent =3D NULL;
> +       struct txq_info *__txqi;
> +       bool leftmost =3D true;
> +
> +       while (*new) {
> +               parent =3D *new;
> +               __txqi =3D rb_entry(parent, struct txq_info, schedule_ord=
er);
> +
> +               if (!txqi->txq.sta) {
> +                       /* new txqi has no sta - insert to the left */
> +                       new =3D &parent->rb_left;
> +               } else if (!__txqi->txq.sta) {
> +                       /* existing txqi has no sta - insert to the right=
 */
> +                       new =3D &parent->rb_right;
> +                       leftmost =3D false;
> +               } else {
> +                       struct sta_info *old_sta =3D container_of(__txqi-=
>txq.sta,
> +                                                               struct st=
a_info,
> +                                                               sta);
> +                       struct sta_info *new_sta =3D container_of(txqi->t=
xq.sta,
> +                                                               struct st=
a_info,
> +                                                               sta);
> +
> +                       if (new_sta->airtime[ac].v_t <=3D old_sta->airtim=
e[ac].v_t)
> +                               new =3D &parent->rb_left;
> +                       else {
> +                               new =3D &parent->rb_right;
> +                               leftmost =3D false;
> +                       }
> +
> +               }
> +       }
> +
> +       rb_link_node(&txqi->schedule_order, parent, new);
> +       rb_insert_color_cached(&txqi->schedule_order, root, leftmost);
> +}
> +
> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +                           struct ieee80211_txq *txq)
> +       __acquires(txq_lock) __releases(txq_lock)
> +{
> +       struct ieee80211_local *local =3D hw_to_local(hw);
> +       struct txq_info *txqi =3D to_txq_info(txq);
> +       u8 ac =3D txq->ac;
> +
> +       spin_lock_bh(&local->active_txq_lock[ac]);
> +
> +       if (!RB_EMPTY_NODE(&txqi->schedule_order))
> +               goto out;
> +
> +       if (txq->sta) {
> +               struct sta_info *sta =3D container_of(txq->sta,
> +                                                   struct sta_info, sta)=
;
> +
> +               local->airtime_weight_sum[ac] +=3D sta->airtime_weight;
> +               if (local->airtime_v_t[ac] > AIRTIME_GRACE)
> +                       sta->airtime[ac].v_t =3D max(local->airtime_v_t[a=
c] - AIRTIME_GRACE,
> +                                                  sta->airtime[ac].v_t);
> +       }
> +
> +       __ieee80211_insert_txq(&local->active_txqs[ac], txqi, ac);
> +
> + out:
> +       spin_unlock_bh(&local->active_txq_lock[ac]);
> +}
> +EXPORT_SYMBOL(ieee80211_schedule_txq);
> +
> +void ieee80211_resort_txq(struct ieee80211_hw *hw,
>                           struct ieee80211_txq *txq)
>  {
>         struct ieee80211_local *local =3D hw_to_local(hw);
>         struct txq_info *txqi =3D to_txq_info(txq);
> +       u8 ac =3D txq->ac;
> +
> +       if (!RB_EMPTY_NODE(&txqi->schedule_order)) {
> +               rb_erase_cached(&txqi->schedule_order,
> +                               &local->active_txqs[ac]);
> +               RB_CLEAR_NODE(&txqi->schedule_order);
> +               __ieee80211_insert_txq(&local->active_txqs[ac], txqi, ac)=
;
> +       }
> +}
> +
> +static void __ieee80211_unschedule_txq(struct ieee80211_hw *hw,
> +                                      struct ieee80211_txq *txq)
> +{
> +       struct ieee80211_local *local =3D hw_to_local(hw);
> +       struct txq_info *txqi =3D to_txq_info(txq);
> +       u8 ac =3D txq->ac;
>
>         lockdep_assert_held(&local->active_txq_lock[txq->ac]);
>
> -       if (list_empty(&txqi->schedule_order) &&
> -           (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)=
) {
> -               /* If airtime accounting is active, always enqueue STAs a=
t the
> -                * head of the list to ensure that they only get moved to=
 the
> -                * back by the airtime DRR scheduler once they have a neg=
ative
> -                * deficit. A station that already has a negative deficit=
 will
> -                * get immediately moved to the back of the list on the n=
ext
> -                * call to ieee80211_next_txq().
> -                */
> -               if (txqi->txq.sta &&
> -                   wiphy_ext_feature_isset(local->hw.wiphy,
> -                                           NL80211_EXT_FEATURE_AIRTIME_F=
AIRNESS))
> -                       list_add(&txqi->schedule_order,
> -                                &local->active_txqs[txq->ac]);
> -               else
> -                       list_add_tail(&txqi->schedule_order,
> -                                     &local->active_txqs[txq->ac]);
> +       if (RB_EMPTY_NODE(&txqi->schedule_order))
> +               return;
> +
> +       if (txq->sta) {
> +               struct sta_info *sta =3D container_of(txq->sta,
> +                                                   struct sta_info, sta)=
;
> +
> +               local->airtime_weight_sum[ac] -=3D sta->airtime_weight;
>         }
> +
> +       rb_erase_cached(&txqi->schedule_order,
> +                       &local->active_txqs[txq->ac]);
> +       RB_CLEAR_NODE(&txqi->schedule_order);
>  }
> -EXPORT_SYMBOL(ieee80211_return_txq);
>
> -void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> -                           struct ieee80211_txq *txq)
> +void ieee80211_unschedule_txq(struct ieee80211_hw *hw,
> +                             struct ieee80211_txq *txq)
>         __acquires(txq_lock) __releases(txq_lock)
>  {
>         struct ieee80211_local *local =3D hw_to_local(hw);
>
>         spin_lock_bh(&local->active_txq_lock[txq->ac]);
> -       ieee80211_return_txq(hw, txq);
> +       __ieee80211_unschedule_txq(hw, txq);
>         spin_unlock_bh(&local->active_txq_lock[txq->ac]);
>  }
> -EXPORT_SYMBOL(ieee80211_schedule_txq);
> +
> +void ieee80211_return_txq(struct ieee80211_hw *hw,
> +                         struct ieee80211_txq *txq)
> +{
> +       struct ieee80211_local *local =3D hw_to_local(hw);
> +       struct txq_info *txqi =3D to_txq_info(txq);
> +
> +       lockdep_assert_held(&local->active_txq_lock[txq->ac]);
> +
> +       if (!RB_EMPTY_NODE(&txqi->schedule_order) &&
> +           (skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets)=
)
> +               __ieee80211_unschedule_txq(hw, txq);
> +}
> +EXPORT_SYMBOL(ieee80211_return_txq);
>
>  bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>                                 struct ieee80211_txq *txq)
>  {
>         struct ieee80211_local *local =3D hw_to_local(hw);
> -       struct txq_info *iter, *tmp, *txqi =3D to_txq_info(txq);
> +       struct txq_info *txqi =3D to_txq_info(txq);
>         struct sta_info *sta;
>         u8 ac =3D txq->ac;
>
>         lockdep_assert_held(&local->active_txq_lock[ac]);
>
>         if (!txqi->txq.sta)
> -               goto out;
> -
> -       if (list_empty(&txqi->schedule_order))
> -               goto out;
> -
> -       list_for_each_entry_safe(iter, tmp, &local->active_txqs[ac],
> -                                schedule_order) {
> -               if (iter =3D=3D txqi)
> -                       break;
> -
> -               if (!iter->txq.sta) {
> -                       list_move_tail(&iter->schedule_order,
> -                                      &local->active_txqs[ac]);
> -                       continue;
> -               }
> -               sta =3D container_of(iter->txq.sta, struct sta_info, sta)=
;
> -               if (sta->airtime[ac].deficit < 0)
> -                       sta->airtime[ac].deficit +=3D sta->airtime_weight=
;
> -               list_move_tail(&iter->schedule_order, &local->active_txqs=
[ac]);
> -       }
> +               return true;
>
>         sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
> -       if (sta->airtime[ac].deficit >=3D 0)
> -               goto out;
> -
> -       sta->airtime[ac].deficit +=3D sta->airtime_weight;
> -       list_move_tail(&txqi->schedule_order, &local->active_txqs[ac]);
> -
> -       return false;
> -out:
> -       if (!list_empty(&txqi->schedule_order))
> -               list_del_init(&txqi->schedule_order);
> -
> -       return true;
> +       return (sta->airtime[ac].v_t <=3D local->airtime_v_t[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_txq_may_transmit);
>
> @@ -3769,7 +3832,6 @@ void ieee80211_txq_schedule_start(struct ieee80211_=
hw *hw, u8 ac)
>         struct ieee80211_local *local =3D hw_to_local(hw);
>
>         spin_lock_bh(&local->active_txq_lock[ac]);
> -       local->schedule_round[ac]++;
>  }
>  EXPORT_SYMBOL(ieee80211_txq_schedule_start);
>
> @@ -3778,6 +3840,7 @@ void ieee80211_txq_schedule_end(struct ieee80211_hw=
 *hw, u8 ac)
>  {
>         struct ieee80211_local *local =3D hw_to_local(hw);
>
> +       local->schedule_pos[ac] =3D NULL;
>         spin_unlock_bh(&local->active_txq_lock[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_txq_schedule_end);
> --
> 2.20.1
>
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
