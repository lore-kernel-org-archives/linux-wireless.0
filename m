Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59598 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2EaEtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 00:49:08 -0400
Message-ID: <4FC6F83D.90107@qca.qualcomm.com> (sfid-20120531_064945_322023_75A21A48)
Date: Thu, 31 May 2012 10:19:01 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <stable@vger.kernel.org>
Subject: Re: [RFC] ath9k: Fix softlockup in AR9485
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com> <CAJ-VmomiQjGKKPtErYuhChpvqHCof4wXwt4BH2n1Rei_RnvyGA@mail.gmail.com>
In-Reply-To: <CAJ-VmomiQjGKKPtErYuhChpvqHCof4wXwt4BH2n1Rei_RnvyGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On Thursday 31 May 2012 12:18 AM, Adrian Chadd wrote:
> (Yes, this is a public response.)
>
> Hi,
>
> That has me a bit concerned. Waiting for the STA to be associated is
> really just some kind of "settling" delay. You're still TX/RXing at
> that point.

yeah, but i am pretty sure in the STA mode we have this PLL registers 
having sane values once the STA is associated. i checked if i am missing 
hardware code/init_pll routine or if its actually overwritten by INI 
values, but no. i also checked this issue with IBSS and monitor mode 
even under shield room, still it did not show much improvements or more 
clue.

>
> I think we need to speak to the baseband/clock teams and figure out
> why this is actually occuring.

oh yes and i had been already sending some mails internally, checking 
with people who might have good knowledge about this.

>
> Can we please leave this out of the tree (but in the bug report) until
> this gets root caused internally?

one thing i observed was this rx hang detection is based on the 'delta 
of rx unicast packets' for a particular time. if its lesser than 5 this 
rx hang detection kicks off. another system expert told me this rx hang 
itself can be specific to AP rather than STA.

finally i would check with one system expert and another Engineer to get 
some thoughts, then send it as a PATCH.


>
> Thanks,
>
>
>
> adrian


-- 
thanks,
shafi
