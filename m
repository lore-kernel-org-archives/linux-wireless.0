Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:33547 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYEXGRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 02:17:07 -0400
Date: Sat, 24 May 2008 09:16:28 +0300
From: Jouni Malinen <j@w1.fi>
To: Thomas Kunze <thommycheck@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: hostap oops
Message-ID: <20080524061628.GE4932@jm.kir.nu> (sfid-20080524_081731_328609_22AE1816)
References: <48374F39.40904@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48374F39.40904@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 01:11:53AM +0200, Thomas Kunze wrote:

> the hostap driver produces an oops at boot time for me. I use a prism2 compact flash card. 

Thanks for reporting this. Would there be any chance of getting the oops
message with function backtrace? I would like to know what exactly is
crashing and fix that instead of trying to hide the problem with the
patch you used. Which other devices are using the same interrupt line
(cat /proc/interrupts)?

> Its seems that this is because the driver receives irqs before it is ready to do so. 
> 
> I found a patch that solve the problem, but it looks more like a hack.

Yes, that change may resolve the issue for you, but it does not look
reasonable as a generic fix. prism2_interrupt() should not really claim
that it handled the interrupt if it did not since the interrupt could
have been for another device.

> Any suggestions how to solve this in a better way?

I think the better way would be to identify the location that causes the
oops and fix that area to handle being called at this early during
initialization or alternatively, reorder initialization to avoid having
to register the interrupt handler before having completed some
additional setup.

-- 
Jouni Malinen                                            PGP id EFC895FA
