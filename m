Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51532 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763288AbXFGUaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:30:52 -0400
Date: Thu, 7 Jun 2007 22:30:58 +0200
From: Jiri Benc <jbenc@suse.cz>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070607223058.44122be4@griffin.suse.cz>
In-Reply-To: <20070606082210.GA28649@mail.intel.com>
References: <20070606082210.GA28649@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 6 Jun 2007 16:22:10 +0800, Zhu Yi wrote:
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -106,6 +106,52 @@ struct ieee80211_hdr {
>  } __attribute__ ((packed));
>  
>  
> +
> +#define IEEE80211_TSINFO_TYPE(a)	((a.short1 & 0x0001) >> 0)
> +#define IEEE80211_TSINFO_TSID(a)	((a.short1 & 0x001E) >> 1)
> +#define IEEE80211_TSINFO_DIR(a)		((a.short1 & 0x0060) >> 5)
> +#define IEEE80211_TSINFO_POLICY(a)	((a.short1 & 0x0180) >> 7)
> +#define IEEE80211_TSINFO_AGG(a)		((a.short1 & 0x0200) >> 9)
> +#define IEEE80211_TSINFO_APSD(a)	((a.short1 & 0x0400) >> 10)
> +#define IEEE80211_TSINFO_UP(a)		((a.short1 & 0x3800) >> 11)
> +#define IEEE80211_TSINFO_ACK(a)		((a.short1 & 0xC000) >> 14)
> +#define IEEE80211_TSINFO_SCHEDULE(a)	((a.byte3 & 0x01) >> 0)
> +
> +#define SET_TSINFO_TYPE(i, d)		(i.short1 |= (d << 0) & 0x0001)
> +#define SET_TSINFO_TSID(i, d)		(i.short1 |= (d << 1) & 0x001E)
> +#define SET_TSINFO_DIR(i, d)		(i.short1 |= (d << 5) & 0x0060)
> +#define SET_TSINFO_POLICY(i, d)		(i.short1 |= (d << 7) & 0x0180)
> +#define SET_TSINFO_AGG(i, d)		(i.short1 |= (d << 9) & 0x0200)
> +#define SET_TSINFO_APSD(i, d)		(i.short1 |= (d << 10) & 0x0400)
> +#define SET_TSINFO_UP(i, d)		(i.short1 |= (d << 11) & 0x3800)
> +#define SET_TSINFO_ACK(i, d)		(i.short1 |= (d << 14) & 0xC000)
> +#define SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)

Please add IEEE80211_ prefix here as well. For consistency and not
polluting a name space.

> [...]
> +enum ieee80211_tsinfo_psb {
> +	WLAN_TSINFO_PSB_LEGACY = 0,
> +	WLAN_TSINFO_PSB_APSD = 1,
> +};
> +
> +
> +/* WI-FI Alliance OUI Type and Subtype */
> +enum wifi_oui_type {
> +	WIFI_OUI_TYPE_WPA = 1,
> +	WIFI_OUI_TYPE_WMM = 2,
> +	WIFI_OUI_TYPE_WSC = 4,
> +	WIFI_OUI_TYPE_PSD = 6,
> +};
> +
> +enum wifi_oui_stype_wmm {
> +	WIFI_OUI_STYPE_WMM_INFO = 0,
> +	WIFI_OUI_STYPE_WMM_PARAM = 1,
> +	WIFI_OUI_STYPE_WMM_TSPEC = 2,
> +};

Please don't invent new useless prefixes. Also, a registered trademark
doesn't seem to be a good prefix.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
