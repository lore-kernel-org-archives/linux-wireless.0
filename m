Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42430 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdIOOwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 10:52:43 -0400
Message-ID: <1505487158.31630.45.camel@sipsolutions.net> (sfid-20170915_165246_474287_9DE6F3C3)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 16:52:38 +0200
In-Reply-To: <b87b61bc-6c29-3a4e-01bd-652cf1eb095c@gmail.com> (sfid-20170915_162734_306435_5EAB8786)
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
         <1505485208.31630.42.camel@sipsolutions.net>
         <b87b61bc-6c29-3a4e-01bd-652cf1eb095c@gmail.com>
         (sfid-20170915_162734_306435_5EAB8786)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-15 at 09:27 -0500, Denis Kenzior wrote:

> > > However, you're not answering my question...
> > 
> > Which was?
> 
> So if we issue CMD_CONNECT with a PREV_BSSID, does/should OPERSTATE 
> still stay UP?

It's difficult to do, but from a higher-layer POV I'd argue that it
should? I'd basically argue that it's no different from 802.1X
reauthentication, and the operstate docs say:

-set interface back to IF_OPER_DORMANT if 802.1X reauthentication
 fails

> > We had intended to have NL80211_CMD_ROAM to make that decision
> > once,
> > but never really used it for that... I think it could be
> > implemented
> > but I don't really know how well drivers were to support it.
> 
> I think it would be nice.  Worst case a driver won't implement it,
> but we can use FT on those that do.

I have no idea how you'd ask them to do FT or just normal reassoc? I
guess they don't really care as long as the supplicant is in the host.

johannes
