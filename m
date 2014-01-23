Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaAWPrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:47:33 -0500
Message-ID: <1390492050.4142.26.camel@jlt4.sipsolutions.net> (sfid-20140123_164736_607289_4FC0A143)
Subject: Re: [PATCH] mac80211: add length check in
 ieee80211_is_robust_mgmt_frame()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
Date: Thu, 23 Jan 2014 16:47:30 +0100
In-Reply-To: <1390490901-31868-1-git-send-email-johannes@sipsolutions.net> (sfid-20140123_162842_786595_3E619620)
References: <1390490901-31868-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140123_162842_786595_3E619620)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 16:28 +0100, Johannes Berg wrote:

> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
> @@ -452,7 +452,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
>  			/* During testing, hdr was NULL */
>  			return false;

Btw, this code in the context makes no sense at all, the pointer being
checked is skb->data + some offset.

johannes

