Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:41858 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeACVQL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 16:16:11 -0500
Received: by mail-pf0-f180.google.com with SMTP id j28so1244595pfk.8
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jan 2018 13:16:11 -0800 (PST)
Subject: Re: [RFC 0/4] EAPoL over NL80211
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20171228175832.3253-1-denkenz@gmail.com>
 <5A460B01.7060603@broadcom.com>
 <186d4469-fffb-45b2-1ea7-53a4eaf1c966@gmail.com>
 <1514899630.2024.2.camel@sipsolutions.net>
 <CAF7Mx6q+y5R4uPwXEERMSL-_8pUqBcWGr5V7ORJQiMFy_s4PEg@mail.gmail.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <4463eda0-f014-297e-4164-0a13df1b0997@gmail.com> (sfid-20180103_221616_044729_5F0ADAD3)
Date: Wed, 3 Jan 2018 15:16:09 -0600
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6q+y5R4uPwXEERMSL-_8pUqBcWGr5V7ORJQiMFy_s4PEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 01/03/2018 02:24 PM, Arend Van Spriel wrote:
> On Tue, Jan 2, 2018 at 2:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Fri, 2017-12-29 at 12:29 -0600, Denis Kenzior wrote:
>>
>>> Agreed, requiring both attributes is less than ideal, but I tried to
>>> make the initial RFC as minimal as possible.  It also helped that iwd
>>> uses SOCKET_OWNER by default.  What can be done is to always set
>>> conn_owner_nlportid and introduce another flag that would indicate
>>> whether 'connection tear-down on application exit' was requested.
>>>
>>> However, my opinion is that the current SOCKET_OWNER behavior should
>>> just be made default, especially for control port over nl80211
>>> connections, even if SOCKET_OWNER was not requested.  Once the
>>> controlling application dies, there's no hope of salvaging the
>>> connection, perform rekeys, etc.
>>
>> I think we should keep both attributes; it's better to be explicit that
>> both are needed than to set socket-owner automatically.
> 
> As I see it the problem is that SOCKET_OWNER behavior is actually two
> behaviors wrapped in one, ie. 1) make notifications unicast, and 2)
> tear-down on socket disconnect. So what is the reason for requiring
> this attribute. In the cover letter you mention it is for unicast
> notifications, but above you seem to put more weight in the tear-down
> behavior. From earlier discussion I recall that multicast netlink
> messages may not be received. Is that the reason for opting for
> unicast here. If so, I would suggest to mention that in the commit
> message.
>

There are several ways I could have implemented EAPoL over NL80211 
notifications:

1. Multicast it to the wide world
2. Setup a registration framework ala CMD_REGISTER_FRAME or 
CMD_UNEXPECTED_FRAME
3. Assume frames should be unicast to the process that initiated CMD_CONNECT

I see no good reason why anyone would want option 1.  Option 2 seemed 
pointless.  Only the supplicant daemon (e.g. iwd or wpa_s) would really 
want to process these anyway.  Is this the reasoning you want me to 
include in the cover letter?

The simplest way of accomplishing 3 was to reuse the conn_owner_nlportid 
member that the kernel stores in the case that SOCKET_OWNER attribute is 
used.  iwd always uses this by default and quite frankly in the case of 
EAPoL over NL80211 it doesn't make sense to not use it, at least to me. 
Without SOCKET_OWNER, if the supplicant daemon dies you have an 
un-managed, dangling connection.

>>> The biggest issue was that each driver defines a set of management
>>> frames it can accept via this mechanism.
>>
>> I'm not sure this is "the biggest issue", but I tend to agree with
>> keeping them separate.
> 
> Yes. Seems like dealing with mgmt and data adds quite a bit of
> complexity and/or redesign.
> 
> Just another note. In the cover letter it is mentioned that
> eapol-over-nl80211 solves some long standing races. Now the example
> mentioned is indeed one for which wpa_supplicant temporarily stores M1

yes, this race has to be taken care of by the supplicant.  We have 
similar workaround in iwd which I would love to get rid of.

> or at least that is what I suspect you are referring to. Another
> issue, for which we have a hack in brcmfmac, is a race between
> installing the keys through nl80211 and M4 being passed through the
> netdev which can result in M4 being sent out encrypted. Not sure if
> your discussion about DONT_CRYPT is about that.

This is really a kernel issue being bled out into userspace.  Many 
drivers seem to suffer from this race.  I think Ben had a thread some 
time in June about this as well.  But yes, I believe the main impetus to 
add a DONT_ENCRYPT flag for EAPoL frames sent over NL80211 is to fix 
this along with supporting weird protocols that explicitly want to be 
sent unencrypted.

Regards,
-Denis
