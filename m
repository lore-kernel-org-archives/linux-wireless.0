Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14019 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbDUNqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 09:46:15 -0400
Date: Tue, 21 Apr 2015 19:15:56 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: clear radar_required while setting up sdata
Message-ID: <20150421134553.GA11206@qca.qualcomm.com> (sfid-20150421_154618_605808_9F4ADE10)
References: <1429623125-9484-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1429623125-9484-1-git-send-email-rmanohar@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2015 at 07:02:05PM +0530, Rajkumar Manoharan wrote:
> The commit "mac80211: don't defer scans in case of radar detection"
> drops scan requests when interface is running on radar channel.
> Once the AP interface is brought up on DFS channel,
> sdata->radar_required never be cleared on deinit path unless the
> interface is deleted. This is causing failures while restarting hostapd.
> 
Sorry for the noise. It is already taken care by

Author: Eliad Peller <eliad@wizery.com>
Date:   Sun Feb 8 12:36:07 2015 +0200

    mac80211: clear sdata->radar_required

-Rajkumar
