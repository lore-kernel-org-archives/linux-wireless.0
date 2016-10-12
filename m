Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41841 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754488AbcJLH5c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:57:32 -0400
Message-ID: <1476259048.5271.15.camel@sipsolutions.net> (sfid-20161012_095831_453812_24AED2FD)
Subject: Re: [PATCH] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 12 Oct 2016 09:57:28 +0200
In-Reply-To: <1476258794.5271.12.camel@sipsolutions.net>
References: <1476118360-29009-1-git-send-email-michael-dev@fami-braun.de>
         <1476258794.5271.12.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-12 at 09:53 +0200, Johannes Berg wrote:
> On Mon, 2016-10-10 at 18:52 +0200, Michael Braun wrote:
> > 
> > According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer
> > SA/DA of A-MSDU frames need to be changed depending on FromDS/ToDS
> > values.
> 
> "Need to" is perhaps a bit strongly worded, but whatever :)
> 
> I was going to write a long reply and whatever - but I think that's
> all moot. As far as I can tell, you got this completely wrong, as
> you're changing the *inner* headers, not the *outer* header as you
> should?

Oh, no, my mistake - this happens before 802.3->.11 conversion.

So this does look correct, but I don't like that you write to
amsdu_hdr.h_{source,dest} twice after the patch.

I think you should have da and sa variables and set those, and then
memcpy only once.

johannes
