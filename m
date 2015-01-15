Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36776 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbAOOa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 09:30:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	mathias.kretschmer@fokus.fraunhofer.de, stable@vger.kernel.org
Subject: Re: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
References: <1420822458-531-1-git-send-email-sw@simonwunderlich.de>
	<2179820.H2CYa3nAla@prime> <54B4F062.2090301@neratec.com>
	<3155015.RnApTRDnnO@prime>
Date: Thu, 15 Jan 2015 16:30:51 +0200
In-Reply-To: <3155015.RnApTRDnnO@prime> (Simon Wunderlich's message of "Tue,
	13 Jan 2015 12:04:36 +0100")
Message-ID: <87ppagnmjo.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_153105_564588_2DBAAD0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

>> I did not dig how the hw->conf.radar_enabled flag is set in monitor mode,
>> but if it is same as for master (i.e. set for DFS channels), then it would
>> be a better approach to prevent calling ath9k_dfs_process_phyerr()
>> altogether from ath9k_rx_skb_preprocess() if not set.
>
> Hm, you mean like - if radar_enabled then dfs_process, otherwise fft_process? 
> That would might be more elegant indeed ...
>
> The monitor mode does not have the radar flag enabled, 
> cfg80211_chandef_dfs_required() returns 0 in this case.

So are you going to send v2 or what's the plan? I didn't quite get the
conclusion from the discussion.

-- 
Kalle Valo
