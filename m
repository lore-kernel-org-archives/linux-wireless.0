Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50901 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbaLJIMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 03:12:49 -0500
Message-ID: <1418199160.3460.2.camel@sipsolutions.net> (sfid-20141210_091251_979298_14F5152A)
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vadim Kochan <vadim4j@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 10 Dec 2014 09:12:40 +0100
In-Reply-To: <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org>
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
	 <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 00:23 +0100, Marcel Holtmann wrote:

> have we considered also exposing the mode of this netdev. So for
> example sta,ap,p2p-go,p2p-client etc. If we can send dynamic updates
> via RTNL, we could easily tell the networking management system what
> type of wireless device we have here. I am thinking about it like
> "wlan/p2p-go" etc. Or should this be better kept strictly to "wlan".

I certainly haven't considered this API at all :)
That said, I'm not sure where it would be used, so I don't really know.

> And I am not sure RTNL would be capable of changing this kind strings
> at runtime anyway.

Given the API (fixed constant string in a const struct that the netdev
points to) it seems that it doesn't really support that, unless we
change the internals to have a function to return the string or keep
lots of copies of the struct and reassign them - neither seems very
appealing.

johannes

