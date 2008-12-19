Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57793 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLSPpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 10:45:12 -0500
Date: Fri, 19 Dec 2008 10:30:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
	as pairwise cipher
Message-ID: <20081219153039.GC4041@tuxdriver.com> (sfid-20081219_164516_885548_C3AFE744)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <20081219142822.GA4041@tuxdriver.com> <20081219145616.GA12018@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081219145616.GA12018@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 04:56:16PM +0200, Jouni Malinen wrote:
> On Fri, Dec 19, 2008 at 09:28:22AM -0500, John W. Linville wrote:
> > Are there perhaps any broken APs out there that support such a
> > configuration?  I would hate to prevent users from connecting simply
> > out of blind obedience to the standard.
> 
> The goal of this change is _not_ to prevent connection, it only disables
> HT association, i.e., legacy (11a/g/b) is still available.

It was pointed-out to me that allowing TKIP/HT connections exposes
the user to unnecessary security risks as well.

Please resubmit with a changelog that a) makes it clear that
connections are still possible, just not HT; and b) "TKIP is not
updated to new security needs (e.g., related to some block ack details)
since it is not allowed mode, i.e., those extensions are only defined
for CCMP" (quoted from Jouni).

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
