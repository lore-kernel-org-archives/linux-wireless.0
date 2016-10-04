Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbcJDRgc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 13:36:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v8] Add new mac80211 driver mwlwifi.
References: <fdef0b5d3b744af8be48680e56ae9fb1@SC-EXCH02.marvell.com>
Date: Tue, 04 Oct 2016 20:36:27 +0300
In-Reply-To: <fdef0b5d3b744af8be48680e56ae9fb1@SC-EXCH02.marvell.com> (David
        Lin's message of "Tue, 28 Jun 2016 01:43:36 +0000")
Message-ID: <87shsc10f8.fsf@purkki.adurom.net> (sfid-20161004_193637_765816_BECE22E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

> PATCH v8 changes since PATCH v7:
>
> - Used scnprintf() to replace sprintf() for debugfs output messages to avoid
> overwriting buffer boundary.
> - Used mutex to replace spinlock for the protection of firmware command.
> - Used NL80211_BAND_XXXX instead of IEEE80211_BAND_XXXX (in order to work with
> updated mac80211).
> - Used usleep_range() instead of mdelay().
> - Modified the code to work with new mac80211 API ampdu_action() and get peer
> AMSDU information from parameters of this function instead of peeking ADDBA
> related packets.
> - Removed BA stream if traffic is not heavy.
> - Removed version information.
> - Added DFS, WPS, WDS and thermal function.
> - Changed length of mac vht_mpdu from 7991 to 3895.

I did a diff against v7 and you are not really making this easy:

 drivers/net/wireless/marvell/mwlwifi/Makefile   |    3 +-
 drivers/net/wireless/marvell/mwlwifi/debugfs.c  |  591 ++++++++++++++----
 drivers/net/wireless/marvell/mwlwifi/debugfs.h  |    8 +-
 drivers/net/wireless/marvell/mwlwifi/dev.h      |   85 ++-
 drivers/net/wireless/marvell/mwlwifi/fwcmd.c    |  750 ++++++++++++++++-------
 drivers/net/wireless/marvell/mwlwifi/fwcmd.h    |   24 +-
 drivers/net/wireless/marvell/mwlwifi/fwdl.c     |   43 +-
 drivers/net/wireless/marvell/mwlwifi/fwdl.h     |    8 +-
 drivers/net/wireless/marvell/mwlwifi/hostcmd.h  |  109 +++-
 drivers/net/wireless/marvell/mwlwifi/isr.c      |   90 ++-
 drivers/net/wireless/marvell/mwlwifi/isr.h      |    9 +-
 drivers/net/wireless/marvell/mwlwifi/mac80211.c |   74 ++-
 drivers/net/wireless/marvell/mwlwifi/main.c     |  270 ++++----
 drivers/net/wireless/marvell/mwlwifi/rx.c       |  149 +----
 drivers/net/wireless/marvell/mwlwifi/rx.h       |    8 +-
 drivers/net/wireless/marvell/mwlwifi/sysadpt.h  |   18 +-
 drivers/net/wireless/marvell/mwlwifi/thermal.c  |  182 ++++++
 drivers/net/wireless/marvell/mwlwifi/thermal.h  |   40 ++
 drivers/net/wireless/marvell/mwlwifi/tx.c       |  145 +++--
 drivers/net/wireless/marvell/mwlwifi/tx.h       |    9 +-
 20 files changed, 1799 insertions(+), 816 deletions(-)

You do understand that making so drastic changes during the driver
review is very counterproductive and demotivating for the reviewers?
Before I start looking this again I want to have an assurance that you
have frozen the driver and are not adding new features. I do not want
waste my time again just going circles.

You can continue adding new features but do that as separate patches and
submit them after the driver is applied to wireless-drivers-next.

-- 
Kalle Valo
