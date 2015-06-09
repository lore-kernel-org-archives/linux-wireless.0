Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54894 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbbFIUKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:10:32 -0400
Message-ID: <1433880629.1892.24.camel@sipsolutions.net> (sfid-20150609_221035_034753_49D2D134)
Subject: Re: [PATCH V2] mac80211: Fix power save state stuck in ACTIVE
 caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 09 Jun 2015 22:10:29 +0200
In-Reply-To: <CABPxzYLMiX1chbNxUd4gfK2HeKkXxHEw1rjf+5on4mskxce1Gg@mail.gmail.com> (sfid-20150601_233225_467260_D87DD2BF)
References: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1433190967.3505.17.camel@sipsolutions.net>
	 <CABPxzYLMiX1chbNxUd4gfK2HeKkXxHEw1rjf+5on4mskxce1Gg@mail.gmail.com>
	 (sfid-20150601_233225_467260_D87DD2BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-02 at 03:02 +0530, Krishna Chaitanya wrote:

> > This isn't what your patch is actually doing though. You need to mention
> > WoWLAN at the very least in your commit log;

> Yes, WoWLAN is enabled in our testing. Without wowlan the connection
> will not be intact. So i assumed the check "is_associated" would
> imply wowlan.

I meant the commit log.

If I read your commit log without the patch, it doesn't make sense at
all since regular suspend/resume will turn off the device anyway. You
really need to mention
 a) the fact that wowlan is used, and
 b) the fact that you care about powersave state *while in wowlan*

johannes

