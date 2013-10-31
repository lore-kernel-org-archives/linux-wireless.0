Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3JaQmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:42:12 -0400
Message-ID: <1383237729.14302.6.camel@jlt4.sipsolutions.net> (sfid-20131031_174215_783589_6B35A030)
Subject: Re: [PATCH] mac80211: do not compute offset from ssn in Rx AMPDU
 reordering buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 31 Oct 2013 17:42:09 +0100
In-Reply-To: <1382622812-18253-1-git-send-email-karl.beldan@gmail.com> (sfid-20131024_155324_357056_05CCCAE4)
References: <1382622812-18253-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131024_155324_357056_05CCCAE4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-24 at 15:53 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM, frames with SN sn are mapped into the sta reordering buffer
> sta->ampdu_mlme->tid_rx->reorder_buf at index
> ieee80211_sn_sub(sn, tid_rx->ssn) % tid_rx->buf_size.
> This offset calculation is useless, and this change replaces the index
> with sn % tid_rx->buf_size.

Applied.

johannes

