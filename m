Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8494 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab2FGGQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 02:16:14 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20432.18148.937220.807081@gargle.gargle.HOWL> (sfid-20120607_081618_136458_11E106E0)
Date: Thu, 7 Jun 2012 11:45:00 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: [PATCH] mac80211: ratelimit few aggregated messages
In-Reply-To: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> ratelimit few aggregation related messages, these messages
> floods the log when aggregation is disabled in the AP(for some
> wifi testcases) and we run traffic between STA and AP.
> mac80211 gives up after 15 addba requests, but
> ieee80211_start_tx_ba_session will be repeatedly called
> by drivers rate control tx_status callback. These net_dbg_ratelimited
> messages will be visible only when dynamic debug is enabled for
> mac80211 module.

I think the drivers need to be fixed. For ath9k, we probably need
an intermediate state to track whether an ADDBA request is pending.

Sujith
