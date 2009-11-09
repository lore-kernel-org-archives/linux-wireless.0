Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52799 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZKIP51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 10:57:27 -0500
Received: by fxm21 with SMTP id 21so293618fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 07:57:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cec7b3dc0911090411r18a3041cg7b4b0190bc7f68a3@mail.gmail.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257548493.3752.15.camel@localhost.localdomain>
	 <20091107134224.GA25893@tuxdriver.com>
	 <cec7b3dc0911090411r18a3041cg7b4b0190bc7f68a3@mail.gmail.com>
Date: Mon, 9 Nov 2009 15:57:31 +0000
Message-ID: <3ace41890911090757j1446901br89661c50aa2d6937@mail.gmail.com>
Subject: Re: Changing from Minstrel to PID
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:11 PM, Martín Ernesto Barreyro
<barreyromartin@gmail.com> wrote:
> 2009/11/7 John W. Linville <linville@tuxdriver.com>:
>> On Fri, Nov 06, 2009 at 08:01:33PM -0300, Martín Ernesto Barreyro wrote:
>>> El vie, 06-11-2009 a las 16:48 -0500, John W. Linville escribió:
>>> > On Fri, Nov 06, 2009 at 06:29:16PM -0300, Martín Ernesto Barreyro wrote:
>>> > > Hello, I have a rtl8187 wireless card and I've allways have problems
>>> > > with the rate control using minstrel. So everytime my kernel updates
>>> > > (recently it went from 2.30 to 2.31) i have to recompile mi kernel
>>> > > setting pid as my default rate control algorithm.
>>> > >
>>> > > Is there a way to change that without compiling the kernel?
>>> >
>>> > No, but I wish there were...patches?  Anyone?
>>> >
>>> > John
>>>
>>> I've been searching and it seems that it could be added something like
>>> modprobe mac80211 rc='pid'
>>>
>>> Would it be a good idea?
>>
>> Well if you are happy with a module option, we already have
>> ieee80211_default_rc_algo.
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>>
>
> Yes I'm happy, I'll try it.
> Is there any other way that it can be approached?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I suppose echo something into the /proc file system as john suggested
in an earlier post would be even better than a module option. That's a
bit more difficult to module option (module option is pretty much the
blunt hammer and you can replace any behavior with any other bahavor
with it,  I think) as it makes the algorithm switch-able at run-time,
and that might be a little more tricky as one has to probably stop a
few things and restart a few things in the kernel... and I don't mean
debugfs, although since it is already in debugfs it might be easier
just to move that code out to general use.
