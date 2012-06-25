Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25634 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2FYLEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 07:04:44 -0400
Message-ID: <4FE845C5.90106@qca.qualcomm.com> (sfid-20120625_130448_308740_78FD3410)
Date: Mon, 25 Jun 2012 16:34:37 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>
Subject: Re: [PATCH v2 00/10] Add support for WOW in ath9k
References: <1340467194-16930-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1340467194-16930-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

please wait, will send a version v3 version for this, because of a bug 
that occured while rebasing to the latest wireless testing. if you had 
already applied, please let me know, i will send a proper fix for that.
thank you.


On Saturday 23 June 2012 09:29 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> Add support for hardware WoW in ath9k. Magic-packet,
> beacon loss triggers, deauth/disassoc patterns
> (a special case of user pattern) are tested with
> AR9485. User pattern needs a bit of
> investigation on parsing to appropriate 802.11 format.
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
>
> Mohammed Shafi Shajakhan (10):
>    ath9k_hw: Add register definitions for WoW support
>    ath9k: Add definitions and structures to support WoW
>    ath9k_hw: Add WoW hardware capability flags
>    ath9k_hw: advertise WoW support for capable chipsets
>    ath9k: advertise supported WoW flags to upper layer
>    ath9k_hw: INI changes for WoW for AR9002 chipsets
>    ath9k_hw: Add hardware code for WoW
>    ath: Add Wake-on-Wireless debug mask
>    ath9k: Add WoW related mac80211 callbacks
>    ath9k: do not disable hardware while wow is enabled
>
>   drivers/net/wireless/ath/ath.h                   |    2 +
>   drivers/net/wireless/ath/ath9k/Makefile          |    1 +
>   drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    5 +
>   drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   14 +
>   drivers/net/wireless/ath/ath9k/ath9k.h           |   28 ++
>   drivers/net/wireless/ath/ath9k/hw.c              |    8 +
>   drivers/net/wireless/ath/ath9k/hw.h              |   68 +++
>   drivers/net/wireless/ath/ath9k/init.c            |   17 +
>   drivers/net/wireless/ath/ath9k/main.c            |  389 +++++++++++++++
>   drivers/net/wireless/ath/ath9k/pci.c             |    3 +
>   drivers/net/wireless/ath/ath9k/reg.h             |  145 ++++++-
>   drivers/net/wireless/ath/ath9k/wow.c             |  560 ++++++++++++++++++++++
>   12 files changed, 1239 insertions(+), 1 deletions(-)
>   create mode 100644 drivers/net/wireless/ath/ath9k/wow.c
>


-- 
thanks,
shafi
