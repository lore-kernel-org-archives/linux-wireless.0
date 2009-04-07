Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbZDGTKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:10:08 -0400
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090407162345.GC5758@tesla>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	 <1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	 <1239099071.22453.12.camel@johannes.local>  <20090407162345.GC5758@tesla>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 21:09:30 +0200
Message-Id: <1239131370.6199.0.camel@johannes.local> (sfid-20090407_211015_173380_8B068808)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 09:23 -0700, Luis R. Rodriguez wrote:

> > This patch is not sufficient -- you also need to modify
> > ieee80211_send_assoc. Otherwise we end up telling the AP that we support
> > HT40, but tuning the hardware to HT20.
> 
> Like this?
> 
>                 switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
>                 case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
>                         if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
>                                 cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>                                 cap &= ~IEEE80211_HT_CAP_SGI_40;
>                         }
>                         break;
>                 case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
>                         if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
>                                 cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>                                 cap &= ~IEEE80211_HT_CAP_SGI_40;
>                         }

Yeah, that looks ok.

johannes

