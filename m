Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58316 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1AJFjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 00:39:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 21:38:53 -0800
Date: Mon, 10 Jan 2011 11:08:35 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/2] ath9k:  Fix incorrect tx-hang detection logic.
Message-ID: <20110110053835.GB5656@vasanth-laptop>
References: <1294423259-8163-1-git-send-email-greearb@candelatech.com> <1294423259-8163-2-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1294423259-8163-2-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 11:30:59PM +0530, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It is not guaranteed that the ath_tx_complete_poll_work runs
> after some fixed duration because the channel-reset logic
> removes the work and then re-adds it to run immediately.
> Two channel-changes 1ms apart, with a transmit was being
> attempted, could thus incorrectly trigger a reset by
> the ath_tx_complete_poll_work method.

I don't think so. axq_tx_inprogress is reset in ath_draintxq().

Vasanth
