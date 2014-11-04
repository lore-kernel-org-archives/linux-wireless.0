Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55365 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbaKDTsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 14:48:00 -0500
Message-ID: <1415130476.2064.22.camel@sipsolutions.net> (sfid-20141104_204803_319340_4B9C9213)
Subject: Re: Vendor Namespace Question
From: Johannes Berg <johannes@sipsolutions.net>
To: "C. McPherson" <ccmcphe@verizon.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@radiotap.org
Date: Tue, 04 Nov 2014 20:47:56 +0100
In-Reply-To: <54591CF9.7030106@verizon.net> (sfid-20141104_203850_228702_C706EE9A)
References: <54591CF9.7030106@verizon.net>
	 (sfid-20141104_203850_228702_C706EE9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 13:37 -0500, C. McPherson wrote:
> Hello all:
> I was just trying to use the latest stable backports-3.18-rc1-1 and I 
> noticed that there is no longer structure members in the 
> ieee80211_rx_status structure for Vendor namespace information?  In my 
> backports 3.14 version I used them to add some register information to 
> the radiotap header in the lab. How does one use the vendor name space 
> without those structure members?

We removed this from the Linux kernel because there was no driver using
it and we needed the space for other purposes. That said, it shouldn't
be too difficult to put it back by keeping the OUI/subtype also in the
skb->data rather than the rx_status (which is now full enough to no
longer have space for it, I believe)

johannes

