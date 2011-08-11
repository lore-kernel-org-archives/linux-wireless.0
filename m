Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41622 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1HKIP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 04:15:57 -0400
Date: Thu, 11 Aug 2011 11:15:49 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix a crash in nl80211_send_station
Message-ID: <20110811081549.GA19378@jouni.qca.qualcomm.com> (sfid-20110811_101603_090008_5E98F173)
References: <1313024433-35053-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1313024433-35053-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 07:00:33PM -0600, Felix Fietkau wrote:
> mac80211 leaves sinfo->assoc_req_ies uninitialized, causing a random
> pointer memory access in nl80211_send_station.
> Instead of checking if the pointer is null, use sinfo->filled, like
> the rest of the fields.

Thanks! This was too easy a trap to fall into.. It looked obvious that
sinfo would be cleared before calls, but clearly not (well, it was
cleared in the driver that I used for testing this ;-). I'll see if an
additional patch could be added to make this less likely to happen
again.

-- 
Jouni Malinen                                            PGP id EFC895FA
