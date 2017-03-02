Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47712 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754158AbdCBJBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:01:35 -0500
Message-ID: <1488442991.8390.1.camel@sipsolutions.net> (sfid-20170302_100223_948379_58B1B22E)
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Ben Greear <greearb@candelatech.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 02 Mar 2017 09:23:11 +0100
In-Reply-To: <60000eb2-f404-aab7-5493-9b952adb1dde@uni-rostock.de>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
         <20170223120211.22358-2-andrew.zaborowski@intel.com>
         <1488202062.28431.7.camel@sipsolutions.net>
         <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
         <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
         <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com>
         <4549b209-df6c-0eaa-65e6-72562c61bf4b@candelatech.com>
         <4efcd470-86ee-2f3d-bbe2-1d82874edffd@uni-rostock.de>
         <4d3505b9-9714-8ad0-5159-794cb566dc3b@candelatech.com>
         <60000eb2-f404-aab7-5493-9b952adb1dde@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-01 at 18:04 +0100, Benjamin Beichler wrote:
> Am 01.03.2017 um 16:35 schrieb Ben Greear:
> > That is actually not possible. The permanent MAC-Addresses of hwsim
> > 
> > > radios are directly created by there internal ID, which is only
> > > increased for new radios and definitely not reassigned.
> > > 
> > > But I would be happy, if this were possible, since it would make
> > > some
> > > simulation related stuff easier (currently we need to unload and
> > > load
> > > the hwsim module over and over again for every run).
> > 
> > Ahh, you are right.  But you can specify the wiphy name, and then
> > you
> > can use that to query the debugfs to find the MAC addr, and then
> > sync
> > your user-space with that info.
> > 
> > It should also be easy enough to specify the MAC address when
> > creating
> > the radio.
> > 
> > And, you should be able to create virtual STA, AP, etc, with any
> > specified
> > MAC address, so the MAC of the radio really should not matter much?
> > 
> 
> That is another problem ... this won't work currently, since the
> frame
> delivery compares the receiver address with the permanent MAC
> addresses
> of all hwsim phys. I work as an idle task on patch, which makes this
> lookup (currently implemented as linear search) as a hashmap mapping
> an
> MAC to a wiphy struct , including scenarios with differing MAC
> addresses
> of vifs.

That's probably something we really ought to fix :)

johannes
