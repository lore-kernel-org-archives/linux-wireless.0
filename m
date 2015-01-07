Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55322 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbbAGILz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 03:11:55 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Wed, 7 Jan 2015 00:09:05 -0800
Subject: RE: [PATCH] mwifiex: do not emit messages while holding spinlock
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A81@SC-VEXCH2.marvell.com> (sfid-20150107_091159_209058_B6AB6B64)
References: <1420634425-28306-1-git-send-email-patila@marvell.com>
	 (sfid-20150107_081059_683326_970C28B9),<1420616453.3407.0.camel@sipsolutions.net>
In-Reply-To: <1420616453.3407.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, January 07, 2015 1:10 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo
Subject: Re: [PATCH] mwifiex: do not emit messages while holding spinlock

On Wed, 2015-01-07 at 18:10 +0530, Avinash Patil wrote:
> Avoid printing dev_{warn/dbg} messages while holding spinlock.

>Err, why? There's normally no particular reason to worry about this, so
>explaining that might be good.

Hmm..yes. dev_dbg/dev_err while holding spinlock is not an issue.
This is just for sake of releasing spinlock ASAP.

Thanks,
Avinash.
