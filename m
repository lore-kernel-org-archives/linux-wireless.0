Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41914 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdIOOUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 10:20:13 -0400
Message-ID: <1505485208.31630.42.camel@sipsolutions.net> (sfid-20170915_162016_695443_80AAE5A3)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 16:20:08 +0200
In-Reply-To: <9b466254-e9c1-c5e4-c3fd-b881c4c583e9@gmail.com> (sfid-20170915_155043_885561_8E371F43)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
         <1505414172.31630.13.camel@sipsolutions.net>
         <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
         <1505416964.31630.17.camel@sipsolutions.net>
         <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
         <1505418093.31630.21.camel@sipsolutions.net>
         <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com>
         <1505459955.31630.26.camel@sipsolutions.net>
         <ff73f237-71dd-5fde-9c9f-9bc8fce57e76@gmail.com>
         <1505482156.31630.39.camel@sipsolutions.net>
         <9b466254-e9c1-c5e4-c3fd-b881c4c583e9@gmail.com>
         (sfid-20170915_155043_885561_8E371F43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-15 at 08:50 -0500, Denis Kenzior wrote:

> > I thought you meant sending an 802.11 auth frame to the new AP
> > before breaking the connection to the old AP.
> > 
> 
> I mean 802.11-2012 Section 11.5.9.2 type preauthentication.

Yeha, OK.

> And AFAIK the kernel generates a disconnected event as soon as we
> send a CMD_AUTHENTICATE, so not sure how you envision 'your'
> preauthentication working...

That's what I was trying to say - it doesn't. A few years ago we tried
to support that but it's not really possible to do well.

> However, you're not answering my question...

Which was?

> > Well, with full MAC devices you should let the device decide on the
> > BSS?
> > 
> 
> Why? So we can deal with the various ways a vendor firmware can
> screw up?  Besides, you have an asymmetry in the kernel API. 

:)

> One can use regular roaming on a full mac but not FT.

We had intended to have NL80211_CMD_ROAM to make that decision once,
but never really used it for that... I think it could be implemented
but I don't really know how well drivers were to support it.

johannes
