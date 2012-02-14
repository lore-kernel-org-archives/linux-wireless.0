Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3503 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2BNCw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 21:52:56 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20281.52354.478076.479135@gargle.gargle.HOWL> (sfid-20120214_035259_937043_6BC481A2)
Date: Tue, 14 Feb 2012 08:22:50 +0530
To: Ben Greear <greearb@candelatech.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
In-Reply-To: <4F39BF5F.3030408@candelatech.com>
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
	<4F3947A1.2060103@candelatech.com>
	<20281.48485.409968.741657@gargle.gargle.HOWL>
	<4F39BF5F.3030408@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> What if there is some bug that causes the NIC to be in a
> state different than mac80211 thinks it is?  If you leave
> this in, then maybe someone will notice.

Well, if we are not operating in the channel that mac80211
tells us, then we are screwed in a major, non-obvious way. :)

> Ath9k is a tricky beast to debug, and I think you should
> not remove anything that is remotely useful to debugging
> unless removing it has a real benefit other than just
> decreasing lines of (conditionally compiled) code.

I am aware that you have rather unique requirements regarding ath9k,
which is why I left 'stations', 'xmit', etc.. untouched. :)

The only data points that have been removed are the current operating
channel parameters. And removing redundant code will make a difference
in memory-constrained environments like APs. (OpenWRT has DEBUGFS enabled
by default).

Sujith
