Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45865 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbcDZLya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 07:54:30 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 4/4] ath10k: update bss channel survey information
Date: Tue, 26 Apr 2016 11:53:57 +0000
Message-ID: <87r3dsy4a4.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_135433_951053_6A56D096)
References: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1461303992-9913-4-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1461303992-9913-4-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 22 Apr 2016 11:16:32 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> During hw scan, firmware sends two channel information events (pre-
> complete, complete) to host for each channel change. The snap shot of cycle
> counters (rx_clear and total) between these two events are given for
> survey dump. In order to get latest survey statistics of all channels, a
> scan request has to be issued. In general, an AP DUT is brought up, it
> won't leave BSS channel except few cases like overlapping bss or radar
> detection. So survey statistics of bss channel is always referring to
> older data that are collected before starting AP (either ACS/OBSS scan).
>
> To collect latest survey information from target, firmware provides WMI
> interface to read cycle counters from hardware. For each survey dump
> request, BSS channel cycle counters are read and cleared in hardware.
> This makes sure that behavior is in align with ath9k survey report.
> So survey dump always gives snap shot of cycle counters b/w two survey
> requests.
>
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

This patch adds new sparse warnings:

drivers/net/wireless/ath/ath10k/wmi.c:4824:33: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:4824:33:    expected int [signed] freq
drivers/net/wireless/ath/ath10k/wmi.c:4824:33:    got restricted __le32 [usertype] freq
drivers/net/wireless/ath/ath10k/wmi.c:4833:27: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:4833:27:    expected signed char [signed] [usertype] [explicitly-signed] noise
drivers/net/wireless/ath/ath10k/wmi.c:4833:27:    got restricted __le32 [usertype] noise_floor

-- 
Kalle Valo