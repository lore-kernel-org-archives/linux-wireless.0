Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59821 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab1GZPuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:50:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QljtV-0005nF-FW
	for linux-wireless@vger.kernel.org; Tue, 26 Jul 2011 17:50:07 +0200
Received: from gate-il06-2.motorola.com ([129.188.33.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 17:50:05 +0200
Received: from btaylor1 by gate-il06-2.motorola.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 17:50:05 +0200
To: linux-wireless@vger.kernel.org
From: Brent Taylor <btaylor1@motorolasolutions.com>
Subject: ATH6KL lockup during init
Date: Tue, 26 Jul 2011 15:43:02 +0000 (UTC)
Message-ID: <loom.20110726T174149-11@post.gmane.org> (sfid-20110726_175016_155493_2A1D9026)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I’m a developer working with the Atheros AR6003 Wireless LAN chip.  I recently
updated the Linux kernel on my custom board to 3.0.0 and pulled the latest
snapshot of the ath6kl driver from
http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary (as
of 2011-07-25).  I’m also using the latest firmware images from
http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ath6k.tar.gz as
recommended by
http://wireless.kernel.org/en/users/Drivers/ath6kl?highlight=%28ar6003%29. 

After running 'insmod ath6kl.ko', the command line hangs.  I’ve narrowed down
the execution path to the function ath6kl_bmi_get_rx_lkahd (called from
ath6kl_bmi_exeute after loading the OPT firmware).  The parameter value of
"need_timeout" is set to false.  Without this timeout the function never
returns.  The call to ath6kl_hif_read_write_sync always returns 0, and the value
of rx_word is always 0.

My question is: What would cause the read from address
RX_LOOKAHEAD_VALID_ADDRESS to always return a value of 0?

My custom board is using an atmel at91sam9g45 microprocessor using the SDIO bus
on mci1.  Any information would be greatly appreciated.

Thanks,
Brent Taylor
Senior Software Developer
Applied Technology Department of Motorola Solutions
btaylor1@motorolasolutions.com


