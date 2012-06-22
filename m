Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38469 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760539Ab2FVLoS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 07:44:18 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] ath9k_hw: fix smatch warnings in spur_mitigate
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com>
	<87bokb4xof.fsf@purkki.adurom.net>
	<20120622092226.GA7934@vmraj-lnx.users.atheros.com>
Date: Fri, 22 Jun 2012 14:44:14 +0300
In-Reply-To: <20120622092226.GA7934@vmraj-lnx.users.atheros.com> (Rajkumar
	Manoharan's message of "Fri, 22 Jun 2012 14:52:28 +0530")
Message-ID: <877guz4lm9.fsf@purkki.adurom.net> (sfid-20120622_134422_242952_5BE996CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:

>> > -			qCoff = qCoff & 0x7f;
>> > +			qCoff &= 0x7f;
>> 
>> I'm curious, how does a change like this fix anything? To me it just
>> looks same functionality, just a different operator is used. Am I
>> missing something?
>
> Though it doesn't make a difference, somehow it fixes smatch warning.
> I agree it is not the right fix.

Ok, maybe it's just that smatch isn't clever enough with the &= operator.
Dan?

-- 
Kalle Valo
