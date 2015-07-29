Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43400 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbbG2I0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 04:26:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: suppress 'failed to process fft' warning messages.
References: <1437490215-11214-1-git-send-email-kevin@darbyshire-bryant.me.uk>
Date: Wed, 29 Jul 2015 11:25:46 +0300
In-Reply-To: <1437490215-11214-1-git-send-email-kevin@darbyshire-bryant.me.uk>
	(Kevin Darbyshire-Bryant's message of "Tue, 21 Jul 2015 15:50:15
	+0100")
Message-ID: <87lhdz74l1.fsf@kamboji.qca.qualcomm.com> (sfid-20150729_102744_821900_78598590)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk> writes:

> When using DFS channels on Ath10k, kernel log has repeated warning message
> 'failed to process fft: -22' typically under medium/heavy traffic.
>
> This patch switches the warnings to driver debug (WMI events) mode only
> thus reducing log file noise.
>
> DFS and spectral scan share underlying HW mechanisms and enabling one
> (DFS) enables the other (spectral scan) as far as event reporting from
> firmware to driver is concerned. Spectral scan events take no part in
> processing of DFS radar pulses which are delivered as distinct events,
> so the fft (spectral event) warning is harmless and DFS interference
> detection/protection still occurs.
>
> Symptoms seen & fix tested in both debug & non-debug modes on TP-Link
> Archer C7 v2 platform.
>
> Signed-off-by: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>

Thanks, applied.

In the future please use v2, v3 to mark different versions of the patch
so that I can easily find the latest version:

https://www.kernel.org/doc/Documentation/SubmittingPatches

-- 
Kalle Valo
