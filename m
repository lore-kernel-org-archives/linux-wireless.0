Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49989 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaD1I5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 04:57:25 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so5142034wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 01:57:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140428082225.GA15459@jouni.qca.qualcomm.com>
References: <20140428082225.GA15459@jouni.qca.qualcomm.com>
Date: Mon, 28 Apr 2014 10:57:23 +0200
Message-ID: <CA+BoTQ=gP49PDuyYovQmc-jtFwKN6JDOToSsT20ssnJZGaqieQ@mail.gmail.com> (sfid-20140428_105729_808807_C3D44759)
Subject: Re: [PATCH 2/3] mac80211: Support dynamic AP mode channel width changes
From: Michal Kazior <michal.kazior@tieto.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2014 10:22, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> Implement the new cfg80211 capability to enable mac80211-based drivers
> to support for dynamic channel bandwidth changes (e.g., HT 20/40 MHz
> changes).
>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  net/mac80211/cfg.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index aaa59d7..1ce407a 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -3949,6 +3949,21 @@ static int ieee80211_set_qos_map(struct wiphy *wiphy,
>         return 0;
>  }
>
> +static int ieee80211_set_ap_channel(struct wiphy *wiphy,
> +                                   struct net_device *dev,
> +                                   struct cfg80211_chan_def *chandef)
> +{
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       int ret;
> +       u32 changed = 0;
> +

Shouldn't interface combinations be verified here? What if there was a
bandwidth upgrade (after a downgrade) but in the meantime a vif with a
to-be incompatible chandef was brought up? I think the existing usage
of ieee80211_vif_change_bandwidth() in ieee80211_config_bw() already
suffers from this problem or am I missing something?


> +       ret = ieee80211_vif_change_bandwidth(sdata, chandef, &changed);
> +       if (ret == 0)
> +               ieee80211_bss_info_change_notify(sdata, changed);
> +
> +       return ret;
> +}


Michał
