Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61248 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1HXOoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:44:23 -0400
Date: Wed, 24 Aug 2011 20:14:34 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
Message-ID: <20110824144433.GC25267@vasanth-laptop> (sfid-20110824_164426_860705_A3B55961)
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
 <20110824143039.GA25267@vasanth-laptop>
 <4E550BBA.1020800@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E550BBA.1020800@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 05:33:30PM +0300, Kalle Valo wrote:
> On 08/24/2011 05:30 PM, Vasanthakumar Thiagarajan wrote:
> > On Wed, Aug 24, 2011 at 07:55:34PM +0530, Vasanthakumar Thiagarajan wrote:
> >> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> >> ---
> >>  drivers/net/wireless/ath/ath6kl/Kconfig |    6 ++++++
> >>  drivers/net/wireless/ath/ath6kl/core.h  |    1 +
> >>  drivers/net/wireless/ath/ath6kl/debug.c |   13 +++++++++++++
> >>  drivers/net/wireless/ath/ath6kl/debug.h |    9 +++++++++
> >>  drivers/net/wireless/ath/ath6kl/init.c  |    6 ++++++
> >>  5 files changed, 35 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
> >> index 3d5f8be..ea9387b 100644
> >> --- a/drivers/net/wireless/ath/ath6kl/Kconfig
> >> +++ b/drivers/net/wireless/ath/ath6kl/Kconfig
> >> @@ -13,3 +13,9 @@ config ATH6KL_DEBUG
> >>  	depends on ATH6KL
> >>  	---help---
> >>  	  Enables debug support
> >> +config ATH6KL_DEBUGFS
> >> +	bool "ath6kl debugfs"
> >> +	depends on ATH6KL_DEBUG && DEBUG_FS
> > 
> > ATH6KL_DEBUGFS can be independent of ATH6KL_DEBUG. I'll send v2
> > fixing this.
> 
> Actually do we really need ATH6KL_DEBUGFS? I would think that if both
> ATH6KL_DEBUG and DEBUG_FS are enabled we should just enable debugfs code
> in ath6kl. I don't see the need to have separate kconfig option control
> that.

You are right. We can directly use CONFIG_DEBUG_FS to enable ath6kl
debugfs functionalities, also as I said, this does not need to
depend on ATH6KL_DEBUG. One purpose that I can think of introducing
a config option for debugfs is to reduce the size of the binary,
may be it is very insignificant.

Vasanth
