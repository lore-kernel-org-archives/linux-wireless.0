Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39406 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbaLWQHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 11:07:20 -0500
Message-ID: <1419350836.6091.10.camel@sipsolutions.net> (sfid-20141223_170723_360449_BE329126)
Subject: Re: [PATCH] cfg80211: add extensible feature flag attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 23 Dec 2014 17:07:16 +0100
In-Reply-To: <549992C0.4080708@broadcom.com>
References: <1419350119-29166-1-git-send-email-arend@broadcom.com>
	 <1419350316.6091.9.camel@sipsolutions.net> <549992C0.4080708@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-23 at 17:05 +0100, Arend van Spriel wrote:

> It compiles, but I guess nla_put() will fail for u8[0+8-1/8] field.

I think it should work - the array is 0 bytes long, so sizeof() would
return 0, and that turns out to be equivalent to nla_put_flag().

johannes

