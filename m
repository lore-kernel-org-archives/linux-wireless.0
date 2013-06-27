Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3F0NJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:09:42 -0400
Message-ID: <1372338578.8160.7.camel@jlt4.sipsolutions.net> (sfid-20130627_150945_335919_ED8FE4E9)
Subject: Re: [PATCHv4 05/18] cfg80211/mac80211: get mandatory rates based on
 rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 15:09:38 +0200
In-Reply-To: <1372337064-19254-6-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-6-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

> -u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
> +u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
> +			      u32 rate_flags)

I'm not sure that's the right API here, rate_flags doesn't make all that
much sense when you want to specify the width, why not use the width you
added in patch 1?

johannes


