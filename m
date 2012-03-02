Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab2CBXVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:21:08 -0500
Subject: Re: [PATCHv5 1/2] mac80211_hwsim:  Add tsf to beacons, probe
 responses and radiotap header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330726027-30354-1-git-send-email-javier@cozybit.com> (sfid-20120302_230752_883430_F670115F)
References: <1330726027-30354-1-git-send-email-javier@cozybit.com>
	 (sfid-20120302_230752_883430_F670115F)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Mar 2012 00:21:04 +0100
Message-ID: <1330730464.3865.2.camel@jlt3.sipsolutions.net> (sfid-20120303_002112_376111_2E74AF5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) skb->data;
> +	struct mac80211_hwsim_data *data = hw->priv;
> +
> +	if (ieee80211_is_beacon(mgmt->frame_control) ||
> +				ieee80211_is_probe_resp(mgmt->frame_control))
> +		mgmt->u.beacon.timestamp = __mac80211_hwsim_get_tsf(data);

In light of the recent discussion ... John will have to point out to you
that the right style is

if (ieee80211...() ||
    ieee80211...()) {
}


:-)

johannes

