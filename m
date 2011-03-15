Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38300 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab1COSRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:17:09 -0400
Received: by iwn34 with SMTP id 34so827860iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 11:17:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300193550.5596.16.camel@jlt3.sipsolutions.net>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
 <1299831238.5082.185.camel@wwguy-huron> <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
 <1300063647.24333.7.camel@wwguy-ubuntu> <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
 <1300189917.5596.10.camel@jlt3.sipsolutions.net> <1300193550.5596.16.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 15 Mar 2011 11:16:49 -0700
Message-ID: <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com>
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I applied these two patches and reverted all my previous changes to
mac80211 (force window to be 64 frames) and to iwlwifi (use 64-frame
agg limit).

+ TCP performance goes up from ~60 to ~80 Mbps.
+ I see no more of these 100ms timeout "ieee80211 phy0: release an RX
reorder frame due to timeout on earlier frames (skipped=0)" messages
from the receiver's mac80211 stack.

Big improvements!

There's still something off about the window size: unlike with ath9k,
the receiver does continually print out warnings about advancing its
window. There's something very fishy here: for any given aggregation
session, the part of the sequence number space this happens is always
the same! Really weird. Here's a log from 3 agg sessions in a row,
just running simple TCP iperf:

[341221.679710] New seq exceeds buffering window: 283, 250
[341223.960270] New seq exceeds buffering window: 281, 249
<snip many similar lines>
[341237.880568] New seq exceeds buffering window: 282, 251
[341238.849064] New seq exceeds buffering window: 280, 249
[341238.849072] New seq exceeds buffering window: 281, 250
[341239.903488] New seq exceeds buffering window: 281, 250
[341241.468187] New seq exceeds buffering window: 290, 251
[341242.009078] New seq exceeds buffering window: 280, 249
[341242.009085] New seq exceeds buffering window: 281, 250

[341340.865528] New seq exceeds buffering window: 2794, 2763
[341340.865536] New seq exceeds buffering window: 2795, 2764
[341340.865542] New seq exceeds buffering window: 2796, 2765
[341340.865547] New seq exceeds buffering window: 2797, 2766
[341341.451867] New seq exceeds buffering window: 2795, 2764
<snip>
[341349.271337] New seq exceeds buffering window: 2797, 2766
[341350.290501] New seq exceeds buffering window: 2796, 2765
[341354.010402] New seq exceeds buffering window: 2795, 2764
[341356.055030] New seq exceeds buffering window: 2795, 2764
[341356.055037] New seq exceeds buffering window: 2797, 2765
[341358.444524] New seq exceeds buffering window: 2794, 2763
[341358.444547] New seq exceeds buffering window: 2797, 2766

This one is complete including agg start/stop.

[341398.950019] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra =
00:16:ea:c3:b3:8e tid = 0
[341401.790964] New seq exceeds buffering window: 2335, 2304
[341402.918351] New seq exceeds buffering window: 2334, 2303
[341402.918360] New seq exceeds buffering window: 2335, 2304
[341406.182184] New seq exceeds buffering window: 2336, 2305
[341407.730557] New seq exceeds buffering window: 2335, 2304
[341410.996986] New seq exceeds buffering window: 2333, 2302
[341410.996994] New seq exceeds buffering window: 2334, 2303
[341410.997000] New seq exceeds buffering window: 2335, 2304
[341410.997005] New seq exceeds buffering window: 2336, 2305
[341411.664894] New seq exceeds buffering window: 2333, 2302
[341411.664911] New seq exceeds buffering window: 2335, 2304
[341411.664917] New seq exceeds buffering window: 2336, 2305
[341412.696554] New seq exceeds buffering window: 2333, 2302
[341412.696562] New seq exceeds buffering window: 2334, 2303
[341412.696568] New seq exceeds buffering window: 2335, 2304
[341412.696574] New seq exceeds buffering window: 2336, 2305
[341414.828173] New seq exceeds buffering window: 2333, 2302
[341414.828192] New seq exceeds buffering window: 2335, 2304
[341415.849728] New seq exceeds buffering window: 2333, 2302
[341415.851536] New seq exceeds buffering window: 2335, 2304
[341415.851542] New seq exceeds buffering window: 2336, 2305
[341417.085491] New seq exceeds buffering window: 2334, 2303
[341422.440517] iwlagn 0000:03:00.0: iwlagn_tx_agg_stop on ra =
00:16:ea:c3:b3:8e tid = 0

Note that I didn't even remove modules/reassociate anything like that,
I just let agg sessions start and stop between iperf.

Any thoughts?

Dan

