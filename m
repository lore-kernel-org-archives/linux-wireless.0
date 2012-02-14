Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2BNBs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 20:48:28 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20281.48485.409968.741657@gargle.gargle.HOWL> (sfid-20120214_024831_735029_987FE7B1)
Date: Tue, 14 Feb 2012 07:18:21 +0530
To: Ben Greear <greearb@candelatech.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
In-Reply-To: <4F3947A1.2060103@candelatech.com>
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
	<4F3947A1.2060103@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> It is nice to be able to see what the driver/NIC thinks
> it is set to as well.  It is always possible that the
> stack and the NIC are out of sync for some reason.
> I'd rather those values be left in the debugfs unless
> there is a good reason for getting rid of them.

The 'wiphy' file is a remnant from the old virtual HW code.
To know the channel parameters of multiple, virtual PHYs, it
was useful. Since the operating parameters, channel type, HT
capabilites etc. are all exposed by mac80211's debugfs, we might
as well use that. Most of the other information - BSSID, RXfilter etc.
have been retained.

Sujith
