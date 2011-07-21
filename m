Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59635 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1GUNNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 09:13:34 -0400
To: gregkh@suse.de
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: fix suspend and resume
References: <20110721113112.8044.26825.stgit@localhost6.localdomain6>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 21 Jul 2011 16:13:32 +0300
In-Reply-To: <20110721113112.8044.26825.stgit@localhost6.localdomain6> (Kalle Valo's message of "Thu\, 21 Jul 2011 14\:31\:15 +0300")
Message-ID: <878vrru683.fsf@purkki.adurom.net> (sfid-20110721_151337_646133_29F05C51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> The current suspend code in ath6kl is not working properly. Most of the
> time during response there are sdio errors and sdio stack reloads the
> driver.
>
> I was pondering different options how to fix this and decided to take
> the simplest route. First remove all the existing suspend/resume code
> which was complicated and replace it with code which will leave
> the chip powered on but will put it to deep sleep state. Now suspend
> works much faster and realiably, the cost being that power consumption
> will increase a bit during suspend.

Please drop this patch. I missed a compiler warning:

drivers/staging/ath6kl/os/linux/cfg80211.c:1877: warning:
initialization from incompatible pointer type

-- 
Kalle Valo