On Tue, Mar 15, 2011 at 5:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-03-15 at 12:51 +0100, Johannes Berg wrote:
>> On Mon, 2011-03-14 at 11:16 -0700, Daniel Halperin wrote:
>>
>> > BUT, it looks like when we set up aggregation, we set the scheduler to
>> > ALWAYS use the default maximum of 64 frames for both these parameters
>> > [2] when configuring the agg queue. This is probably why the scheduler
>> > is willing to send long batches and have many outstanding frames.  I
>> > bet that the fix is to make these parameters match the ones that come
>> > down from mac80211.  If I get time later, I will see if I can fix
>> > this.
>>
>> Yeah, you're absolutely right, the window size and frame limit should
>> both match the information about the aggregation session, and be limited
>> to what we and the peer would like to see.
>>
>> The bad thing is that we set up the queue when we get
>> IEEE80211_AMPDU_TX_START, but we only know the window size when we get
>> IEEE80211_AMPDU_TX_OPERATIONAL. However, I think we can change this
>> since the first TX to the queue will only happen after _OPERATIONAL. We
>> just need to refactor iwlagn_tx_agg_start() into the parts that can
>> fail, and the parts that don't.
>
> On top of the previous patch, does this work? Note that I haven't tested
> it at all yet, sorry.
>
> johannes
>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   47 +++++++++++++++++++-----------
>  drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++
>  drivers/net/wireless/iwlwifi/iwl-agn.h    |    3 +
>  drivers/net/wireless/iwlwifi/iwl-dev.h    |    1
>  4 files changed, 39 insertions(+), 16 deletions(-)
>
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c 2011-03-15 13:22:04.000000000 +0100
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c 2011-03-15 13:50:34.000000000 +0100
> @@ -222,13 +222,8 @@ void iwlagn_tx_queue_set_status(struct i
>                       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
>  }
>
> -static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
> -                                int tx_fifo, int sta_id, int tid, u16 ssn_idx)
> +static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id, int tid)
>  {
> -       unsigned long flags;
> -       u16 ra_tid;
> -       int ret;
> -
>        if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
>            (IWLAGN_FIRST_AMPDU_QUEUE +
>                priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
> @@ -240,12 +235,33 @@ static int iwlagn_txq_agg_enable(struct
>                return -EINVAL;
>        }
>
> -       ra_tid = BUILD_RAxTID(sta_id, tid);
> -
>        /* Modify device's station table to Tx this TID */
> -       ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
> -       if (ret)
> -               return ret;
> +       return iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
> +}
> +
> +void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
> +                               struct ieee80211_sta *sta,
> +                               int tid, int frame_limit)
> +{
> +       int sta_id, tx_fifo, txq_id, ssn_idx;
> +       u16 ra_tid;
> +       unsigned long flags;
> +       struct iwl_tid_data *tid_data;
> +
> +       sta_id = iwl_sta_id(sta);
> +       if (WARN_ON(sta_id == IWL_INVALID_STATION))
> +               return;
> +       if (WARN_ON(tid >= MAX_TID_COUNT))
> +               return;
> +
> +       spin_lock_irqsave(&priv->sta_lock, flags);
> +       tid_data = &priv->stations[sta_id].tid[tid];
> +       ssn_idx = SEQ_TO_SN(tid_data->seq_number);
> +       txq_id = tid_data->agg.txq_id;
> +       tx_fifo = tid_data->agg.tx_fifo;
> +       spin_unlock_irqrestore(&priv->sta_lock, flags);
> +
> +       ra_tid = BUILD_RAxTID(sta_id, tid);
>
>        spin_lock_irqsave(&priv->lock, flags);
>
> @@ -271,10 +287,10 @@ static int iwlagn_txq_agg_enable(struct
>        iwl_write_targ_mem(priv, priv->scd_base_addr +
>                        IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
>                        sizeof(u32),
> -                       ((SCD_WIN_SIZE <<
> +                       ((frame_limit <<
>                        IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
>                        IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
> -                       ((SCD_FRAME_LIMIT <<
> +                       ((frame_limit <<
>                        IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
>                        IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
>
> @@ -284,8 +300,6 @@ static int iwlagn_txq_agg_enable(struct
>        iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
>
>        spin_unlock_irqrestore(&priv->lock, flags);
> -
> -       return 0;
>  }
>
>  static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
> @@ -1034,10 +1048,11 @@ int iwlagn_tx_agg_start(struct iwl_priv
>        tid_data = &priv->stations[sta_id].tid[tid];
>        *ssn = SEQ_TO_SN(tid_data->seq_number);
>        tid_data->agg.txq_id = txq_id;
> +       tid_data->agg.tx_fifo = tx_fifo;
>        iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
>        spin_unlock_irqrestore(&priv->sta_lock, flags);
>
> -       ret = iwlagn_txq_agg_enable(priv, txq_id, tx_fifo, sta_id, tid, *ssn);
> +       ret = iwlagn_txq_agg_enable(priv, txq_id, sta_id, tid);
>        if (ret)
>                return ret;
>
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c    2011-03-15 13:21:53.000000000 +0100
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c    2011-03-15 13:47:49.000000000 +0100
> @@ -3344,6 +3344,10 @@ int iwlagn_mac_ampdu_action(struct ieee8
>                }
>                break;
>        case IEEE80211_AMPDU_TX_OPERATIONAL:
> +               buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
> +
> +               iwlagn_txq_agg_queue_setup(priv, sta, tid, buf_size);
> +
>                /*
>                 * If the limit is 0, then it wasn't initialised yet,
>                 * use the default. We can do that since we take the
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.h    2011-03-15 13:50:03.000000000 +0100
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.h    2011-03-15 13:50:24.000000000 +0100
> @@ -202,6 +202,9 @@ int iwlagn_tx_agg_start(struct iwl_priv
>                        struct ieee80211_sta *sta, u16 tid, u16 *ssn);
>  int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
>                       struct ieee80211_sta *sta, u16 tid);
> +void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
> +                               struct ieee80211_sta *sta,
> +                               int tid, int frame_limit);
>  int iwlagn_txq_check_empty(struct iwl_priv *priv,
>                           int sta_id, u8 tid, int txq_id);
>  void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h    2011-03-15 13:48:12.000000000 +0100
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h    2011-03-15 13:48:22.000000000 +0100
> @@ -417,6 +417,7 @@ struct iwl_ht_agg {
>  #define IWL_EMPTYING_HW_QUEUE_ADDBA 2
>  #define IWL_EMPTYING_HW_QUEUE_DELBA 3
>        u8 state;
> +       u8 tx_fifo;
>  };
>
>
>
>
>
