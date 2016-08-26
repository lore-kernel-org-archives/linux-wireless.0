Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47404 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750712AbcHZIJL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:09:11 -0400
Message-ID: <1472198948.390.20.camel@sipsolutions.net> (sfid-20160826_100916_928008_E35799B6)
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Xu, Peng" <pxu@qca.qualcomm.com>
Date: Fri, 26 Aug 2016 10:09:08 +0200
In-Reply-To: <20160816123441.GA3678@jouni.qca.qualcomm.com>
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
         <1471330367.16783.23.camel@sipsolutions.net>
         <20160816123441.GA3678@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-08-16 at 12:34 +0000, Malinen, Jouni wrote:
> 
> > So if you get HT_VHT_NOT_INDICATED in the driver, don't you *still*
> > have to parse the IEs?
> 
> Well.. Yes, I guess one would need to do that for some time until
> relevant user space is expected to have been updated to support the
> new attribute.

So I guess the question is what drivers would use this, and how, and
would we have to introduce this code into the kernel anyway?

If yes, I'd argue it might as well be in cfg80211 instead of the
driver(s).

> I guess that could be considered reasonable approach for the existing
> HT and VHT cases and new attributes would obviously be significantly
> easier to introduce with new extensions (need to remember to do this
> for HE from the beginning..).

Indeed. I'll try to also remember :)

> The parsing for these HT/VHT enabled/required is a bit strange
> combination having to go over three IEs. I'm not sure a parsing
> function to do so would be that nice.. The parsing code could indeed
> be moved to cfg80211 so that it would not need to be duplicated into
> each driver needing this, though.

Right.

johannes
