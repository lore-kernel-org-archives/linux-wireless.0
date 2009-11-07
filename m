Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39747 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZKGMXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 07:23:53 -0500
Received: by bwz27 with SMTP id 27so2014177bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 04:23:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257548493.3752.15.camel@localhost.localdomain>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257548493.3752.15.camel@localhost.localdomain>
Date: Sat, 7 Nov 2009 12:18:07 +0000
Message-ID: <3ace41890911070418v1b0fc540v4f620470a21dfebb@mail.gmail.com>
Subject: Re: Changing from Minstrel to PID
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 11:01 PM, Martín Ernesto Barreyro
<barreyromartin@gmail.com> wrote:
> El vie, 06-11-2009 a las 16:48 -0500, John W. Linville escribió:
>> On Fri, Nov 06, 2009 at 06:29:16PM -0300, Martín Ernesto Barreyro wrote:
>> > Hello, I have a rtl8187 wireless card and I've allways have problems
>> > with the rate control using minstrel. So everytime my kernel updates
>> > (recently it went from 2.30 to 2.31) i have to recompile mi kernel
>> > setting pid as my default rate control algorithm.
>> >
>> > Is there a way to change that without compiling the kernel?
>>
>> No, but I wish there were...patches?  Anyone?
>>
>> John
>
> I've been searching and it seems that it could be added something like
> modprobe mac80211 rc='pid'
>
> Would it be a good idea?

That's a reasonable approach, and it isn't too difficult either -
somebody motivated enough could do a patch...

Hmm, I think I have a question and a suggestion here: what is it you
have problem with minstrel ? I don't care which one but both works
well enough here. Maybe you need that sorted instead.

The other thing is, you can probably patch compat-wireless to do
something similiar or at least experiment with it, as long as your
kernel is configured with most of them as modules. Switching
compat-wireless is quite easy, and particularly with the
'driver-select rtl818x' option you just rebuild about 6 kernel modules
instead of the usual 50+, which makes it quite quick and painless.
