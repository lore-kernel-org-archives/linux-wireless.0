Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40978 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbdION3W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 09:29:22 -0400
Message-ID: <1505482156.31630.39.camel@sipsolutions.net> (sfid-20170915_152926_419833_E8AB1BA4)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 15:29:16 +0200
In-Reply-To: <ff73f237-71dd-5fde-9c9f-9bc8fce57e76@gmail.com> (sfid-20170915_145045_823652_4B4D42A4)
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
         (sfid-20170915_145045_823652_4B4D42A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-15 at 07:50 -0500, Denis Kenzior wrote:

> > > E.g. if I CMD_CONNECT to AP1, then pre-authenticate to AP2 and
> > > issue a CMD_CONNECT to AP2?
> > 
> > That's not something you can do with full-MAC cards?
> 
> Err, why not?  Pre-Authentication runs over a 0x88c7 protocol.  So
> we should get these just like regular PAE frames.  But forget 
> pre-authentication, one can still force a roam between BSSes within
> the same ESS by specifying NL80211_ATTR_PREV_BSSID.  At least that's
> what the docs say ;)

Oh, you meant that kind of pre-authentication :-)

I thought you meant sending an 802.11 auth frame to the new AP before
breaking the connection to the old AP.

> > And even mac80211 doesn't really support pre-authentication (unless
> > you mean over-the-DS)

> 
> There's only one kind of preauthentication? Are you confusing this
> with FT?

No, see above.

> We use FT-over-Air just fine on mac80211 and on real hardware.  We 
> even have an autotest for this based on mac80211_hwsim.  FT-over-DS 
> should work as well.
> 
> Full macs don't support FT due to lack of 
> CMD_ASSOCIATE/CMD_AUTHENTICATE.  Can we fix that btw?

Well, with full MAC devices you should let the device decide on the
BSS?

johannes
