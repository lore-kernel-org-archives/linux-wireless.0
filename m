Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56430 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2EADVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 23:21:16 -0400
Date: Tue, 1 May 2012 08:51:57 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Madhan Jaganathan <madhanj@qca.qualcomm.com>,
	Kai Shi <kaishi@qca.qualcomm.com>
Subject: Re: [PATCH] Revert "ath9k_hw: Fix incorrect spur_freq_sd for AR9003"
Message-ID: <20120501032155.GA6755@vmraj-lnx.users.atheros.com> (sfid-20120501_052119_409140_A7E3EE34)
References: <1335594521-1963-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20120430182200.GC2560@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120430182200.GC2560@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2012 at 02:22:01PM -0400, John W. Linville wrote:
> On Sat, Apr 28, 2012 at 11:58:41AM +0530, Rajkumar Manoharan wrote:
> > This reverts commit a844adfd7bee4edc66d337de6c33b348e83552a8.
> > 
> > spur_freq_sd (for self-corr in AGC) is defined with respect to the
> > center of each 20MHz channel while spur_phase_delta (for self-corr
> > in Rx and spur data filter) is defined with respect to the center
> > of current RF channel.
> > 
> > So in short, we need to subtract spur_freq_sd (for self-corr in AGC)
> > by the offset between the center of primary20 and the center of RF
> > channel in SW. This offset could be +/10 MHz for dynamic 40.
> > 
> > Cc: Madhan Jaganathan <madhanj@qca.qualcomm.com>
> > Signed-off-by: Kai Shi <kaishi@qca.qualcomm.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> What actual bug is this causing?  Should this be applied to 3.4?
> 
The original commmit is causing low rate's sensitivity degrade in ht40
mode. Will send v2 patch with updated commit log. And yes it should be
applied to 3.4.

-Rajkumar
