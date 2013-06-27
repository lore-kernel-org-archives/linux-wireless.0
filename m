Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3F0M7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:59:04 -0400
Message-ID: <1372337940.8160.3.camel@jlt4.sipsolutions.net> (sfid-20130627_145920_360772_3708BD1F)
Subject: Re: [PATCHv4 02/18] mac80211/rc80211: add chandef to rate
 initialization
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 14:59:00 +0200
In-Reply-To: <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

>  static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
> +			  struct cfg80211_chan_def *chandef,

I'd argue you can remove the sband pointer now, since the band is known
from the chandef?

Also, I'm not sure why you'd need this in rate_update, it should be good
enough in rate_init, no?

johannes

