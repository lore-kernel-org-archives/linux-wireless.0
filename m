Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:64887 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZEYHIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 03:08:05 -0400
Received: by fxm12 with SMTP id 12so1113274fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2009 00:08:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090407160812.GA5758@tesla>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	 <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	 <20090407160812.GA5758@tesla>
Date: Mon, 25 May 2009 08:08:05 +0100
Message-ID: <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 7, 2009 at 5:08 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Apr 07, 2009 at 12:49:30AM -0700, Hin-Tak Leung wrote:
>> On Tue, Apr 7, 2009 at 6:34 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>
>> > Not sure, I wanted to get this out to help those who are interested in
>> > porting changes over (if any) to zd1211rw. If you find nothing useful
>> > from it please simply disregard it.
>>
>> It is vaguely relevant in that (1) there are new and old features
>> which are not in the rw driver yet - e.g. the AP mode,  and
>> 3.0 introduces newly antenna diversity, (2) to port changes - either
>> new-hardware related, or bug-fixes/improvements, they need to be
>> proven to work-better ... e.g. blindly copying could just copy
>> mistakes/regressions...
>
> Right, that is the idea.

It has been 6 weeks - I re-visited the code and found a mistake of
mine, and managed to get it to compile against
2.6.29.3-159.fc11.x86_64 and 2.6.28.8 vanila 32-bit . It definitely
does *not* work correctly on x86_64 linux - I get a rather wierd
problem where register-read of the last 16-bit of the mac address from
firmware _apparently_ fails, but it is fed to the next register-read
and the result of the next register-read is received by the
next-next-read, etc. (i.e. the result of a read is received by the
next read).  For 32-bit, it seems to work alright, except for one oop
in AP mode when a client connects so far (out of a few connects).

This is just a head-up that I have a series of diffs to port the
vendor driver forward to current kernels, if anybody wants to have a
look, for side-by-side scavenging to the rw driver. (I probably will
post them to the sourceforge zd1211-dev list after a little look at
that oops)

BTW, anybody has any idea what else is needed for the rw driver to
support AP mode?
