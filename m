Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53848 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab1KPHqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:46:37 -0500
Message-ID: <4EC36A56.70104@openwrt.org> (sfid-20111116_084640_207544_8B11C078)
Date: Wed, 16 Nov 2011 08:46:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-16 12:21 AM, Simon Wunderlich wrote:
> This patch adds support for NoAck per WMM Queue. The Unicast QoS
> Header is adapted accordingly for each outgoing frame.
> The support is turned on and off through nl80211 by extending
> the WMM TX Queue Parameters, but can be triggered separately.
> 
> I have tested this feature on ath9k as well as ath5k devices. There is
> an iw patch as well to make use of this feature.
> 
> It should apply well on the latest wireless-testing kernel.
> 
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> ---
>  include/linux/nl80211.h |    2 ++
>  include/net/cfg80211.h  |    7 +++++++
>  include/net/mac80211.h  |    2 ++
>  net/mac80211/cfg.c      |   21 +++++++++++++++++++++
>  net/mac80211/tx.c       |    5 +++++
>  net/mac80211/util.c     |    1 +
>  net/mac80211/wme.c      |    5 ++++-
>  net/wireless/nl80211.c  |   34 +++++++++++++++++++++++++++++-----
>  8 files changed, 71 insertions(+), 6 deletions(-)
> 
> @@ -832,6 +833,7 @@ struct ieee80211_txq_params {
>  	u16 cwmin;
>  	u16 cwmax;
>  	u8 aifs;
> +	bool noack;
>  };
>  
>  /* from net/wireless.h */
> @@ -1341,6 +1343,8 @@ struct cfg80211_gtk_rekey_data {
>   *
>   * @set_txq_params: Set TX queue parameters
>   *
> + * @set_txq_noack: Set TX queue NoAck Parameter
> + *
>   * @set_channel: Set channel for a given wireless interface. Some devices
>   *	may support multi-channel operation (by channel hopping) so cfg80211
>   *	doesn't verify much. Note, however, that the passed netdev may be
> @@ -1521,6 +1525,9 @@ struct cfg80211_ops {
>  	int	(*set_txq_params)(struct wiphy *wiphy, struct net_device *dev,
>  				  struct ieee80211_txq_params *params);
>  
> +	int	(*set_txq_noack)(struct wiphy *wiphy, struct net_device *dev,
> +				  struct ieee80211_txq_params *params);
> +
>  	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
>  			       struct ieee80211_channel *chan,
>  			       enum nl80211_channel_type channel_type);
Why add a separate cfg80211 op when you can just make use of the extra
parameter in the existing one?

- Felix
