Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-37.dex002.intermedia.net ([64.78.21.122]:31093 "EHLO
	dhost002-37.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030560AbXBOUE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:04:57 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 15 Feb 2007 12:04:52 -0800
To: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070215200452.GE14247@instant802.com>
References: <200702141423.27823.IvDoorn@gmail.com> <1171557724.5220.30.camel@johannes.berg> <200702151402.48150.flamingice@sourmilk.net> <200702151422.12195.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702151422.12195.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 02:22:07PM -0500, Michael Wu wrote:

> To be specific, I don't like the library approach when we can simply set a 
> flag and let the stack handle it.

In general, I would prefer not to use library approach for things like
this sequence number support. In this case, there may not even be need
for that flag if the operation itself is fast enough. In other words, I
don't think it would cause problems for other drivers if the seq# were
set regardless of whether it is neede or not. Just doing this without
the flag may be the cleanest way and not likely to use much more CPU
than verification of a flag before doing this..

-- 
Jouni Malinen                                            PGP id EFC895FA
