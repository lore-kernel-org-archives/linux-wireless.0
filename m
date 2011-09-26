Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1IZLQC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 07:16:02 -0400
Date: Mon, 26 Sep 2011 13:14:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Send nullfunc frames at lower rate
Message-ID: <20110926111440.GB2946@redhat.com> (sfid-20110926_131606_943248_307220F2)
References: <1317030225-3986-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317030225-3986-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 03:13:45PM +0530, Rajkumar Manoharan wrote:
> Recently mac80211 was changed to send nullfunc instead of probe
> request for connection monitoring. These nullfunc data frames
> are being sent at higer rates and also as aggregated ones. This
> could probably delays the nullfunc_ack so the connection is getting
> disconnected as max retries reached. In order to improve the
> connectivity send the nullfunc at lower rate.

We send nullfunc frames for connection monitoring also on older
kernels if hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS. I think
this is -stable fix.

Perhaps also rc_no_data_or_no_ack name should be changed to
something more appropriate.

Stanislaw
