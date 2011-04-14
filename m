Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35541 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1DNJQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 05:16:08 -0400
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: Check for queued frames before entering power save.
References: <1302070271-8343-1-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 14 Apr 2011 12:16:02 +0300
In-Reply-To: <1302070271-8343-1-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Wed\, 6 Apr 2011 11\:41\:10 +0530")
Message-ID: <878vvdjir1.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> In a highly noisy environment, the tx rate of the driver drops and
> the application slows down since it has not yet received ACKs for
> the frames already queued in the hardware. Since this ACK may take
> more than 100ms, stopping the dev queues for entering PS at this
> stage breaks applications, WMM test cases in my testing.
> If there are frames already pending in the tx queue, postponing the
> PS logic helps to avoid redundant queue stops. When power save is
> enabled by default and in a noisy environment, this API certainly
> helps in improving the average throughput.

I saw that John merged this already. But is this really the only way
to fix the problem? The driver API is getting quite complex already
and if we start adding new callbacks for each new problem it will get
even more complex.

I'm hoping that we could fix this somehow inside mac80211 and not
involve drivers. Do you have any tx and txstatus timestamps when this
happes? Or a sniffer capture?

-- 
Kalle Valo
