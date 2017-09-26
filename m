Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41038 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936757AbdIZJ54 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 05:57:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
References: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com>
Date: Tue, 26 Sep 2017 12:57:50 +0300
In-Reply-To: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 25 Sep 2017 18:51:49 +0530")
Message-ID: <87wp4l6au9.fsf@kamboji.qca.qualcomm.com> (sfid-20170926_115845_032923_1E9446F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Karun Eagalapati <karun256@gmail.com>
>
> We are disabling of interrupts from firmware in freeze handler.
> Also setting power management capability KEEP_MMC_POWER to make
> device wakeup for WoWLAN trigger.
> At restore, we observed a device reset on some platforms. Hence
> reloading of firmware and device initialization is performed.

With "reloading of firmware and device initialization" you mean calling
rsi_mac80211_detach()?

void rsi_mac80211_detach(struct rsi_hw *adapter)
{
	struct ieee80211_hw *hw = adapter->hw;
	enum nl80211_band band;

	if (hw) {
		ieee80211_stop_queues(hw);
		ieee80211_unregister_hw(hw);
		ieee80211_free_hw(hw);
	}

That looks like a quite heavy sledgehammer workaround to a resume
problem. Is it really the best way to handle this?

And even if that would be the right approach it needs to be properly
described in the commit log, a vague sentence in the end of a commit log
is not enough.

-- 
Kalle Valo
