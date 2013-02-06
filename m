Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3BFRf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:35:57 -0500
Message-ID: <1360172180.7910.55.camel@jlt4.sipsolutions.net> (sfid-20130206_183600_010391_37916DE6)
Subject: Re: [PATCHv8 3/3] nl80211: allow DFS in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 06 Feb 2013 18:36:20 +0100
In-Reply-To: <1359982200-2321-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359982200-2321-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:

> +	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
> +	if (err < 0)
> +		return -EINVAL;

return err; ?

> +	if (err) {
> +		radar_detect_width = BIT(params.chandef.width);
> +		params.radar_required = true;

It seems you should probably just squash this into patch 1 since you
already use it in mac80211 in patch 2 but only patch 3 makes it valid?
seems a bit odd

johannes

