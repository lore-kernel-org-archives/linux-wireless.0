Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:42253 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaLUP15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 10:27:57 -0500
Received: by mail-ig0-f170.google.com with SMTP id r2so4269285igi.5
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 07:27:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5496D6F6.6050001@gmail.com>
References: <1419168328-6114-1-git-send-email-eliad@wizery.com>
	<5496D6F6.6050001@gmail.com>
Date: Sun, 21 Dec 2014 17:27:56 +0200
Message-ID: <CAB3XZEeQJs7pye+SBr-s09gO8crqkbVWJndVKx836QGQcrjKDQ@mail.gmail.com> (sfid-20141221_163241_093072_9DACC0AA)
Subject: Re: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount tested address
From: Eliad Peller <eliad@wizery.com>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 21, 2014 at 4:19 PM, Fred Chou <fred.chou.nd@gmail.com> wrote:
> On 21/12/2014 9:25 PM, Eliad Peller wrote:
>> dot11MulticastTransmittedFrameCount should be updated according
>> to the DA, which might be different from hdr1.
>
> Shouldn't address 1 be used to determine whether the MPDU is multicast?
> From Std-2012 definition of multicast: "When applied to a MAC protocol
> data unit (MPDU), it is an MPDU with a group address in the Address 1
> field."
>
good point. i guess it depends on the meaning of
dot11MulticastTransmittedFrameCount -
multicast frames sent by sta are not multicast frames per se (as they
are sent directly to the AP), but they are destined to multicast
group.

i tried understanding the meaning of this MIB from here (as i couldn't
find clear definition in the spec):
http://tools.cisco.com/Support/SNMP/do/BrowseOID.do?local=en&translate=Translate&objectInput=dot11MulticastTransmittedFrameCount

where it seems to be similar (IIUC) to the way i interpreted it, but i
might got it wrong :)

Eliad.
