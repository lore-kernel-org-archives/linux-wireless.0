Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbeCNJvz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 05:51:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/3] mwifiex: fix incorrect ht capability problem
References: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
        <1520619326-14888-3-git-send-email-gbhat@marvell.com>
Date: Wed, 14 Mar 2018 11:51:49 +0200
In-Reply-To: <1520619326-14888-3-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Fri, 9 Mar 2018 23:45:25 +0530")
Message-ID: <877eqfyoga.fsf@purkki.adurom.net> (sfid-20180314_105202_235984_33C5B61B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> IEEE80211_CHAN_NO_HT40PLUS and IEEE80211_CHAN_NO_HT40PLUS channel
> flags tell if HT40 operation is allowed on a channel or not.
>
> This patch ensures ht_capability information is modified
> accordingly so that we don't end up creating a HT40 connection
> when it's not allowed for current regulatory domain.
>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

kbuild bot reported sparse warnings from this patch:

drivers/net/wireless/marvell/mwifiex/11n.c:358:65: sparse: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:360:65: sparse: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:366:65: sparse: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:368:65: sparse: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    right side has type int

Please submit a followup patch to fix those.

-- 
Kalle Valo
