Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46878 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1JCLlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:41:16 -0400
Date: Mon, 3 Oct 2011 17:10:19 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: Fix htc_packet leak in
	ath6kl_htc_rx_process_packets()
Message-ID: <20111003114018.GB24335@vasanth-laptop> (sfid-20111003_134125_538423_8EF56A15)
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com> <4E899876.4060103@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E899876.4060103@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 03, 2011 at 02:11:50PM +0300, Kalle Valo wrote:
> On 09/29/2011 06:01 PM, Vasanthakumar Thiagarajan wrote:
> > Packet is not reclaimed when ath6kl_htc_rx_process_hdr() fails.
> > Fix this by deferring the packet deletion from comp_pktq till
> > ath6kl_htc_rx_process_hdr() returns success.
> 
> Does this fix a user visible bug? Or is this just something you found
> while doing code review?

This one is found in code review, it does not fix any visible bug.

Vasanth
