Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51607 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab2CNCMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 22:12:49 -0400
Received: by ghrr11 with SMTP id r11so1305230ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 19:12:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331668045-16384-2-git-send-email-ashok@cozybit.com>
References: <1331668045-16384-1-git-send-email-ashok@cozybit.com>
	<1331668045-16384-2-git-send-email-ashok@cozybit.com>
Date: Tue, 13 Mar 2012 19:12:48 -0700
Message-ID: <CACcxo+oYpVKuN5W=B4wdQB+x1FBu5rE-43mNcgnZUkn=it5z_Q@mail.gmail.com> (sfid-20120314_031253_166278_EE6CDC58)
Subject: Re: [PATCH v2 2/3] cfg80211: Fill Toffset for each station
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, ashok@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore this patchset. Version 3 is coming

Thanks,
Ashok

On Tue, Mar 13, 2012 at 12:47 PM, Ashok Nagarajan <ashok@cozybit.com> wrote:
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v2:
> Report toffset to userspace only when RX_FLAG_MACTIME_MPDU is set (Johannes)
>
>  include/net/cfg80211.h |    6 +++++-
>  net/mac80211/cfg.c     |    4 ++++
>  2 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 69b7ad3..5daffad 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -520,6 +520,7 @@ struct station_parameters {
>  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
>  * @STATION_INFO_STA_FLAGS: @sta_flags filled
>  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
> + * @STATION_INFO_T_OFFSET: @t_offset filled
>  */
>  enum station_info_flags {
>        STATION_INFO_INACTIVE_TIME      = 1<<0,
> @@ -541,7 +542,8 @@ enum station_info_flags {
>        STATION_INFO_CONNECTED_TIME     = 1<<16,
>        STATION_INFO_ASSOC_REQ_IES      = 1<<17,
>        STATION_INFO_STA_FLAGS          = 1<<18,
> -       STATION_INFO_BEACON_LOSS_COUNT  = 1<<19
> +       STATION_INFO_BEACON_LOSS_COUNT  = 1<<19,
> +       STATION_INFO_T_OFFSET           = 1<<20,
>  };
>
>  /**
> @@ -640,6 +642,7 @@ struct sta_bss_parameters {
>  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
>  * @sta_flags: station flags mask & values
>  * @beacon_loss_count: Number of times beacon loss event has triggered.
> + * @t_offset: Time offset of the station relative to this host.
>  */
>  struct station_info {
>        u32 filled;
> @@ -668,6 +671,7 @@ struct station_info {
>        size_t assoc_req_ies_len;
>
>        u32 beacon_loss_count;
> +       s64 t_offset;
>
>        /*
>         * Note: Add a new enum station_info_flags value for each new field and
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 677d659..25e25d5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -412,6 +412,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>                sinfo->llid = le16_to_cpu(sta->llid);
>                sinfo->plid = le16_to_cpu(sta->plid);
>                sinfo->plink_state = sta->plink_state;
> +               if (sta->last_rx_rate_flag & RX_FLAG_MACTIME_MPDU) {
> +                       sinfo->filled |= STATION_INFO_T_OFFSET;
> +                       sinfo->t_offset = sta->t_offset;
> +               }
>  #endif
>        }
>
> --
> 1.7.5.4
>
