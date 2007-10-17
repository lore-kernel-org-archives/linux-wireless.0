Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbXJQOJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:09:54 -0400
Subject: Re: [PATCH 3/3] consistently use ath5k in printks
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <bruno@thinktube.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1192619652.8841.13.camel@johannes.berg>
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 (sfid-20071016_142100_724914_42FE5458)  <1192619652.8841.13.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 10:09:32 -0400
Message-Id: <1192630172.10567.29.camel@localhost.localdomain> (sfid-20071017_150958_233313_86046006)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-17 at 13:14 +0200, Johannes Berg wrote:
> On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
> 
> > the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
> 
> Ok, and why exactly is there a proc interface at all?

Yeah, it needs to die, we're not adding new proc interfaces to the
kernel.  Stuff should be evaluated to see whether it's _really_ needed,
and if for some reason it is, merged into mac80211 or cfg80211, and then
if that doesn't work, then maybe something in sysfs.

Dan


