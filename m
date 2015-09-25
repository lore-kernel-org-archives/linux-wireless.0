Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50644 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbIYXA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 19:00:57 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Can we ignore frames with invalid BSSID in IBSS mode?
Message-ID: <5605D228.7050609@candelatech.com> (sfid-20150926_010105_789618_F93D668E)
Date: Fri, 25 Sep 2015 16:00:56 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that ath10k ar988X hardware has a bug where the BSSID
for IBSS AMSDU frames is all zeros.  The 'main' 636 ath10k firmware
does not seem to use AMSDUs for IBSS, and when I enable it in my CT
firmware, then I see the breakage.  So, I suspect it is not
just a simple software/firmware bug.

If I simply ignore the bssid_match check in ieee80211_accept_frame,
then it seems everything runs fine.

So, I'm curious if anyone knows what sorts of bad things could happen
if the bssid_match check is ignored?  Maybe bcast/mcast frames could
be accepted when they shouldn't be in certain cases?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

