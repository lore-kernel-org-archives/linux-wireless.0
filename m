Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44788 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1F3I1l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 04:27:41 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: implement testmode rx command
References: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
	<20110627180609.GZ14591@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 30 Jun 2011 11:27:39 +0300
In-Reply-To: <20110627180609.GZ14591@shale.localdomain> (Dan Carpenter's message of "Mon\, 27 Jun 2011 21\:06\:09 +0300")
Message-ID: <87wrg3zptw.fsf@purkki.adurom.net> (sfid-20110630_102744_835599_16EDE013)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Mon, Jun 27, 2011 at 06:36:10PM +0300, Kalle Valo wrote:
>
>> +void ar6000_testmode_rx_report_event(struct ar6_softc *ar, void *buf,
>> +				     int buf_len)
>> +{
>> +	kfree(ar->tcmd_rx_report);
>> +
>> +	ar->tcmd_rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
>> +	ar->tcmd_rx_report_len = buf_len;
>> +
>
> Can this race?  When we use tcmd_rx_report_len we are under lock,
> but it seems like when we set it here, we're not under lock.

Yes, it can. I'll fix it in v2.

Thanks again for good comments.

-- 
Kalle Valo
