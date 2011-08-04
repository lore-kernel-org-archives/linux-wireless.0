Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56221 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1HDMzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 08:55:15 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QoxSC-0007S0-VB
	for linux-wireless@vger.kernel.org; Thu, 04 Aug 2011 14:55:13 +0200
Received: from gate-il06-2.motorola.com ([129.188.33.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 14:55:12 +0200
Received: from btaylor1 by gate-il06-2.motorola.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 14:55:12 +0200
To: linux-wireless@vger.kernel.org
From: Brent Taylor <btaylor1@motorolasolutions.com>
Subject: Re: ATH6KL lockup during init
Date: Thu, 4 Aug 2011 12:55:02 +0000 (UTC)
Message-ID: <loom.20110804T145012-465@post.gmane.org> (sfid-20110804_145530_802297_385370C1)
References: <loom.20110726T174149-11@post.gmane.org> <loom.20110727T145019-705@post.gmane.org> <87hb60s69d.fsf@purkki.adurom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@...> writes:

> 
> Brent Taylor <btaylor1@...> writes:
> 
> > Fixed ... realized that I was using the wrong firmware images. I was
> > using an older image from AR6K_FW.3.0_RC.233.
> 
> Good that your issue was solved and thanks for letting us now. But
> nevertheless the driver should not lockup in there's a problem with
> firmware, ath6kl is definitely buggy here.
> 


My lockup (due to wrong firmware) was caused by the function
ath6kl_bmi_get_lkahd in bmi.c.  The function was called with the parameter
"need_timeout = false".  This causes the while loop to wait for a response from
the chip.  Since the wrong firmware image was used, the chip will never respond.

Is it possible for the ath6kl driver to somehow read the firmware version from
the firmware file before sending it to the chip?

-- Brent

