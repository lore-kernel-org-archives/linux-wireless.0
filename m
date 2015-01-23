Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35560 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbbAWKE5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:04:57 -0500
Message-ID: <1422007493.2728.26.camel@sipsolutions.net> (sfid-20150123_110505_096725_461510B9)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 11:04:53 +0100
In-Reply-To: <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150120_133649_881614_094229C9)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150120_133649_881614_094229C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +++ b/net/mac80211/util.c
> @@ -2317,6 +2317,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>  	return pos + sizeof(struct ieee80211_ht_operation);
>  }
>  
> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +				const struct cfg80211_chan_def *chandef)

I still think you should keep this a static function in ibss.c since
nobody else is going to use it soon - the only possible user is mesh
anyway I think.

johannes

