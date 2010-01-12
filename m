Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:56009 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0ALJhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 04:37:35 -0500
Date: Tue, 12 Jan 2010 10:37:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211: fix queue selection for data frames on monitor interfaces
Message-ID: <20100112093733.GA2548@mail.wantstofly.org>
References: <4B4ABB54.7030600@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B4ABB54.7030600@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 11, 2010 at 06:47:00AM +0100, Felix Fietkau wrote:

> When ieee80211_monitor_select_queue encounters data frames, it selects
> the WMM AC based on skb->priority and assumes that skb->priority
> contains a valid 802.1d tag. However this assumption is incorrect, since
> ieee80211_select_queue has not been called at this point.
> If skb->priority > 7, an array overrun occurs, which could lead to
> invalid values, resulting in crashes in the tx path.

What you describe here was already reported and fixed:

	http://marc.info/?l=linux-wireless&m=126287290723244&w=2
	http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=045cfb71a3901005bf6dcedae98cecb3360a0bfc

Your commit message could at least acknowledge this.  I.e. write
that the existing fix doesn't handle QoS data frames in the optimal
way, and then mention this:

> Fix this by setting skb->priority based on the 802.11 header for QoS
> frames and using the default AC for all non-QoS frames.
