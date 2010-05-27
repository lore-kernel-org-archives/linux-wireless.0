Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab0E0SGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:06:34 -0400
Subject: Re: Conversion of driver for Realtek 8192SU
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>, Greg KH <greg@kroah.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4BFE9A22.5040005@lwfinger.net>
References: <4BFE9A22.5040005@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 20:06:21 +0200
Message-ID: <1274983581.3669.60.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 11:13 -0500, Larry Finger wrote:

> I know that the size of pointers changes from 32- to 54-bit
> architecture, as does the size of longs. I have been through the code
> many times, and I think those have been fixed. Are there any other types
> of objects that change size? Does anyone have any suggestions on what to
> look for?

Alignment _might_ be different, though I think it isn't actually as long
as we're talking about x86_64 (amd64) only.

If the driver uses wireless extensions (likely), it might have issues
with that too, since they are not very 32/64-bit compat happy (unless
you're using 64-bit userspace exclusively obviously)

I can't think of anything else right now.

johannes

