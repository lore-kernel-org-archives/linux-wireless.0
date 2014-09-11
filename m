Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58393 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaIKOMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 10:12:21 -0400
Date: Thu, 11 Sep 2014 19:43:40 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "ath9k: Calculate sleep duration"
Message-ID: <20140911141338.GA21543@qca.qualcomm.com> (sfid-20140911_161231_578989_D74C1CFF)
References: <1410442548-15782-1-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1410442548-15782-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2014 at 07:05:48PM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> This reverts commit 09ebb810927a110e4c354beb20308830d108a54b.
> 
> ath9k_hw_set_sta_beacon_timers() configures AR_TIM_PERIOD with
> the beacon interval. Before this commit, the sleepduration was
> never greater than the beacon interval. But now, the behavior
> has changed. For example, with an AP that uses a beacon interval of 100:
> 
> ath: phy9: next beacon 61128704
> ath: phy9: beacon period 204800
> ath: phy9: DTIM period 204800
> 
> If the sleepduration is calculated based on the listen time, then
> the bmiss threshold should also be changed since the HW would
> be in sleep state for a longer time, but that is not done currently.
> 
> To avoid configuring a higher beacon interval based on the sleepduration,
> revert to the original behavior. Power consumption is not a
> problem since PS is disabled in ath9k anyway.
>
Some of the IOE customer using ath9k with power save enabled. IIRC the
expectation is that when the station is idle, it should wakeup on DTIM
beacon not for every beacons. Are you seeing frequest bmiss events on
higher beacon interval?

-Rajkumar
