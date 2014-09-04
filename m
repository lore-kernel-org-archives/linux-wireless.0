Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43617 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaIDVJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:09:29 -0400
Message-ID: <5408D509.7010000@candelatech.com> (sfid-20140904_230933_158842_B03E50A6)
Date: Thu, 04 Sep 2014 14:09:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: I cannot disable RTS/CTS on ath9k.
References: <5408B698.6050606@candelatech.com> <CAHNKnsSLmWOeH7i-K1yFESgSU23FwfUv8oTZF-HkW53+8Yn_qg@mail.gmail.com>
In-Reply-To: <CAHNKnsSLmWOeH7i-K1yFESgSU23FwfUv8oTZF-HkW53+8Yn_qg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2014 01:58 PM, Sergey Ryazanov wrote:
> 2014-09-04 22:59 GMT+04:00 Ben Greear <greearb@candelatech.com>:
>> My setup is thus:
>>
>> ath9k station
>> ath10k AP (RTS not enabled)
>> ath9k monitor (on separate machine)
>>
>> I tried enabling (value 1024) and and also disabling RTS on the station.
>>
>> The station was forced to reconnect after setting the RTS value on
>> the phy.
>>
>> But, we sniff RTS being sent by station regardless of the ath9k settings.
>>
>> I verified RTS configured as requested using 'iw phy phy0 info' and looking
>> for RTS.
>>
>> Is there something else that might cause RTS to be sent even when station
>> is not configured for RTS?
>>
> Rate control module can do this. About a year ago there was a
> discussion of this feature of minstrel.

Thanks, that must be this thread:

http://comments.gmane.org/gmane.linux.kernel.wireless.general/84459

I think that explains much of my confusion.  I too would like a way to
really disable RTS for testing.  On a mostly quiet channel, sending UDP
frames one way, I still see lots of RTS/CTS, which must mean there are
lots of retries (assuming Minstel-HT is cause of this).

Not what I wanted to find at this late date in my release cycle :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

