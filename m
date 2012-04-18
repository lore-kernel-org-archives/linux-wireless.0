Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2DROa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:30:59 -0400
Message-ID: <4F8ED023.2050605@sipsolutions.net> (sfid-20120418_163103_972865_08E014B2)
Date: Wed, 18 Apr 2012 07:30:59 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net> <1334093378.16897.62.camel@aeonflux> <20120411070514.GB17779@aemeltch-MOBL1> <1334714841.3725.37.camel@jlt3.sipsolutions.net> <20120418112017.GC19228@aemeltch-MOBL1>
In-Reply-To: <20120418112017.GC19228@aemeltch-MOBL1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 4:20 AM, Andrei Emeltchenko wrote:
> Hi Johannes,
>
> On Tue, Apr 17, 2012 at 07:07:21PM -0700, Johannes Berg wrote:
>>>>>>> I don't get this patch at all. Why am I reviewing some very very basic
>>>>>>> skeleton code when we should be discussing userspace APIs (we have
>>>>>>> already discussed them with a few people years ago), how the AMP is
>>>>>>> going to be managed, how the security handshake is going to work, etc.
>>>
>>> Do we have some outcome from that discussion?
>>
>> This API-defining patch is probably the best we have:
>> http://johannes.sipsolutions.net/patches/kernel/all/2010-10-13-15%
>> 3a24/035-bt3-amp.patch
>
> Thanks for the link. After looking to the patches I think that there are
> some similarities with respect to interface type. As I understood the
> basic idea is the same: create virtual interface. But in your case the
> implementation is really difficult.
>
> Why do we need netlink commands like NL80211_CMD_HCI_AMP_ADD and
> NL80211_CMD_HCI_AMP_DELETE if what we need is to create/delete virtual
> interface which can be done with standard tools with a several lines
> patch to iw:

[...]

That would work, but the plan was to have separate commands because 
those commands create a virtual netdev, which we don't want in this case.

And no, given the lack of userspace tools we never tested these patches. 
I was more of a "write down API thoughts in code" thing.

johannes
