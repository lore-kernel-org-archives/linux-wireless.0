Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55146 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZKBPpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 10:45:07 -0500
Date: Mon, 2 Nov 2009 10:36:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix IBSS merge
Message-ID: <20091102153614.GC14046@tuxdriver.com>
References: <19182.33851.980271.360757@gargle.gargle.HOWL> <1257151486.3555.161.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257151486.3555.161.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2009 at 09:44:46AM +0100, Johannes Berg wrote:
> On Mon, 2009-11-02 at 12:33 +0530, Sujith wrote:
> > Currently, in IBSS mode, a single creator would go into
> > a loop trying to merge/scan. This happens because the IBSS timer is
> > rearmed on finishing a scan and the subsequent
> > timer invocation requests another scan immediately.
> > 
> > This patch fixes this issue by checking if we have just completed
> > a scan run trying to merge with other IBSS networks.
> 
> Heh, how many people do we need to fix IBSS? :)

Yeah, no kidding...I suspect that actual IBSS users are few, and a
substantial number of those are doing crazy things with it! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
