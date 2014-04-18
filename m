Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:47602 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDRA4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 20:56:21 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz11so1659333veb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 17:56:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397484205-20905-2-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
	<1397484205-20905-2-git-send-email-antonio@meshcoding.com>
Date: Fri, 18 Apr 2014 08:56:20 +0800
Message-ID: <CAEFj987Hr4iUuHX-_nJN5AcHBLnAeJhhMX9UbqkGffTT+UQFLQ@mail.gmail.com> (sfid-20140418_025646_205538_3050D7EF)
Subject: Re: [B.A.T.M.A.N.] [PATCH 2/7] mac80211: add get_expected_throughput API
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Antonio

Do you know whether the calculation of expected throughput in minstrel
and minstrel_ht are both the same?

Any explanation on how the expected throughput is calculated?

---
Chun-Yeow

On Mon, Apr 14, 2014 at 10:03 PM, Antonio Quartulli
<antonio@meshcoding.com> wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
>
> Add get_expected_throughput() API to mac80211 so that each
> driver can implement its own version based on the RC
> algorithm they are using (might be using an HW RC algo).
> The API returns a value expressed in Mbps/100.
> This unit has been chosen because it is the same of the
> throughput returned by MinstrelHT.
>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  include/net/mac80211.h    |  4 ++++
>  net/mac80211/driver-ops.h | 13 +++++++++++++
>  net/mac80211/trace.h      | 32 ++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index a3044e1..0efe37c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2761,6 +2761,9 @@ enum ieee80211_roc_type {
>   *     information in bss_conf is set up and the beacon can be retrieved. A
>   *     channel context is bound before this is called.
>   * @leave_ibss: Leave the IBSS again.
> + *
> + * @get_expected_throughput: extract the expected throughput towards the
> + *     specified station. The returned value is expressed in Mbps/100.
>   */
>  struct ieee80211_ops {
>         void (*tx)(struct ieee80211_hw *hw,
> @@ -2954,6 +2957,7 @@ struct ieee80211_ops {
>
>         int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>         void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
> +       u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
>  };
>
>  /**
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 5331582..84ee6c2 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -1122,4 +1122,17 @@ static inline void drv_leave_ibss(struct ieee80211_local *local,
>         trace_drv_return_void(local);
>  }
>
> +static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
> +                                             struct ieee80211_sta *sta)
> +{
> +       u32 ret = 0;
> +
> +       trace_drv_get_expected_throughput(sta);
> +       if (local->ops->get_expected_throughput)
> +               ret = local->ops->get_expected_throughput(sta);
> +       trace_drv_return_u32(local, ret);
> +
> +       return ret;
> +}
> +
>  #endif /* __MAC80211_DRIVER_OPS */
> diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
> index a0b0aea..942f64b 100644
> --- a/net/mac80211/trace.h
> +++ b/net/mac80211/trace.h
> @@ -184,6 +184,20 @@ TRACE_EVENT(drv_return_bool,
>                   "true" : "false")
>  );
>
> +TRACE_EVENT(drv_return_u32,
> +       TP_PROTO(struct ieee80211_local *local, u32 ret),
> +       TP_ARGS(local, ret),
> +       TP_STRUCT__entry(
> +               LOCAL_ENTRY
> +               __field(u32, ret)
> +       ),
> +       TP_fast_assign(
> +               LOCAL_ASSIGN;
> +               __entry->ret = ret;
> +       ),
> +       TP_printk(LOCAL_PR_FMT " - %u", LOCAL_PR_ARG, __entry->ret)
> +);
> +
>  TRACE_EVENT(drv_return_u64,
>         TP_PROTO(struct ieee80211_local *local, u64 ret),
>         TP_ARGS(local, ret),
> @@ -1499,6 +1513,24 @@ DEFINE_EVENT(local_sdata_evt, drv_leave_ibss,
>         TP_ARGS(local, sdata)
>  );
>
> +TRACE_EVENT(drv_get_expected_throughput,
> +       TP_PROTO(struct ieee80211_sta *sta),
> +
> +       TP_ARGS(sta),
> +
> +       TP_STRUCT__entry(
> +               STA_ENTRY
> +       ),
> +
> +       TP_fast_assign(
> +               STA_ASSIGN;
> +       ),
> +
> +       TP_printk(
> +               STA_PR_FMT, STA_PR_ARG
> +       )
> +);
> +
>  /*
>   * Tracing for API calls that drivers call.
>   */
> --
> 1.8.3.2
>
