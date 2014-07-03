Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45931 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039AbaGCPKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 11:10:38 -0400
Received: by mail-ie0-f173.google.com with SMTP id at20so298863iec.32
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 08:10:37 -0700 (PDT)
Date: Thu, 3 Jul 2014 11:10:34 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with new
 plid
Message-ID: <20140703151034.GA10238@localhost> (sfid-20140703_171043_768398_1B5C089E)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
 <20140628205414.GA17825@localhost>
 <CAEFj987rJW6bH7bZQKT1W2RzMVB2BnOyWABRQRHwbrCSuOAUig@mail.gmail.com>
 <20140703142837.GA11380@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140703142837.GA11380@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 03, 2014 at 10:28:37AM -0400, Bob Copeland wrote:
> > What is the consequence if we don't handle this case? Is the peer
> > going to do the re-auth again?
> > 
> > Regards,
> > Chun-Yeow
> 
> It shouldn't be a big problem -- looking at 802.11-2012 figure 13-2:

Actually, thinking about it more, a worse case is if B reaches
ESTAB and then A reboots.  Now, A sends an Open, gets back
a Confirm that A will ignore (due to no plid).  A will still
timeout and send a Close frame to restart everything, but we
would have to wait quite a while to re-establish the peering.

-- 
Bob Copeland %% www.bobcopeland.com
