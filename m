Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37352 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756443AbdIHPLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 11:11:21 -0400
Message-ID: <1504883478.20347.7.camel@sipsolutions.net> (sfid-20170908_171226_020005_70630A2A)
Subject: Re: [RFC 3/4] mac80211_hwsim: explicitly set netlink parallel ops
 to false
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 17:11:18 +0200
In-Reply-To: <5BB75376-46E0-45F4-8886-C90CEA37CB2B@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <593fec4f-fc0c-4610-b144-35760ee92102@MAIL1.uni-rostock.de>
         <1504880360.20347.0.camel@sipsolutions.net>
         <5BB75376-46E0-45F4-8886-C90CEA37CB2B@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 17:07 +0200, Benjamin Beichler wrote:
> 
> Am 8. September 2017 16:19:20 MESZ schrieb Johannes Berg <johannes@si
> psolutions.net>:
> > On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
> > > The ops field is zero initialized, therefore parallel ops is
> > > already
> > > false.
> > 
> > Therefore this patch is completely pointless?
> 
> Sorry my first message was missing regarding this. My question is,
> whether this is intentionally, and if it is parallel, whether we need
> extensive locking here.

It's basically intentional - not sure parallel_ops even existed when
this was first written, but we can probably use parallel_ops if we want
to.

johannes
