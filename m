Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXMZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 07:25:45 -0500
Message-ID: <1393244741.4190.10.camel@jlt4.sipsolutions.net> (sfid-20140224_132548_202348_CF67EA2A)
Subject: Re: [PATCH v1 2/6] mac80211: move flag
 IEEE80211_TX_CTL_FIRST_FRAGMENT into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Mon, 24 Feb 2014 13:25:41 +0100
In-Reply-To: <1393164527-13800-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:
> Flag IEEE80211_TX_CTL_MORE_FRAMES is only used within the tx path while
> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
> from info->flags structure into the info->control.flags and renames it to
> IEEE80211_TX_CTRL_FIRST_FRAGMENT. Define new IEEE80211_TX_TEMPORARY_CTRL_FLAGS
> to clear all temporary flags that are shifted to info->control.flags.

Similar to before... this can't be right, you have to assume
info->control.flags is cleared when you get status data, which is in
fact a problem in the first patch already, but here the clearing of
"temporary" flags is quite wrong.

At least temporary flags don't suffer from the 'getting lost' problem as
in the first patch.

I'll also note that this flag is treated wrongly in software retry
scenarios anyway, but it won't really matter I guess.

johannes

