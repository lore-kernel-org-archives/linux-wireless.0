Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38446 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1G0FU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 01:20:56 -0400
Date: Wed, 27 Jul 2011 10:49:50 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Brent Taylor <btaylor1@motorolasolutions.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: ATH6KL lockup during init
Message-ID: <20110727051949.GA19410@vasanth-laptop> (sfid-20110727_072059_675893_7288CF44)
References: <loom.20110726T174149-11@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <loom.20110726T174149-11@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 26, 2011 at 03:43:02PM +0000, Brent Taylor wrote:
> I’m a developer working with the Atheros AR6003 Wireless LAN chip.  I recently
> updated the Linux kernel on my custom board to 3.0.0 and pulled the latest
> snapshot of the ath6kl driver from
> http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary (as
> of 2011-07-25).  I’m also using the latest firmware images from
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ath6k.tar.gz as
> recommended by
> http://wireless.kernel.org/en/users/Drivers/ath6kl?highlight=%28ar6003%29. 
> 

These are fine.

> After running 'insmod ath6kl.ko', the command line hangs.  I’ve narrowed down
> the execution path to the function ath6kl_bmi_get_rx_lkahd (called from
> ath6kl_bmi_exeute after loading the OPT firmware).  The parameter value of
> "need_timeout" is set to false.  Without this timeout the function never
> returns.  The call to ath6kl_hif_read_write_sync always returns 0, and the value
> of rx_word is always 0.
> 
> My question is: What would cause the read from address
> RX_LOOKAHEAD_VALID_ADDRESS to always return a value of 0?

Odd, we have never seen this sort of issues. Can you please give
the kernel debug output with BMI debug enabled (debug_mask=0x10).

Vasanth
