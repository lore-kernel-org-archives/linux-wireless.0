Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2GBPIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:08:09 -0400
Message-ID: <1341241685.19642.15.camel@jlt3.sipsolutions.net> (sfid-20120702_170814_137434_907B5A11)
Subject: Re: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 02 Jul 2012 17:08:05 +0200
In-Reply-To: <5202151.WBzXQarS2v@lx-vladimir>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341233662.19642.6.camel@jlt3.sipsolutions.net>
	 <1341233919.19642.7.camel@jlt3.sipsolutions.net>
	 <5202151.WBzXQarS2v@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 18:01 +0300, Vladimir Kondratiev wrote:

> So, now I'll focus on the last patch - bitrate calculation.
> 
> My plan is:
> 
> - add new element like NL80211_RATE_INFO_BITRATE_HT with u32 data
> - change nl80211_put_sta_rate() to fill both
>   NL80211_RATE_INFO_BITRATE (with u16 value)
>   and NL80211_RATE_INFO_BITRATE_HT (with u32 value)
> - when bitrate not fit into u16, put 0 for u16 value and fill only u32

I think you should leave out the BITRATE value completely, not fill it
with 0.

> This opens migration path for the drivers and user space tools to the
> new u32 representation without breaking existing code.

Other than that, yes, good plan.

johannes

