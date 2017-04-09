Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34295 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbdDIRnf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Apr 2017 13:43:35 -0400
Received: by mail-pf0-f178.google.com with SMTP id c198so12064385pfc.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Apr 2017 10:43:35 -0700 (PDT)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
To: Jiri Pirko <jiri@resnulli.us>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
 <20170408183440.GA1900@nanopsycho>
 <1491676621.5800.24.camel@sipsolutions.net>
 <20170408184008.GB1900@nanopsycho>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <990b5610-a894-b3d2-d3a7-536dfd25adb8@cumulusnetworks.com> (sfid-20170409_194349_219345_B82CADFF)
Date: Sun, 9 Apr 2017 13:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <20170408184008.GB1900@nanopsycho>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/8/17 2:40 PM, Jiri Pirko wrote:
> Sat, Apr 08, 2017 at 08:37:01PM CEST, johannes@sipsolutions.net wrote:
>> On Sat, 2017-04-08 at 20:34 +0200, Jiri Pirko wrote:
>>> nla_total_size(sizeof(u32));
>>>> +			if (extack &&
>>>> +			    (extack->missing_attr || extack-
>>>>> bad_attr))
>>>
>>> Attr could be 0, right? I know that on the most of the places 0 is
>>> UNSPEC, but I'm pretty sure not everywhere.

perhaps I misunderstand something, but nla_parse suggests attribute type
can not be 0:

int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
              int len, const struct nla_policy *policy,
              struct netlink_ext_ack *extack)
{
	...

        nla_for_each_attr(nla, head, len, rem) {
                u16 type = nla_type(nla);

                if (type > 0 && type <= maxtype) {
			...
                        tb[type] = (struct nlattr *)nla;
                }
        }


> Also, could you please attach a patch to iproute2 for example which
> would make use of this. I just want to make sure it clicks.

I have follow on patches to Johannes' set that plumbs extack for
rtnetlink doit function and iproute2. will send later.
