Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3ABNgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:36:46 -0500
Message-ID: <1357133818.9839.24.camel@jlt4.sipsolutions.net> (sfid-20130102_143652_646673_EB47A123)
Subject: Re: [PATCHv5 2/8] cfg/mac80211: add dfs capability to
 cfg80211_reg_can_beacon()
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:36:58 +0100
In-Reply-To: <1355407113-27006-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:

>   * @chandef: the channel definition
> + * @dfs_capab: supported DFS bandwidth
>   *
>   * This function returns true if there is no secondary channel or the secondary
>   * channel(s) can be used for beaconing (i.e. is not a radar channel etc.)
>   */
>  bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> -			     struct cfg80211_chan_def *chandef);
> +			     struct cfg80211_chan_def *chandef,
> +			     enum nl80211_chan_width dfs_capab);

Hm how does that make sense? The chandef contains a width? It seems like
the check whether or not DFS is supported (should be a bitfield btw)
should be outside of this function?

johannes

