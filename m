Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:33825 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbeACUYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:24:12 -0500
Received: by mail-qt0-f175.google.com with SMTP id 33so3618952qtv.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jan 2018 12:24:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1514899630.2024.2.camel@sipsolutions.net>
References: <20171228175832.3253-1-denkenz@gmail.com> <5A460B01.7060603@broadcom.com>
 <186d4469-fffb-45b2-1ea7-53a4eaf1c966@gmail.com> <1514899630.2024.2.camel@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Date: Wed, 3 Jan 2018 21:24:11 +0100
Message-ID: <CAF7Mx6q+y5R4uPwXEERMSL-_8pUqBcWGr5V7ORJQiMFy_s4PEg@mail.gmail.com> (sfid-20180103_212418_610596_178DDAE0)
Subject: Re: [RFC 0/4] EAPoL over NL80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Denis Kenzior <denkenz@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 2, 2018 at 2:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2017-12-29 at 12:29 -0600, Denis Kenzior wrote:
>
>> Agreed, requiring both attributes is less than ideal, but I tried to
>> make the initial RFC as minimal as possible.  It also helped that iwd
>> uses SOCKET_OWNER by default.  What can be done is to always set
>> conn_owner_nlportid and introduce another flag that would indicate
>> whether 'connection tear-down on application exit' was requested.
>>
>> However, my opinion is that the current SOCKET_OWNER behavior should
>> just be made default, especially for control port over nl80211
>> connections, even if SOCKET_OWNER was not requested.  Once the
>> controlling application dies, there's no hope of salvaging the
>> connection, perform rekeys, etc.
>
> I think we should keep both attributes; it's better to be explicit that
> both are needed than to set socket-owner automatically.

As I see it the problem is that SOCKET_OWNER behavior is actually two
behaviors wrapped in one, ie. 1) make notifications unicast, and 2)
tear-down on socket disconnect. So what is the reason for requiring
this attribute. In the cover letter you mention it is for unicast
notifications, but above you seem to put more weight in the tear-down
behavior. From earlier discussion I recall that multicast netlink
messages may not be received. Is that the reason for opting for
unicast here. If so, I would suggest to mention that in the commit
message.

>> The biggest issue was that each driver defines a set of management
>> frames it can accept via this mechanism.
>
> I'm not sure this is "the biggest issue", but I tend to agree with
> keeping them separate.

Yes. Seems like dealing with mgmt and data adds quite a bit of
complexity and/or redesign.

Just another note. In the cover letter it is mentioned that
eapol-over-nl80211 solves some long standing races. Now the example
mentioned is indeed one for which wpa_supplicant temporarily stores M1
or at least that is what I suspect you are referring to. Another
issue, for which we have a hack in brcmfmac, is a race between
installing the keys through nl80211 and M4 being passed through the
netdev which can result in M4 being sent out encrypted. Not sure if
your discussion about DONT_CRYPT is about that.

Gr. AvS
