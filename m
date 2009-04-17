Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:33545 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZDQBYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 21:24:37 -0400
Received: by fg-out-1718.google.com with SMTP id e12so223705fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 18:24:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090416204806.GD25412@ojctech.com>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	<69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com>
	<1239908374.26575.20.camel@johannes.local> <200904162110.05150.mb@bu3sch.de>
	<20090416204806.GD25412@ojctech.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 17 Apr 2009 03:24:20 +0200
Message-ID: <69e28c910904161824t7af6860dxebf3a13069b924d5@mail.gmail.com> (sfid-20090417_032440_550545_29E4FE22)
Subject: Re: [Proposal]TX flags
To: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"G?bor Stefanik" <netrolller.3d@gmail.com>, radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 10:48 PM, David Young <dyoung@pobox.com> wrote:
> On Thu, Apr 16, 2009 at 09:10:04PM +0200, Michael Buesch wrote:
>> On Thursday 16 April 2009 20:59:34 Johannes Berg wrote:
>> > On Thu, 2009-04-16 at 20:47 +0200, G?bor Stefanik wrote:
>> >
>> > > Alternatively, the meanings of the {0,0} and {1,1} cases could b=
e
>> > > switched around (making the {0,0} case more logical, at the expe=
nse of
>> > > the {1,1} one):
>> > >
>> > > TX Flags absent: Use RTS & CTS as needed.
>> > > TX Flags present: {
>> > > RTS=3D0, CTS=3D0: Use RTS & CTS as needed.
>> > > RTS=3D0, CTS=3D1: Use CTS-to-self.
>> > > RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
>> > > RTS=3D1, CTS=3D1: Use neither RTS nor CTS.
>>
>> The first and the last thing let my head explode, because it's not
>> what somebody would expect from such bits. This kind of logic is als=
o
>> used in wext. And it's why I hate wext. "bit0 means x, bit1 means y,
>> buuuuuuuuuuuuuuuut iff both bits are set the whole logic is inverted
>> and whatever..." =A0That complicates _every_ single test of the bit
>> (always need if (bit0 is set but not bit1)) It produces spaghetti co=
de
>> interpreting these bits with lots of branches and special conditions
>> that nobody does understand by reading the code alone. =A0If you can=
't
>> encode your functionality into a boolean, do _NOT_ use bits to encod=
e
>> it. =A0Use integers to encode tristate or quadstate or whatever. =A0=
You
>> essentially _did_ that already, if you look at your bits. You use th=
e
>> two individual bits as 2bit integer value. So why not spell it out a=
nd
>> use an integer field for that information?
>
> G?bor,
>
> I see the point that Michael is making. =A0What do you think? =A0Shal=
l
> we treat it as a 2-bit wide unsigned integer field in the Tx flags,
> instead?
>

IMO that is a good idea, if we accept having non-booleans in a flags
field. In that case, this proposal comes to my mind:
-Define the second and third bits (mask 0x0006) as a quad-state flag
indicating the use of RTS/CTS. So, we can have these values for the
flag (accessible as (TXFlags & 0x0006) >> 1):
0: neither
1: rts
2: cts
3: auto-select (only makes sense when sending & during feature discover=
y).

Also, a proposal for feature discovery:
The userspace can send a packet that consists of nothing but a
"christmas tree" radiotap header, with no payload, but with all fields
and flags set that are known by the userspace app. The response could
be another payloadless radiotap header, copying the bits set by
userspace, but unsetting the ones not supported by the hardware. This
way, the response packet has all flags set that are supported by both
the sender and the userspace app.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
