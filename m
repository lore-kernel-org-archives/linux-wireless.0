Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55721 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaILGH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 02:07:59 -0400
Date: Fri, 12 Sep 2014 11:39:38 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "ath9k: Calculate sleep duration"
Message-ID: <20140912060936.GA20575@qca.qualcomm.com> (sfid-20140912_080803_728370_BC9C72C6)
References: <1410442548-15782-1-git-send-email-sujith@msujith.org>
 <20140911141338.GA21543@qca.qualcomm.com>
 <21521.45335.848659.125183@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <21521.45335.848659.125183@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2014 at 07:56:31PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > Some of the IOE customer using ath9k with power save enabled. IIRC the
> > expectation is that when the station is idle, it should wakeup on DTIM
> > beacon not for every beacons. Are you seeing frequest bmiss events on
> > higher beacon interval?
> 
> I don't think ath9k has ever been tested with longer sleep durations
> based on dtim period. We have always programmed the hardware to wake up
> for every beacon interval, using the TIM_TIMER interrupt. And since the
> TIM bit needs to be checked for every beacon, the sleep duration has
> to be the beacon interval.
> 
> Also, the bmiss threshold needs to be adjusted based on the sleep
> duration. We are hardcoding it currently in the driver using
> ATH_DEFAULT_BMISS_LIMIT. This will break, too.
> 
> Using dtim for PS needs more testing before it can be used,
> so we can have the original behavior for now.
> 
Sounds clear.

Acked-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
