Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47056 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932119AbdDRJln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 05:41:43 -0400
Message-ID: <1492508494.2472.11.camel@sipsolutions.net> (sfid-20170418_114310_883963_FC1C2308)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Stringer <joe@ovn.org>
Cc: Jiri Benc <jbenc@redhat.com>, ovs dev <dev@openvswitch.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        linux-wireless@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev <netdev@vger.kernel.org>, gvrose8192@gmail.com
Date: Tue, 18 Apr 2017 11:41:34 +0200
In-Reply-To: <CAPWQB7FWOcEen3SGyQtW7t2WpDNLE08JEdHeZHmM738J=Rur0g@mail.gmail.com>
References: <20170408174900.12820-1-johannes@sipsolutions.net>
         <20170408174900.12820-2-johannes@sipsolutions.net>
         <20170408183440.GA1900@nanopsycho>
         <1491676621.5800.24.camel@sipsolutions.net>
         <20170408184008.GB1900@nanopsycho>
         <990b5610-a894-b3d2-d3a7-536dfd25adb8@cumulusnetworks.com>
         <1491805089.2455.3.camel@sipsolutions.net>
         <c0b35e6e-e5cb-25f6-7ccf-eec33ba39f3b@6wind.com>
         <1492090170.29526.1.camel@sipsolutions.net>
         <28b0d93a-7e96-f7eb-b140-afc9ad429c30@6wind.com>
         <1492111480.29526.7.camel@sipsolutions.net>
         <CAPWQB7FWOcEen3SGyQtW7t2WpDNLE08JEdHeZHmM738J=Rur0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-13 at 14:44 -0700, Joe Stringer wrote
(something that never made it to the list, due to HTML formatting)
> 
> I think that OVS was doing some more elaborate validation than most
> users, so over time we picked up a bunch of extra parsing code that
> layers on top of nla_parse(). I took a look at trying to broaden this
> and make it useful to other users a while ago, but when I posted
> there wasn't much interest from others on it so I just moved on.
> Maybe it's about time to pick that back up.

Ah, ok. I didn't realize it was actually on top of nla_parse(). Some of
this does seem rather useful though, and having more expressive policy
would seem very useful too - I'd love to be able to express nesting
better, for example.

Also, I think we should - at least with the strict checking that Jiri
is proposing - think about checking the actual size, not just against a
minimum.

johannes
