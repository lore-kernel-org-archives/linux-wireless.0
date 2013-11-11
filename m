Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4140 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3KKImg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 03:42:36 -0500
Message-ID: <52809874.6080908@broadcom.com> (sfid-20131111_094239_396893_25BED6EA)
Date: Mon, 11 Nov 2013 09:42:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: interested in py80211?
References: <51D49027.9010803@broadcom.com> (
 sfid-20130703_225725_898124_EAB997AB)
 <1373616129.8205.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373616129.8205.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2013 10:02 AM, Johannes Berg wrote:
>> Ever since my first contact with Python I tend to favor it over other
>> >scripting alternatives so I decided to scratch my itch with that and
>> >another old acquaintance called SWIG. With those I went to create
>> >py80211. A first attempt was to have SWIG create a wrapper API directly
>> >exposing the libnl-3 API, but that did not feel comfortable in a
>> >scripting environment. So the level of abstraction is a bit higher. It
>> >is just in a kick-off state (eg. can only send u32 attributes), but I
>> >decided to push it to github anyway.
> Another approach might be exposing the libnl APIs and then build a
> higher-level library in python. Have you considered that? That might
> make it useful to other users of netlink as well, while keeping a 'nice'
> nl80211 API?

Hi Johannes,

It has been a while that I touched this topic. It is a spare-time 
project and that is somewhat limited. Since then I added genl support to 
libnl python API. I want to extract part of py80211 from nl80211.[ch] 
files. The easy part were the attribute ids and enum values from 
nl80211.h. The hurdle I want to leap know is extracting message layout 
information from nl80211.c. Do the struct nla_policy definitions hold 
all the information or would it be better to get it from the .doit 
callbacks.

Regards,
Arend

