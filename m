Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35926 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752544AbdAFPQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 10:16:19 -0500
Subject: Re: [PATCH 2/9] rt2800: increase TX timeout
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
 <1483707918-31480-3-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ce1a213e-19fe-83fa-e037-a5fefa88284e@nbd.name> (sfid-20170106_161625_104102_F0DB08C5)
Date: Fri, 6 Jan 2017 16:15:40 +0100
MIME-Version: 1.0
In-Reply-To: <1483707918-31480-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-06 14:05, Stanislaw Gruszka wrote:
> When medium is busy or frames have to be resend, it takes time to send
> the frames and get TX status from hardware. For some really bad medium
> conditions it can take seconds. Patch change TX status timeout to give
> HW more time to provide it, however 500ms is not enough for bad
> conditions. In the future this timeout should be removed and replaced
> with proper watchdog mechanism.
> 
> Increase flush timeout accordingly as well.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
By the way, to make tx status reporting more robust, I would suggest
mapping tx fifo status to skb only for frames where
IEEE80211_TX_CTL_REQ_TX_STATUS is set. For all other frames, set PID=0
and return the status using ieee80211_tx_status_noskb.
I did the same in mt76 and it works quite well.

- Felix
