Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaLSOWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 09:22:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH 5/5] ath10k: implement support for ap beacon offloading
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
	<1418829711-19713-6-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 19 Dec 2014 16:22:18 +0200
In-Reply-To: <1418829711-19713-6-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 17 Dec 2014 16:21:51 +0100")
Message-ID: <87lhm3iusl.fsf@kamboji.qca.qualcomm.com> (sfid-20141219_152233_404639_CFA51110)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> New firmware revisions support beacon and probe
> response templates instead. This means SWBA events
> are no longer delivered for these firmware
> revisions.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	ret = ath10k_mac_setup_bcn_p2p_ie(arvif, bcn);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to setup p2p go bcn ie: %d\n", ret);
> +		kfree_skb(bcn);
> +		return ret;
> +	}
> +
> +	ath10k_mac_remove_vendor_ie(bcn, WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
> +				    offsetof(struct ieee80211_mgmt,
> +					     u.beacon.variable));

A comment would be nice why you are removing the P2P IE. I guess because
there's a different command to set that IE?
 
-- 
Kalle Valo
