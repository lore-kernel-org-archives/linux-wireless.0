Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59629 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788AbbCDIPk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 03:15:40 -0500
Message-ID: <1425456934.1810.2.camel@sipsolutions.net> (sfid-20150304_091548_962163_1AA97765)
Subject: Re: [RFC 2/2] mac80211: store low ack threshold in bss config
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 04 Mar 2015 09:15:34 +0100
In-Reply-To: <1425385383-25482-2-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425385383-25482-1-git-send-email-rmanohar@qti.qualcomm.com>
	 <1425385383-25482-2-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 17:53 +0530, Rajkumar Manoharan wrote:
> Store the low ack threshold configured by user in BSS config.
> This will be used by driver for triggering low ack event whenever
> the station is not ACKing the number of frames mentioned in
> threshold.

Err, this cannot possibly be sufficient. mac80211 already *has* this
functionality built into it, so you need to tie the two together, and if
you need to offload it to the device then you need to also bypass the
mac80211 implementation.

johannes

