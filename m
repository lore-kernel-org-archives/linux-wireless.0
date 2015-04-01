Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:61048 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbbDAKEg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 06:04:36 -0400
Message-ID: <551BC2B1.3030002@neratec.com> (sfid-20150401_120440_667093_B29BA52D)
Date: Wed, 01 Apr 2015 12:04:33 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com> <55191D89.2000300@neratec.com> <55198EA4.1010101@codeaurora.org>
In-Reply-To: <55198EA4.1010101@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2015 07:57 PM, Peter Oh wrote:
> 
> On 03/30/2015 02:55 AM, Zefir Kurtisi wrote:
>> [...]
>> That's why I believe we need to
>> be very cautious when changing it to fix / improve minor issues.
> This patch is not for minor fix.
> Current DFS detector fails on Japan W53 band which requires at least 50% of data
> traffic during DFS certificate.
> So this patch should apply to both of 9k and 10k.

That is the core of my concern: you add changes to fix FCC/JP, which at the same
time also affects ETSI.

Our company (and maybe others) got ath9k certified for ETSI, and any potential
change to the detector relevant for that domain would essentially require to
re-certify.

There were several patches lately added to the detector that were isolated to
specific domains (like the recent updates for FCC pattern 1) which I knew won't
affect the ETSI detector performance, since they touched only the FCC
configuration but not the algorithm itself. This patch does, and that's why I need
to point out that doing so might void certification efforts out there.

Unfortunately, I have no good idea how to cope with it. Freezing the driver at the
certified state is no option, since we all want to evolve. Having multiple copies
of the detector for each regulatory domain would be an option (and essentially
will happen since FCC/JP can't be covered by PRI detectors only), but gives
unacceptable code duplication. Ideally we would fully separate algorithm from
configuration and leave the algorithm untouched ever after, not sure how doable,
though.


As for your patch at hand, I tested it for ETSI and it does not change detector
performance, therefore (please replace 16 with PRI_TOLERANCE in the macro)

Acked-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
