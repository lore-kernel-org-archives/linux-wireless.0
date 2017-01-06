Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935661AbdAFPiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 10:38:51 -0500
Date: Fri, 6 Jan 2017 16:34:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH 2/9] rt2800: increase TX timeout
Message-ID: <20170106153419.GA31614@redhat.com> (sfid-20170106_163901_584205_245F8D74)
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
 <1483707918-31480-3-git-send-email-sgruszka@redhat.com>
 <ce1a213e-19fe-83fa-e037-a5fefa88284e@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ce1a213e-19fe-83fa-e037-a5fefa88284e@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 06, 2017 at 04:15:40PM +0100, Felix Fietkau wrote:
> On 2017-01-06 14:05, Stanislaw Gruszka wrote:
> > When medium is busy or frames have to be resend, it takes time to send
> > the frames and get TX status from hardware. For some really bad medium
> > conditions it can take seconds. Patch change TX status timeout to give
> > HW more time to provide it, however 500ms is not enough for bad
> > conditions. In the future this timeout should be removed and replaced
> > with proper watchdog mechanism.
> > 
> > Increase flush timeout accordingly as well.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> By the way, to make tx status reporting more robust, I would suggest
> mapping tx fifo status to skb only for frames where
> IEEE80211_TX_CTL_REQ_TX_STATUS is set. For all other frames, set PID=0
> and return the status using ieee80211_tx_status_noskb.
> I did the same in mt76 and it works quite well.

Good idea, thanks!

Stanislaw
