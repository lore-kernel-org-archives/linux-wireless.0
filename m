Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3JGIhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 04:37:14 -0400
Message-ID: <1381135030.13586.12.camel@jlt4.sipsolutions.net> (sfid-20131007_103730_197948_91046B30)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <c_duttus@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Date: Mon, 07 Oct 2013 10:37:10 +0200
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F71B55F@aphydexd01a>
References: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com>
	 <1380704456.13329.8.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F71B55F@aphydexd01a>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-03 at 07:20 +0000, Undekari, Sunil Dutt wrote:
> Thanks Johannes for the review.
> 
> >It seems you should validate that the length is even, and at least 2?
> Can I know why the check for even/ atleast 2 is? Though I would
> validate for a non zero length and return failure in the else,
> considering a case where the TDLS peer advertises a single channel.
> Shouldn't it suffice?

Yes, if you look at the 802.11 spec you can know why. Hint: a single
channel is advertised using 2 bytes.

johannes

