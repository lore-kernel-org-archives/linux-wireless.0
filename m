Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935563AbdEXI1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 04:27:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v3 10/11] rsi: Add new firmware loading method
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494928877-27168-11-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 24 May 2017 11:27:37 +0300
In-Reply-To: <1494928877-27168-11-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Tue, 16 May 2017 15:31:16 +0530")
Message-ID: <87bmqi4q2u.fsf@purkki.adurom.net> (sfid-20170524_103846_518009_59E6479D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> The older firmware loading method has been deprecated and not in use
> for any chipets. New method is introduced which works based on soft
> boot loader. In this method, complete RAM image and FLASH image are
> present in the flash. Before loading the functional firmware, host
> issues boot loader commands to verify whether firmware to load is
> different from the current functional firmware. If not, firmware
> upgrade progresses and boot loader will switch to the new functional
> firmware.
>
> "rs9113_wlan_qspi.rps" is the firmware filename used in this patch.

I don't know if you saw the discussion with the wil6210 firmware, but
the linux-firmware maintainers prefer to have a subdirectory for
firmware files. I'm planning to apply this series now, but you can send
a followup patch ASAP which changes the rsi driver to use a subdirectory
for the firmware files?

Normally these kind of breaks in user space interface are not allowed,
and instead the requirement is that the driver has a transition period
from the old firmware interface to the new one. But I'm making an
exception here as, to my knowledge, the upstream rsi driver is not that
widely used and I want to get the driver development going on again.

-- 
Kalle Valo
