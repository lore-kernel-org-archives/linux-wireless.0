Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60840 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951AbaJXMBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 08:01:06 -0400
Message-ID: <1414152061.1934.2.camel@jlt4.sipsolutions.net> (sfid-20141024_140113_720083_F6E5056E)
Subject: Re: [PATCH v6] mac80211: minstrel_ht: add basic support for VHT
 rates <= 3SS@80MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Fri, 24 Oct 2014 14:01:01 +0200
In-Reply-To: <20141024114829.GA11675@magnum.frso.rivierawaves.com> (sfid-20141024_134856_913156_316219A8)
References: <1413812762-6605-5-git-send-email-karl.beldan@gmail.com>
	 <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
	 <20141024114829.GA11675@magnum.frso.rivierawaves.com>
	 (sfid-20141024_134856_913156_316219A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-24 at 13:48 +0200, Karl Beldan wrote:
> Hi,
> 
> On Tue, Oct 21, 2014 at 10:38:38AM +0200, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > @@ -1026,13 +1184,47 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
> >  		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
> >  			continue;
> >  
> > +		nss = minstrel_mcs_groups[i].streams;
> > +
> >  		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
> > -		if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
> > -		    minstrel_mcs_groups[i].streams > 1)
> > +		if (sta->smps_mode == IEEE80211_SMPS_STATIC && nss > 1)
> > +			continue;
> > +
> > +		/* HT rate */
> > +		if (gflags & IEEE80211_TX_RC_MCS) {
> > +#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
> > +			if (minstrel_vht_only)
> > +				continue;
> > +#endif
> 
> When reformatting for 80chars I introduced a pb, the test should be 
> 'if (use_vht && minstrel_vht_only)' instead.
> The consequence is VHT-unable devices with
> CONFIG_MAC80211_RC_MINSTREL_VHT set won't have HT rates enabled.
> Johannes can you squash it in or should I send you a patch ?

I'm not sure I'm following, please send a patch, and I may decide to
fold that.

johannes

