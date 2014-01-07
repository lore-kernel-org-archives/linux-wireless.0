Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAGPdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:33:46 -0500
Message-ID: <1389108818.4645.11.camel@jlt4.sipsolutions.net> (sfid-20140107_163349_632230_FDD80E50)
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 07 Jan 2014 16:33:38 +0100
In-Reply-To: <20140106180150.GB5358@magnum.frso.rivierawaves.com> (sfid-20140106_190246_733254_0F1DE3AB)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
	 <874n67eabn.fsf@kamboji.qca.qualcomm.com>
	 <20140106180150.GB5358@magnum.frso.rivierawaves.com>
	 (sfid-20140106_190246_733254_0F1DE3AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 19:01 +0100, Karl Beldan wrote:

> +	if (vif->csa_active) {
> +		vp->csa_bcn_cnt++;

I don't see any readers of this variable?

> +		if (vp->csa_finished) {
> +			wiphy_debug(hw->wiphy,"%s extra CSA-beacon\n", __func__);
> +		} else if (ieee80211_csa_is_complete(vif)) {
> +			wiphy_debug(hw->wiphy,
> +				    "%s CSA complete after %d beacons\n",
> +				    __func__, vp->csa_bcn_cnt);

except for the debug, but is that really useful?

> +			ieee80211_csa_finish(vif);
> +			vp->csa_finished = true;

and if we remove the other debug we can also remove the csa_finished
variable, that seems reasonable to me since mac80211 would already warn
anyway, no?

johannes

