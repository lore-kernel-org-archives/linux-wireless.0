Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1KXS0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:26:09 -0500
Subject: Re: [RFC v2 3/8] mac80211: tracking mesh peer link-specific power
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
In-Reply-To: <1321886416-12597-4-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154149_972027_446A5478)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 <1321886416-12597-4-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154149_972027_446A5478)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:26:06 +0100
Message-ID: <1322159166.5366.32.camel@jlt3.sipsolutions.net> (sfid-20111124_192613_864664_70C64A72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:
> peer_ps_mode field has been added to sta_info structure to represent
> peer's link-specific power mode for our station.
> 
> Peer's link-specific power mode is tracked from the Power Management
> field in the Frame Control field and the Mesh Power Save Level field
> in the QoS Control field at the end of a frame exchange sequence.
> 
> Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
> Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  include/linux/ieee80211.h |   11 ++++++++
>  net/mac80211/mesh.h       |    2 +
>  net/mac80211/rx.c         |   61 +++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/sta_info.h   |    2 +
>  4 files changed, 76 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 483fa46..44e9c0d 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -546,6 +546,17 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
>  	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
>  }
>  
> +/**
> + * ieee80211s_has_qos_pm - check Power Save Level in QoS control
> + * @qc - QoS control bytes in little-endian byteorder
> + */
> +
> +static inline int ieee80211s_has_qos_pm(__le16 qc)

bool

> +{
> +	return (qc & cpu_to_le16(
> +			IEEE80211_QOS_CTL_MESH_PS_LEVEL)) != 0;
> +}

and with bool there's no need for the != 0 part.
 
> +void ieee80211s_set_sta_ps_mode(struct sta_info *sta,
> +				enum nl80211_mesh_power_mode mode)

static?

>  static ieee80211_rx_result debug_noinline
>  ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
>  {
> @@ -1314,6 +1342,39 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>  	}
>  
>  	/*
> +	 * Test mesh power save level subfield of QoS control field (PSL)
> +	 * and Power Managment field of frame control (PW)
> +	 * +----+----+-----------------+
> +	 * | PM | PSL| Mesh Power Mode |
> +	 * +----+----+-----------------+
> +	 * | 0  |Rsrv|    Active       |
> +	 * +----+----+-----------------+
> +	 * | 1  | 0  |    Light        |
> +	 * +----+----+-----------------+
> +	 * | 1  | 1  |    Deep         |
> +	 * +----+----+-----------------+
> +	 */
> +	if (!ieee80211_has_morefrags(hdr->frame_control) &&
> +	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
> +	    ieee80211_vif_is_mesh(&rx->sdata->vif) &&
> +	    (ieee80211_is_data(hdr->frame_control) ||
> +	     ieee80211_is_nullfunc(hdr->frame_control))) {
> +		if (ieee80211_has_pm(hdr->frame_control)) {
> +			__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
> +			if (ieee80211s_has_qos_pm(*qc)) {

I don't think you guaranteed that it even has a QoS header.

johannes

