Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1IZJg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:36:28 -0400
Subject: Re: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316970415-23239-3-git-send-email-eliad@wizery.com> (sfid-20110925_190733_679283_5E6C4322)
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
	 <1316970415-23239-3-git-send-email-eliad@wizery.com>
	 (sfid-20110925_190733_679283_5E6C4322)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:36:26 +0200
Message-ID: <1317029786.4117.30.camel@jlt3.sipsolutions.net> (sfid-20110926_113631_496141_905B7B3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-25 at 20:06 +0300, Eliad Peller wrote:
> tx params should be configured per interface.
> Add ieee80211_vif param to the conf_tx callback,
> and update all the drivers that use this callback.
> 
> The following spatch was used:
> @rule1@
> struct ieee80211_ops ops;
> identifier conf_tx_op;
> @@
> 	ops.conf_tx = conf_tx_op;
> 
> @rule2@
> identifier rule1.conf_tx_op;
> identifier hw, queue, params;
> @@
> 	conf_tx_op (
> -		struct ieee80211_hw *hw,
> +		struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> 		u16 queue,
> 		const struct ieee80211_tx_queue_params *params) {...}

Nice :-)

Looks good to me. (all 3)

johannes


