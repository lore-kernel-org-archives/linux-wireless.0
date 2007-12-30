Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:54087 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbXL3IxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 03:53:19 -0500
Date: Sun, 30 Dec 2007 09:53:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: rc80211_pid fails to remove debugfs files
Message-ID: <20071230095302.258e7846@morte> (sfid-20071230_085325_528705_350C74B2)
In-Reply-To: <200712292314.56620.mb@bu3sch.de>
References: <200712292314.56620.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 29 Dec 2007 23:14:56 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> The rc80211_pid fails to remove the debugfs files properly.
> In debugfs I see phyX directories for PHYs that are long gone.
> The only content is the rc80211_pid directory with its files.

Wait, this is fixed by:

Subject: [PATCH 4/7] rc80211-pid: fix sta_info refcounting

Fix a bug which caused uncorrect refcounting of PHYs in mac80211. Thanks to
Johannes Berg for spotting this out.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

(still not merged).


-- 
Ciao
Stefano
