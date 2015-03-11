Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49095 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbbCKTK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 15:10:26 -0400
Message-ID: <1426101010.1904.9.camel@sipsolutions.net> (sfid-20150311_201031_450921_C73324F0)
Subject: Re: [PATCH RFC v2] ath10k: move code from parameter list into a
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Valdis.Kletnieks@vt.edu,
	Bj??rn Mork <bjorn@mork.no>,
	Jeff Haran <Jeff.Haran@citrix.com>,
	Pat Erley <pat-lkml@erley.org>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Wed, 11 Mar 2015 20:10:10 +0100
In-Reply-To: <1426100519-20636-1-git-send-email-hofrat@osadl.org> (sfid-20150311_200723_379167_2BC79246)
References: <1426100519-20636-1-git-send-email-hofrat@osadl.org>
	 (sfid-20150311_200723_379167_2BC79246)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 15:01 -0400, Nicholas Mc Guire wrote:
> Putting code into the parameter list of wait_event_timeout() might be
> legal C-code but not really readable - the "inline" code is simply
> moved into a function and that passed to wait_event_timeout() as the
> condition.

Arguably, that's even more unreadable since if you don't know this macro
well you might assume the function is called only once, which is clearly
not true...

Don't get me wrong, I'm not opposed to this change, but if you ask me
it's not completely clear that this makes it more readable.

johannes

