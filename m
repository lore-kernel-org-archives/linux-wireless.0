Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47124 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGV5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 17:57:51 -0400
Message-ID: <53E3F65D.8080102@candelatech.com> (sfid-20140807_235755_862850_594B55B7)
Date: Thu, 07 Aug 2014 14:57:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Reporting firmware stats to ethtool
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
as ethtool stats, somewhat similar to how ath9k does it.

I notice that my user-space tool is reporting huge numbers because
the stats are reset to zero when firmware restarts, and so my tool
thinks the stats wrapped.

I can fix my tool easily enough, but I first wanted to see if
anyone had strong feelings about keeping the stats from resetting
to zero by storing history and calculating diffs in the driver.

I think my preference is to punt this to user-space, but if
someone feels otherwise, please let me know sooner than later.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

