Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaJFMF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:05:27 -0400
Date: Mon, 6 Oct 2014 17:36:58 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ath10k: Add support to configure pktlog filter
Message-ID: <20141006120656.GA19615@qca.qualcomm.com> (sfid-20141006_140555_390233_659B0662)
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1412269778-1045-2-git-send-email-rmanohar@qti.qualcomm.com>
 <877g0dl8j6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <877g0dl8j6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2014 at 02:52:45PM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Add support to configure packet log filters (tx, rx, rate control)
> > via debugfs. To disable htt pktlog events set the filters to 0.
> >
> > ex:
> >
> > To enable pktlog for all filters
> >
> >    echo 0x1f > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
> >
> > To disable pktlog
> >
> >    echo 0 > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> I did minor changes to the error handling in
> ath10k_write_pktlog_filter() and in ath10k_debug_start(). Diff below and
> full commit here:
> 
> https://github.com/kvalo/ath/commit/470c43d83b7ee4147dea38a4f7b986070555a032
> 
> Please review my changes.
> 

LGTM. We need Michal's tracepoint changes other than pktlog. I do not have his
latest version of the change.

-Rajkumar
