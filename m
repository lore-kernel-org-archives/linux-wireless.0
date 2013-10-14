Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3JNHvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 03:51:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VVcvq-00080M-A4
	for linux-wireless@vger.kernel.org; Mon, 14 Oct 2013 09:51:14 +0200
Message-ID: <1381736727.13092.1.camel@jlt4.sipsolutions.net> (sfid-20131014_095118_578427_BA133E55)
Subject: Re: [PATCH] wireless: radiotap: fix parsing buffer overrun
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1381495982-28486-1-git-send-email-johannes@sipsolutions.net> (sfid-20131011_145313_711958_FED82D6C)
References: <1381495982-28486-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131011_145313_711958_FED82D6C)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Oct 2013 09:45:27 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 14:53 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When parsing an invalid radiotap header, the parser can overrun
> the buffer that is passed in because it doesn't correctly check
>  1) the minimum radiotap header size
>  2) the space for extended bitmaps
> 
> The first issue doesn't affect any in-kernel user as they all
> check the minimum size before calling the radiotap function.
> The second issue could potentially affect the kernel if an skb
> is passed in that consists only of the radiotap header with a
> lot of extended bitmaps that extend past the SKB. In that case
> a read-only buffer overrun by at most 4 bytes is possible.
> 
> Fix this by adding the appropriate checks to the parser.

Applied (with another fix pointed out by Evan)

johannes

