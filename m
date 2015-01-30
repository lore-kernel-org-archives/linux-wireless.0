Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54349 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbbA3NbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:31:16 -0500
Message-ID: <1422624670.1919.21.camel@sipsolutions.net> (sfid-20150130_143122_683505_DF6DAC56)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 14:31:10 +0100
In-Reply-To: <CA+BoTQnkqzHNWTFSc9VB4_itCK_+jC6HC8GmdMKiyrhu-Sz9Cg@mail.gmail.com> (sfid-20150130_142217_389536_71E3C7E4)
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	 <1422621903.1919.7.camel@sipsolutions.net>
	 <CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com>
	 <1422623054.1919.18.camel@sipsolutions.net>
	 <CA+BoTQnkqzHNWTFSc9VB4_itCK_+jC6HC8GmdMKiyrhu-Sz9Cg@mail.gmail.com>
	 (sfid-20150130_142217_389536_71E3C7E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 14:22 +0100, Michal Kazior wrote:

> You'd probably have to add quite a few mutex_lock(iflist_mtx) around
> drv_*() calls (not directly but somewhere at their call trees) to
> guarantee driver can use lock-free iterate() version (which doesn't
> exist yet). This could be tricky.

Well, I was thinking you'd only use it in some places now - but it does
seem a bit difficult to maintain.

We've not typically had to worry about using the synchronous versions
much since we mostly just need a single interface so we just pass it out
and use it there, or so.

johannes

