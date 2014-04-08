Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHGmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:42:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: refactor monitor code
References: <1396610305-5229-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Apr 2014 09:42:01 +0300
In-Reply-To: <1396610305-5229-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Apr 2014 13:18:25 +0200")
Message-ID: <87y4zgmifa.fsf@kamboji.qca.qualcomm.com> (sfid-20140408_084213_165371_D8CACBA4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was possible to create/delete/start/stop
> monitor vdev from a few places that were not
> exclusively protected against each other. This
> resulted in monitor vdev being stopped/removed by
> one call origin while another one was expecting it
> to continue running.
>
> For example if CAC was started and interface's
> promiscuous mode was toggled monitor vdev was
> removed from the driver meaning no radar would be
> detected. In additional a warning would be printed
> upon CAC completion complaining it tried to stop
> non-running monitor vdev.
>
> The patch simplifies monitor code by removing
> IEEE80211_HW_WANT_MONITOR_VIF (which wasn't really
> ever needed) and improves state tracking. It also
> unifies prints.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
