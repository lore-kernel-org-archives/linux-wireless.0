Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50156 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751569AbdIZKSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 06:18:17 -0400
Message-ID: <1506421094.22427.8.camel@sipsolutions.net> (sfid-20170926_121826_301417_BFB8DC54)
Subject: Re: [PATCH] mac80211: make STA_SLOW_THRESHOLD local
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: toke@toke.dk
Date: Tue, 26 Sep 2017 12:18:14 +0200
In-Reply-To: <1506419987-22995-1-git-send-email-sgruszka@redhat.com>
References: <1506419987-22995-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-26 at 11:59 +0200, Stanislaw Gruszka wrote:
> STA_SLOW_THRESHOLD is used only in one function, so don't need to be
> global define.
> 
> Patch also fixes problem of htmldocs build I encountered:
> 
> Error(.//net/mac80211/sta_info.h:416): cannot understand prototype:
> 'STA_SLOW_THRESHOLD 6000  '

Why not just change /** to /*? I think it's better to keep it there
even if it's not used, it's a more public thing than the code?

johannes
