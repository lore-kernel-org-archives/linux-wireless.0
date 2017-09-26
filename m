Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935241AbdIZLZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 07:25:39 -0400
Date: Tue, 26 Sep 2017 13:23:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Subject: Re: [PATCH] mac80211: make STA_SLOW_THRESHOLD local
Message-ID: <20170926112359.GA5744@redhat.com> (sfid-20170926_132746_066288_62FC2E5B)
References: <1506419987-22995-1-git-send-email-sgruszka@redhat.com>
 <1506421094.22427.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506421094.22427.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 12:18:14PM +0200, Johannes Berg wrote:
> On Tue, 2017-09-26 at 11:59 +0200, Stanislaw Gruszka wrote:
> > STA_SLOW_THRESHOLD is used only in one function, so don't need to be
> > global define.
> > 
> > Patch also fixes problem of htmldocs build I encountered:
> > 
> > Error(.//net/mac80211/sta_info.h:416): cannot understand prototype:
> > 'STA_SLOW_THRESHOLD 6000????'
> 
> Why not just change /** to /*? I think it's better to keep it there
> even if it's not used, it's a more public thing than the code?

I thought local references are preferred over global. Fixing only
comment is fine for me, I'll post v2.

Stanislaw
