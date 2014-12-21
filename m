Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56866 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaLUQhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 11:37:37 -0500
Received: by mail-ig0-f176.google.com with SMTP id l13so3160691iga.9
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 08:37:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1419179100.2387.3.camel@sipsolutions.net>
References: <1419168328-6114-1-git-send-email-eliad@wizery.com>
	<5496D6F6.6050001@gmail.com>
	<CAB3XZEeQJs7pye+SBr-s09gO8crqkbVWJndVKx836QGQcrjKDQ@mail.gmail.com>
	<1419179100.2387.3.camel@sipsolutions.net>
Date: Sun, 21 Dec 2014 18:37:36 +0200
Message-ID: <CAB3XZEf41cWUgHSe2O4oWMQxugHUpfgJVmrwr0cA-fNT_KPitw@mail.gmail.com> (sfid-20141221_173744_535213_99327E57)
Subject: Re: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount tested address
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Fred Chou <fred.chou.nd@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 21, 2014 at 6:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-12-21 at 17:27 +0200, Eliad Peller wrote:
>> On Sun, Dec 21, 2014 at 4:19 PM, Fred Chou <fred.chou.nd@gmail.com> wrote:
>> > On 21/12/2014 9:25 PM, Eliad Peller wrote:
>> >> dot11MulticastTransmittedFrameCount should be updated according
>> >> to the DA, which might be different from hdr1.
>> >
>> > Shouldn't address 1 be used to determine whether the MPDU is multicast?
>> > From Std-2012 definition of multicast: "When applied to a MAC protocol
>> > data unit (MPDU), it is an MPDU with a group address in the Address 1
>> > field."
>> >
>> good point. i guess it depends on the meaning of
>> dot11MulticastTransmittedFrameCount -
>> multicast frames sent by sta are not multicast frames per se (as they
>> are sent directly to the AP), but they are destined to multicast
>> group.
>>
>> i tried understanding the meaning of this MIB from here (as i couldn't
>> find clear definition in the spec):
>> http://tools.cisco.com/Support/SNMP/do/BrowseOID.do?local=en&translate=Translate&objectInput=dot11MulticastTransmittedFrameCount
>
> Yeah I can't find a good reference in the spec either - anyone want to
> dig through the flow charts? :)
>
> Btw, since this is ancient code from devicescape, it is possible that
> they only cared about AP mode then - and there there's no difference
> between the addresses.
>
makes sense.

>> where it seems to be similar (IIUC) to the way i interpreted it, but i
>> might got it wrong :)
>
> I think you're probably right - however I wonder if we can stick the
> code elsewhere (like subif xmit?) instead of introducing more
> conditionals here?
>
well, we look for the tx status, so i think it makes sense to leave it here.

Eliad.
