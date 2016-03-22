Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:56220 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbcCVLv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:51:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Y2038] [PATCH] prism54: isl_38xx: Replace 'struct timeval'
Date: Tue, 22 Mar 2016 12:51:11 +0100
Message-ID: <4052607.z5Cu6oJFz8@wuerfel> (sfid-20160322_125154_562222_352BC2E2)
In-Reply-To: <20160322095522.GA35392@localhost>
References: <20160322095522.GA35392@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 March 2016 02:55:22 Tina Ruchandani wrote:
> Truly fixing this would 
> require changing the debug print to print more than 8 digits and using 
> a different specifier from %li.

Why not just change it to %lli, and a cast to s64? I don't think the
format string or the number of digits is important here because it's just
debug output that is normally disabled.

I also see an existing bug in the format string: "%08li.%08li" means we
end up printing a six digit microsecond value with two leading zeros,
which is rather confusing. I think using "%lld.%06ld" would be best
here, or possibly "%lld.%09ld" to print the whole nanoseconds so we
can skip the division.

	Arnd
