Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36910 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbdDMN1f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:27:35 -0400
Received: by mail-wm0-f41.google.com with SMTP id u2so46823377wmu.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 06:27:34 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
 <20170408183440.GA1900@nanopsycho>
 <1491676621.5800.24.camel@sipsolutions.net>
 <20170408184008.GB1900@nanopsycho>
 <990b5610-a894-b3d2-d3a7-536dfd25adb8@cumulusnetworks.com>
 <1491805089.2455.3.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Message-ID: <c0b35e6e-e5cb-25f6-7ccf-eec33ba39f3b@6wind.com> (sfid-20170413_152739_971156_60C7100A)
Date: Thu, 13 Apr 2017 15:27:31 +0200
MIME-Version: 1.0
In-Reply-To: <1491805089.2455.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 10/04/2017 à 08:18, Johannes Berg a écrit :
> 
>> perhaps I misunderstand something, but nla_parse suggests attribute
>> type can not be 0:
> [...]
> 
> Yes, some - very few - families still insist on using attribute 0,
> perhaps parsing by hand or so. Like you say though, the entire
> infrastructure makes that hard and undesirable, so I don't really see
> why we need to invest the extra code/work into making it work *here*,
> especially since it's such a corner case as I described in my other
> email.

Here is an example:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=31e20bad8d58

I also see one in openvswitch (I will send a similar patch), but there are
probably some others.


Regards,
Nicolas
