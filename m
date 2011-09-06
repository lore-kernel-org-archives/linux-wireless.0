Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1IFTj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 15:39:57 -0400
Subject: Re: [PATCHv2 2/2] mac80211: Tear down BA session on BAR tx failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1313072262-25413-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110811_161758_327900_A241E512)
References: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
	 <1313072262-25413-2-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110811_161758_327900_A241E512)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 21:39:44 +0200
Message-ID: <1315337984.26306.1.camel@jlt3.sipsolutions.net> (sfid-20110906_214001_542112_8CAD1602)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +			/*
> +			 * BAR failed, let's tear down the BA session as a
> +			 * last resort as some STAs (Intel 5100 on Windows)
> +			 * can get stuck when the BA window isn't flushed
> +			 * correctly.
> +			 */
> +			bar = (struct ieee80211_bar *) skb->data;
> +			if (!(bar->control & IEEE80211_BAR_CTRL_MULTI_TID)) {
> +				tid = (bar->control &
> +				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
> +				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
> +				ieee80211_stop_tx_ba_session(&sta->sta, tid);

Meh. Please, everyone, run sparse:

net/mac80211/status.c:276:34: warning: restricted __le16 degrades to integer
net/mac80211/status.c:277:43: warning: restricted __le16 degrades to integer

johannes

