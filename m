Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34665 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030682AbXBOTJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:09:32 -0500
Date: Thu, 15 Feb 2007 20:09:30 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070215200930.56c43974@griffin.suse.cz>
In-Reply-To: <1171557724.5220.30.camel@johannes.berg>
References: <200702141423.27823.IvDoorn@gmail.com>
	<1171557724.5220.30.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 17:42:04 +0100, Johannes Berg wrote:
> Can this be a library function instead? Our TX path is already cluttered
> enough...

The advantage of non-library approach in this case is that you don't
need to search for a BSS the frame belongs to. Ivo's patch searches for
it but I think it's possible to remember it from the past.

If this feature is implemented as a library function you need to search
for a BSS in any case. That's way more overhead than one condition in
the tx path.

 Jiri

-- 
Jiri Benc
SUSE Labs
