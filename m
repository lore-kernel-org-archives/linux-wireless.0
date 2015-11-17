Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22559 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbbKQCqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 21:46:15 -0500
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: poll HTT send completion when CE 5 is unused
Date: Tue, 17 Nov 2015 02:46:03 +0000
Message-ID: <1447728358664.94372@qti.qualcomm.com> (sfid-20151117_034618_437176_E265A4E6)
References: <1447243286-22116-1-git-send-email-rmanohar@qti.qualcomm.com>,<871tbp1ye6.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871tbp1ye6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > commit a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")
> > moved send completion polling under HTT Rx (CE 5) service routine. For
> > QCA6174 based devices copy engine 1 (CE 1) is used for HTT Rx instead
> > of CE 5. So send completion never be called. This is causing "failed to
> > transmit packet, dropping: -105" errors. Fix this by processing send
> > completion from CE 1 service routine instead of CE 5.
> >
> > Tested-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> Applied to ath-current, thanks. I had a trivial conflict, please review
> carefully my changes:
> 
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=ath-current&id=6419fdbb6f90e147690f8833cba59d289d613da5
> 
Looks good. Thanks for fixing conflicts.

-Rajkumar