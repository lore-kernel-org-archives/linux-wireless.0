Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4181 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYBVPGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:06:44 -0500
Date: Fri, 22 Feb 2008 09:37:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: sta info locking
Message-ID: <20080222143745.GB3067@tuxdriver.com> (sfid-20080222_150653_481242_9B66FAA1)
References: <1203677069.26341.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203677069.26341.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2008 at 11:44:29AM +0100, Johannes Berg wrote:

> Hence, I think we can actually get away without more locking if we
> protect the flags better. Should we use a spinlock or the atomic
> set_bit()/clear_bit()/etc. operations?

Using the atomic operations seems appropriate to me.

-- 
John W. Linville
linville@tuxdriver.com
