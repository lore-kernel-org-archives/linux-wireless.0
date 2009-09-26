Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57895 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbZIZIOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 04:14:49 -0400
Date: Sat, 26 Sep 2009 11:14:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH]: nl80211: report age of scan results
Message-ID: <20090926081438.GA20788@jm.kir.nu>
References: <200909241055.51604.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200909241055.51604.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 10:55:51AM +0200, Holger Schurig wrote:
> One question was if I should specify the age in ms, or if I should specify
> an absolute time. In the end I thought age in ms is better suited.
> 
> If an absolute time would sent with every BSS item, then user-space would
> need an additional call to time() to find out which BSS items are too old.
> Now it can use the milliseconds directly.

This would depend on your use case.. I would have preferred absolute
time since it allows the application to filter out entries that were not
updated after the last scan request, i.e., to figure out which entries
were found based on the last scan request (or well, based on frames
received during this time).

> The case there user-space wants an absolute time ("At what hour did I get
> the last probe response from this AP?") seems to be a more theoretical
> problem. But if info is wanted, *THEN* you can call time() and substract the
> reported bss-item-age from it.

No you cannot or well, you cannot get the exact time using this
mechanism since you do not know the exact time used in the kernel for
calculating the age. Anyway, the exact time may not matter that much if
there were a better way at figuring out whether the results are based on
a specific scan request.

One option would be to add a sequence number into scan requests and
report this to the user space in the scan completed event. The scan
results would also need to include the sequence number of the scan
request after which they were updated.

-- 
Jouni Malinen                                            PGP id EFC895FA
