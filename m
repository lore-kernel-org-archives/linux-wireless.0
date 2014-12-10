Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33709 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLJUfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 15:35:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1418199160.3460.2.camel@sipsolutions.net>
Date: Wed, 10 Dec 2014 21:35:39 +0100
Cc: Vadim Kochan <vadim4j@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <C257D1BD-088E-41A1-8221-2891E916E630@holtmann.org> (sfid-20141210_213549_208045_232A62C9)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com> <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org> <1418199160.3460.2.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> have we considered also exposing the mode of this netdev. So for
>> example sta,ap,p2p-go,p2p-client etc. If we can send dynamic updates
>> via RTNL, we could easily tell the networking management system what
>> type of wireless device we have here. I am thinking about it like
>> "wlan/p2p-go" etc. Or should this be better kept strictly to "wlan".
> 
> I certainly haven't considered this API at all :)
> That said, I'm not sure where it would be used, so I don't really know.
> 
>> And I am not sure RTNL would be capable of changing this kind strings
>> at runtime anyway.
> 
> Given the API (fixed constant string in a const struct that the netdev
> points to) it seems that it doesn't really support that, unless we
> change the internals to have a function to return the string or keep
> lots of copies of the struct and reassign them - neither seems very
> appealing.

if this is a constant string similar to DEVTYPE, the it should be just "wlan" and nothing else. If internal APIs require changing, then that could be done in addition to this patch.

Regards

Marcel

