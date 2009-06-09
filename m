Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32974 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZFIOKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:10:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 07:10:17 -0700
Date: Tue, 9 Jun 2009 19:38:48 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix the way ADDBA request count being
	modified
Message-ID: <20090609140847.GA4459@vasanth-laptop>
References: <1244536906-22335-1-git-send-email-vasanth@atheros.com> <1244556118.4672.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244556118.4672.10.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 07:31:58PM +0530, Johannes Berg wrote:
> On Tue, 2009-06-09 at 14:11 +0530, Vasanthakumar Thiagarajan wrote:
> > addba_req_num[tid] is supposed to have the count of consecutive
> > addba request attempts on 'tid' which failed. This count is checked
> > against a retry threshold (3 times) before starting the addba negotiation.
> > This patch fixes the way this addba count is incremented/reset and thereby
> > avoids indefinite addba attempts.
> 
> I've never actually seen this hit in practise, so I'll trust you on
> it :)
> 
> johannes
> 

I have seen this happening with most of the 11n APs around when AMPDU
is disabled (configured to deny addba) on them.

Vasanth
