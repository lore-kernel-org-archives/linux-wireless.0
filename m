Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25661 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaARJl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 04:41:59 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julien Massot <jmassot@aldebaran-robotics.com>
CC: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath6kl: Fix Tx credits management for ar6004 usb
References: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
Date: Sat, 18 Jan 2014 11:41:53 +0200
In-Reply-To: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
	(Julien Massot's message of "Mon, 6 Jan 2014 19:52:46 +0100")
Message-ID: <87sislocda.fsf@kamboji.qca.qualcomm.com> (sfid-20140118_104245_711750_80EBA7F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julien Massot <jmassot@aldebaran-robotics.com> writes:

> By stressing the communication with different stream, iperf, ping,
> and web browsing, the transmission is stuck after a while. (5-10 minutes)
>
> The driver doesn't update correctly the tx credit,
> and the transmission becomes very slow.
>
> The ping latency raise to 20 secs, and finally stop with
> "no buffer space available".
>
> The first patch fixes a babble error in Rx message:
> "ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:-75, len:1536 urb:0xffff8802010dad80".
>
> The second patch decreases the Rx read threshold to make sure we read
> the tx credit report as soon as possible.
>
> Julien Massot (2):
>   ath6kl: increase usb rx buffer size to 4096
>   ath6kl: set rx urb count threshold to 1

Thanks, both patches applied.

-- 
Kalle Valo
