Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1HHIqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:46:46 -0400
Subject: Re: [PATCHv2 2/2] mac80211: Don't use a buf_size=0 in ADDBA
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
In-Reply-To: <CAGXE3d9EwS8wMZRYUxAz5FqiTzRZiAATmOcWaG17vbcqryH7ZQ@mail.gmail.com> (sfid-20110808_104107_910363_06EB83BE)
References: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
	 <1312537579-18950-1-git-send-email-helmut.schaa@googlemail.com>
	 <1312792163.4372.5.camel@jlt3.sipsolutions.net>
	 <CAGXE3d9EwS8wMZRYUxAz5FqiTzRZiAATmOcWaG17vbcqryH7ZQ@mail.gmail.com>
	 (sfid-20110808_104107_910363_06EB83BE)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:46:41 +0200
Message-ID: <1312793201.4372.9.camel@jlt3.sipsolutions.net> (sfid-20110808_104649_817525_456BC459)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 10:40 +0200, Helmut Schaa wrote:
> On Mon, Aug 8, 2011 at 10:29 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > So, are you saying the problem with getting 0 in replies is solved by
> > not sending 0 in requests?
> 
> This specific device always replies with a buf_size=0 _if_ we send an
> ADDBA request
> with a buf_size=0.
> 
> The first patch in this series solves a problem were mac80211 would
> buffer frames to
> this STA forever when the ADDBA response contains a buf_size=0 since the BA
> session is stuck in an intermediate state.
> 
> However, the AVM Fritz Stick N client behaves correctly if we're using
> a buf_size != 0
> in the ADDBA request. This is a bug in the Fritz Stick Windows driver
> (it should use
> the default size of its rx reorder buffer if the ADDBA request
> contains 0). However, this
> bug can be worked around by using a buf_size != 0 in ADDBA requests. And that's
> what the second patch does.
> 
> Hope this clarifies my intention :)

Yes, thanks.

johannes

