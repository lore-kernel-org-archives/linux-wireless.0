Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45667 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0HDPy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 11:54:59 -0400
Received: by wyb39 with SMTP id 39so5650949wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 08:54:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4f999350050decc0901e6f23ae3f06d35bc3fbc0.1280077759.git.luto@mit.edu>
References: <4f999350050decc0901e6f23ae3f06d35bc3fbc0.1280077759.git.luto@mit.edu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 4 Aug 2010 11:54:37 -0400
Message-ID: <AANLkTik=s32LV5ZUpU5EUBCV6zKsuU5SHM+UD0iS1oyW@mail.gmail.com>
Subject: Re: [PATCH 2.6.35] iwlagn: Improve aggregation failure error messages
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Andy Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 25, 2010 at 1:14 PM, Andy Lutomirski <luto@mit.edu> wrote:
> 82ca9341763107615a15da6e59b9535d49eb91c3 added scary looking
> but harmless error messages.  Make them clearer and make the
> actual failure message show up with the same severity as the
> harmless one.
>
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>
> This is probably 2.6.35 material.  There is no functional regression
> here, but 2.6.34 worked pretty well and 2.6.35 *looks* like it's not
> working if you read the logs.
>
> There is no functional change in this patch.

Well, 2.6.35 has come and gone.  Want to take it for 2.6.36 (it was
submitted in time AFAICT)?

--Andy



>
> Thanks,
> Andy
>
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> index cf4a95b..f38ee24 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> @@ -300,8 +300,9 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
>                                      struct ieee80211_sta *sta)
>  {
>        int ret = -EAGAIN;
> +       u32 load = rs_tl_get_load(lq_data, tid);
>
> -       if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
> +       if (load > IWL_AGG_LOAD_THRESHOLD) {
>                IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
>                                sta->addr, tid);
>                ret = ieee80211_start_tx_ba_session(sta, tid);
> @@ -311,13 +312,15 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
>                         * this might be cause by reloading firmware
>                         * stop the tx ba session here
>                         */
> -                       IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
> +                       IWL_ERR(priv, "Fail start Tx agg on tid: %d\n",
>                                tid);
>                        ieee80211_stop_tx_ba_session(sta, tid,
>                                                WLAN_BACK_INITIATOR);
>                }
> -       } else
> -               IWL_ERR(priv, "Fail finding valid aggregation tid: %d\n", tid);
> +       } else {
> +               IWL_ERR(priv, "Aggregation not enabled for tid %d "
> +                       "because load = %u\n", tid, load);
> +       }
>        return ret;
>  }
>
> --
> 1.7.1.1
>
>
