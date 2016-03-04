Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20526 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752AbcCDIny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:43:54 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Reduce number of peers to support peer stats
 feature
Date: Fri, 4 Mar 2016 08:43:43 +0000
Message-ID: <87wppiy6o5.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094405_852919_1A11F52C)
References: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
In-Reply-To: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
	(akolli@qti.qualcomm.com's message of "Tue, 23 Feb 2016 12:19:57	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<akolli@qti.qualcomm.com> writes:

> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> To enable per peer stats feature we are reducing the number of peers.
> Firmware has introduced tx stats feature. We have memory limitation in
> firmware to add these additional bytes.
>
> These are the new variables introduced in the firmware.
> ========		=======================
> Variable	      	Bytes required/per rate
> ========		=======================
> TX success packets 	1
> TX failed packets	1
> Retry packets		1
> Success bytes		2
> TX failed bytes		2
> Retry bytes		2
> Tx duration		4
> Rate			1
> Bw and AMPDU flags	1
> Total			16 (because of allocation in word pattern)
>
> Firmware sends these tx_stats in pktlog.
> If we consider 4 feedbacks at a time, Frimware need about ~1K memory for coding
> and 8192 bytes required / per rate [ 4*16*128(peers)].
> To accommodate this firmware needs to reduce 10 peers.
>
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

Applied, thanks.

I add a note in the commit log that this fixes a crash with
firmware-5.bin_10.2.4.70.22-2.

-- 
Kalle Valo