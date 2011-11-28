Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1K1Iae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 03:30:34 -0500
Subject: Re: [PATCH 0/2] mac80211: use timeout from addba resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com> (sfid-20111127_231609_949056_E5E23CE4)
References: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111127_231609_949056_E5E23CE4)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 09:30:30 +0100
Message-ID: <1322469030.4060.4.camel@jlt3.sipsolutions.net> (sfid-20111128_093037_495201_C83EA893)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-11-27 at 17:15 -0500, Nikolay Martynov wrote:
> If other side sent us non zero timeout in addba response use it as a
> timeout for TX session. Before this patch initiator and recipient
> could have different timeouts if recipient decides to change timeout
> offered by initiator.

I'm not convinced this is correct, can you say where the standard says
that we should take the recipient's timeout? The way I read it, the
originator informs the recipient of its timeout, not the other way
around, and we implement that in agg-rx.

johannes

