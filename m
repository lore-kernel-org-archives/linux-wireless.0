Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbaHHJGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:06:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>
Date: Fri, 8 Aug 2014 12:06:15 +0300
In-Reply-To: <53E3F65D.8080102@candelatech.com> (Ben Greear's message of "Thu,
	07 Aug 2014 14:57:49 -0700")
Message-ID: <87wqajz6yg.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_111409_650829_6B948421)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
> as ethtool stats, somewhat similar to how ath9k does it.
>
> I notice that my user-space tool is reporting huge numbers because
> the stats are reset to zero when firmware restarts, and so my tool
> thinks the stats wrapped.
>
> I can fix my tool easily enough, but I first wanted to see if
> anyone had strong feelings about keeping the stats from resetting
> to zero by storing history and calculating diffs in the driver.
>
> I think my preference is to punt this to user-space, but if
> someone feels otherwise, please let me know sooner than later.

I also prefer to have this in user space, but how does user space know
when the stats have been zeroed?

-- 
Kalle Valo
