Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39646 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2BGJ7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 04:59:43 -0500
Date: Tue, 7 Feb 2012 15:29:35 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving
 firmware logs
Message-ID: <20120207095933.GB5765@chvasanth-lnx> (sfid-20120207_105947_343418_DF503E92)
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
 <20120206062340.20231.55630.stgit@localhost6.localdomain6>
 <20120206090654.GA3260@chvasanth-lnx>
 <4F2FC989.5000306@qca.qualcomm.com>
 <20120206150515.GA4024@chvasanth-lnx>
 <4F30122E.3060004@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F30122E.3060004@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 07:47:26PM +0200, Kalle Valo wrote:
> > Are you not making sure that the
> > length of the data is not more than the requested one which is
> > passed to copy_to_user() so that read() is always called with
> > *ppos=0?. The following code seems to do that
> 
> But the function is called multiple times with increasing values of
> *ppos as more data is returned to user space:
> 
> [  100.303747] ath6kl_fwlog_block_read(): *ppos 0
> [  100.305252] ath6kl_fwlog_block_read(): *ppos 30116
> [  101.768947] ath6kl_fwlog_block_read(): *ppos 31624
> [  117.027469] ath6kl_fwlog_block_read(): *ppos 33124
> [  117.090146] ath6kl_fwlog_block_read(): *ppos 34628
> [  117.172338] ath6kl_fwlog_block_read(): *ppos 36128
> 
> So I can't assume that *ppos = 0.

Right, unless we say we have no more data to pass
(when read() returns 0), *ppos would be keep on increasing
by the number of bytes copied to user space. Updating *ppos
just looks like a formality here though. But I'm also not
sure about doing it cleanly.

Vasanth
