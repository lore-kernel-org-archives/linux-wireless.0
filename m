Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3JAKWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:22:35 -0400
Message-ID: <1380622952.14430.9.camel@jlt4.sipsolutions.net> (sfid-20131001_122238_089954_44F2CFE1)
Subject: Re: [PATCH] mac80211: support reporting A-MSDU subframes
 individually
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 12:22:32 +0200
In-Reply-To: <1379943278-1014-1-git-send-email-michal.kazior@tieto.com>
References: <1379943278-1014-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-23 at 15:34 +0200, Michal Kazior wrote:
> Some devices may not be able to report A-MSDUs in
> single buffers. Drivers for such devices were
> forced to re-assemble A-MSDUs which would then
> be eventually disassembled by mac80211. This could
> lead to CPU cache thrashing and poor performance.
> 
> Since A-MSDU has a single sequence number all
> subframes share it. This was in conflict with
> retransmission/duplication recovery
> (IEEE802.11-2012: 9.3.2.10).
> 
> Patch introduces a new flag that is meant to be
> set for all individually reported A-MSDU subframes
> except the last one. This ensures the
> last_seq_ctrl is updated after the last subframe
> is processed. If an A-MSDU is actually a duplicate
> transmission all reported subframes will be
> properly discarded.

Applied.

johannes

