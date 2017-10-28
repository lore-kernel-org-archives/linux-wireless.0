Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdJ1PBQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 11:01:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 03/12] wil6210: refresh FW capabilities during interface up
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1508937247-11890-4-git-send-email-qca_merez@qca.qualcomm.com>
Date: Sat, 28 Oct 2017 18:01:12 +0300
In-Reply-To: <1508937247-11890-4-git-send-email-qca_merez@qca.qualcomm.com>
        (Maya Erez's message of "Wed, 25 Oct 2017 16:13:58 +0300")
Message-ID: <87o9ors4ef.fsf@purkki.adurom.net> (sfid-20171028_170120_467976_6A928AD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lior David <qca_liord@qca.qualcomm.com>
>
> FW capabilities are currently retrieved only during module
> initialization, but userspace can replace the firmware while
> interface is down, so refresh the FW capabilities when
> interface is up (after FW is loaded) to ensure driver
> functionality matches the loaded FW.

I think usually the firmware is loaded only once during probe() and I
think it's quite special that you retrieve it during interface up. Being
able to change the firmware version runtime like that can lead to
problems eventually, for example cfg80211 might not allow changing
already registered configuration etc.

-- 
Kalle Valo
