Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33323 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbdDMOFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:05:42 -0400
Received: by mail-wm0-f51.google.com with SMTP id y18so3995531wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 07:05:42 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
 <20170408183440.GA1900@nanopsycho>
 <1491676621.5800.24.camel@sipsolutions.net>
 <20170408184008.GB1900@nanopsycho>
 <990b5610-a894-b3d2-d3a7-536dfd25adb8@cumulusnetworks.com>
 <1491805089.2455.3.camel@sipsolutions.net>
 <c0b35e6e-e5cb-25f6-7ccf-eec33ba39f3b@6wind.com>
 <1492090170.29526.1.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Message-ID: <28b0d93a-7e96-f7eb-b140-afc9ad429c30@6wind.com> (sfid-20170413_160626_359678_403DC87F)
Date: Thu, 13 Apr 2017 16:05:38 +0200
MIME-Version: 1.0
In-Reply-To: <1492090170.29526.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 13/04/2017 à 15:29, Johannes Berg a écrit :
> On Thu, 2017-04-13 at 15:27 +0200, Nicolas Dichtel wrote:
>>
>>> Yes, some - very few - families still insist on using attribute 0,
>>> perhaps parsing by hand or so. Like you say though, the entire
>>> infrastructure makes that hard and undesirable, so I don't really
>>> see
>>> why we need to invest the extra code/work into making it work
>>> *here*,
>>> especially since it's such a corner case as I described in my other
>>> email.
>>
>> Here is an example:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co
>> mmit/?id=31e20bad8d58
>>
>> I also see one in openvswitch (I will send a similar patch), but
>> there are probably some others.
> 
> Yeah. I'm not really sure what the point of such a patch is though -
> the API is set now, and can't really be changed.
The goal is to avoid copy and paste error, like it was done in diag subsystem.

> 
> Anyway, the ones you point out are only used for *output* by the
> kernel, so wouldn't be affected by any "missing attribute" reporting
> anyway.
Sure. It was just to mention that attribute 0 exists somewhere.
The other 0 attribute is OVS_TUNNEL_KEY_ATTR_ID. But I agree with you that it
remains a corner case.

Nicolas
