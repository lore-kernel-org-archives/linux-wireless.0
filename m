Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36785 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1GULoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 07:44:11 -0400
To: gregkh@suse.de
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: fix suspend and resume
References: <20110721113112.8044.26825.stgit@localhost6.localdomain6>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 21 Jul 2011 14:44:09 +0300
In-Reply-To: <20110721113112.8044.26825.stgit@localhost6.localdomain6> (Kalle Valo's message of "Thu\, 21 Jul 2011 14\:31\:15 +0300")
Message-ID: <87d3h3uad2.fsf@purkki.adurom.net> (sfid-20110721_134415_353220_058287E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

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

With ath6kl-cleanup we missed the 3.1 deadline for the wireless code
so the staging version of ath6kl will be still in 3.1. Because of this
I need to send few critical fixes for 3.1, this suspend fix being one
of them. There are might few others as well, but the patches are not
ready yet.

I'm doing the big mistake of sending new code and going for a trip the
next day and not have internet access for 10 days. If there are any
issues my collagues will jump in.

-- 
Kalle Valo
