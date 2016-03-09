Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46563 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbcCIQax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 11:30:53 -0500
Date: Wed, 9 Mar 2016 22:00:38 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org, Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: Re: [RFC v1] mac80211: Add support for per station rx stats histogram
Message-ID: <20160309163038.GA9410@atheros-ThinkPad-T61> (sfid-20160309_173057_427159_1B5EB7DD)
References: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457424451.2283.2.camel@sipsolutions.net>
 <20160308094250.GA3685@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20160308094250.GA3685@atheros-ThinkPad-T61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am able to apply both your patches in my local tree(with very very
minimal conflict)
http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172

I had started studying(understand) your patch. Please
let me know if you have already added support for the same
in userspace as well, we like to use your changes and possibly
add any changes that addresses rx_stats histogram as well

I will keep you posted for any other queries/ clarification,
thanks !

-shafi

On Tue, Mar 08, 2016 at 03:12:50PM +0530, Mohammed Shafi Shajakhan wrote:
> Hi Johannes,
> 
> On Tue, Mar 08, 2016 at 09:07:31AM +0100, Johannes Berg wrote:
> > On Mon, 2016-03-07 at 21:53 +0530, Mohammed Shafi Shajakhan wrote:
> > > 
> > > +#define IEEE80211_HT_MCS_NUM		32
> > > +#define IEEE80211_VHT_MCS_NUM		10
> > > +#define IEEE80211_BW_NUM		4
> > > +#define IEEE80211_NSS_NUM		4
> > > +#define IEEE80211_GI_NUM		2
> > > +#define IEEE80211_RATE_TABLE_NUM	320
> > > +#define IEEE80211_LEGACY_RATE_NUM	12
> > 
> > > +#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
> > > +	u64 rx_legacy_pkt[IEEE80211_LEGACY_RATE_NUM];
> > > +	u64 rx_ht_pkt[IEEE80211_HT_MCS_NUM];
> > > +	u64 rx_vht_pkt[IEEE80211_VHT_MCS_NUM];
> > > +	u64 rx_bw_pkt[IEEE80211_BW_NUM];
> > > +	u64 rx_nss_pkt[IEEE80211_NSS_NUM];
> > > +	u64 rx_gi_pkt[IEEE80211_GI_NUM];
> > > +	u64 rx_rate_pkt[IEEE80211_RATE_TABLE_NUM];
> > > +	u64 rx_legacy_byte[IEEE80211_LEGACY_RATE_NUM];
> > > +	u64 rx_ht_byte[IEEE80211_HT_MCS_NUM];
> > > +	u64 rx_vht_byte[IEEE80211_VHT_MCS_NUM];
> > > +	u64 rx_bw_byte[IEEE80211_BW_NUM];
> > > +	u64 rx_nss_byte[IEEE80211_NSS_NUM];
> > > +	u64 rx_gi_byte[IEEE80211_GI_NUM];
> > > +	u64 rx_rate_byte[IEEE80211_RATE_TABLE_NUM];
> > > +#endif
> > 
> > Do you know how much data this is?!
> > 
> > Felix is going to kill both of us if I apply it.
> 
> [shafi] :-(
> 
> > 
> > Please look at reviving my rate-statistics patch and do the remaining
> > work in userspace:
> > 
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172
> >
> 
> [shafi] thank you, I will check this out.
> 
> regards,
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
