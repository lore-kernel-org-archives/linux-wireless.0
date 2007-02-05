Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-68.dex002.intermedia.net ([64.78.20.34]:7361 "EHLO
	DHOST002-68.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933415AbXBET1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 14:27:15 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 5 Feb 2007 11:13:00 -0800
To: Jiri Benc <jbenc@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Message-ID: <20070205191300.GD31058@instant802.com>
References: <1170699268.3572.39.camel@johannes.berg> <20070205192958.0fef1a88@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070205192958.0fef1a88@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 05, 2007 at 07:29:58PM +0100, Jiri Benc wrote:

> No. It's the other way around, when they're reported immediately, they
> will be out of order. ieee80211_tx_status is called from the interrupt
> handler as the result of the frame being actually sent. Before that, a
> frame can sit for an arbitrary long time in the hw queue or not sent at
> all. Reporting only frames confirmed by ieee80211_tx_status as
> successfully sent at the time the function is called reflects better
> what is on the air (it's still not perfect as things like
> retransmissions are not caught).

What is your definition for "successfully sent" in this context? I would
probably also include frames that did not receive ACK, but did have some
transmit tries. If there is place for reporting TX status (ack/no ack,
number of retries) that could be added here. In addition, some hardware
designs may also return the timestamp of the transmission in TX status,
so that could also be added. This would actually make it possible to
figure out the exact sequence of frames (in userspace app), if needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
