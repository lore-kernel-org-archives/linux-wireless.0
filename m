Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:32770 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbGBOpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 10:45:46 -0400
Received: by igcur8 with SMTP id ur8so120593534igc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 07:45:45 -0700 (PDT)
Date: Thu, 2 Jul 2015 10:45:27 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: Re: [PATCH 3/3] mac80211: select an AID when creating new mesh STAs
Message-ID: <20150702144527.GA3846@localhost> (sfid-20150702_164549_469035_6E9459F6)
References: <1435843690-2856-1-git-send-email-me@bobcopeland.com>
 <1435843690-2856-4-git-send-email-me@bobcopeland.com>
 <1435843898.2285.24.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435843898.2285.24.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 02, 2015 at 03:31:38PM +0200, Johannes Berg wrote:
> On Thu, 2015-07-02 at 09:28 -0400, Bob Copeland wrote:
> > 
> > +	DECLARE_BITMAP(aid_map, IEEE80211_MAX_AID + 1);
> > 
> Is there really much point in keeping a long-lived bitmap rather than
> iterating the existing stations when adding a new one? It's not such a
> frequent operation after all.

Not really -- I tried it both ways initially, and the bitmap ended up
with less code and u.mesh was still (slightly) smaller than u.mgd, but I
agree it does feel kind of bloaty so I'll prep a version the other way.

-- 
Bob Copeland %% http://bobcopeland.com/
