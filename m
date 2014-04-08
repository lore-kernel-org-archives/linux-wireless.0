Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61477 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHG60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:58:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFT 4/4] ath10k: improve tx flushing
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1396611464-5940-5-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Apr 2014 09:58:20 +0300
In-Reply-To: <1396611464-5940-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Apr 2014 13:37:44 +0200")
Message-ID: <87k3b0mho3.fsf@kamboji.qca.qualcomm.com> (sfid-20140408_085829_522845_C24E4B63)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Flushing was prone to timeouts when powersaving
> clients were involved that went missing while
> asleep. The common culprit was NullFunc frame
> being stuck in FW/HW queues.
>
> Introduce a two-pass flushing with WMI flush
> commands interleaved to force frame drops if
> necessary. This allows for a decreased flush
> timeout time and should get rid of some warnings.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

With this patch I see a new checkpatch warning:

drivers/net/wireless/ath/ath10k/mac.c:3785: WARNING: line over 80 characters

-- 
Kalle Valo
