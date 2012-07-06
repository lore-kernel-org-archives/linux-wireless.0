Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49741 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab2GFTsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:48:30 -0400
Date: Fri, 6 Jul 2012 15:35:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	vadivel@qca.qualcomm.com, rhu@qca.qualcomm.com
Subject: Re: [PATCH v3 00/10] Add support for WOW in ath9k
Message-ID: <20120706193523.GB1879@tuxdriver.com> (sfid-20120706_214835_140785_F49F5F0E)
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there going to be a repost of this series?  It looked like Sujith
had a number of concerns.

On Mon, Jun 25, 2012 at 07:42:49PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Add support for hardware WoW in ath9k. Magic-packet,
> beacon loss triggers, deauth/disassoc patterns
> (a special case of user pattern) are tested with 
> AR9485. User pattern needs a bit of investigation
> on parsing to appropriate 802.11 format.
> we will do more rigorous testing and address bugs.
> Also we will quickly validate with chipsets like
> AR9462, AR9280, AR9285, AR9287 for any bugs.
> 
> Thanks a lot to Vadivel for providing me the hardware and
> inputs to test. Thanks to Rajkumar, Russell for
> their invaluable help. Thanks to Aeolous, Senthil and
> Sujith, Raja. Thanks a lot to Luis for providing the complete
> frame work for WoW in his initial wow patches.
> 
> Mohammed Shafi Shajakhan (10):
>   ath9k_hw: Add register definitions for WoW support
>   ath9k: Add definitions and structures to support WoW
>   ath9k_hw: Add WoW hardware capability flags
>   ath9k_hw: advertise WoW support for capable chipsets
>   ath9k: advertise supported WoW flags to upper layer
>   ath9k_hw: INI changes for WoW for AR9002 chipsets
>   ath9k_hw: Add hardware code for WoW
>   ath: Add Wake-on-Wireless debug mask
>   ath9k: Add WoW related mac80211 callbacks
>   ath9k: do not disable hardware while wow is enabled
> 
>  drivers/net/wireless/ath/ath.h                   |    2 +
>  drivers/net/wireless/ath/ath9k/Makefile          |    1 +
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    5 +
>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   14 +
>  drivers/net/wireless/ath/ath9k/ath9k.h           |   28 ++
>  drivers/net/wireless/ath/ath9k/hw.c              |    8 +
>  drivers/net/wireless/ath/ath9k/hw.h              |   68 +++
>  drivers/net/wireless/ath/ath9k/init.c            |   17 +
>  drivers/net/wireless/ath/ath9k/main.c            |  390 +++++++++++++++
>  drivers/net/wireless/ath/ath9k/pci.c             |    3 +
>  drivers/net/wireless/ath/ath9k/reg.h             |  145 ++++++-
>  drivers/net/wireless/ath/ath9k/wow.c             |  560 ++++++++++++++++++++++
>  12 files changed, 1240 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/wow.c
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
