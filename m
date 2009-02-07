Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:55519 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZBGUtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 15:49:31 -0500
Received: by yw-out-2324.google.com with SMTP id 5so197053ywh.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2009 12:49:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <498D431A.9000608@impulze.org>
References: <498CC07F.3080800@impulze.org> <1233981671.3652.6.camel@localhost>
	 <498D431A.9000608@impulze.org>
Date: Sat, 7 Feb 2009 12:49:30 -0800
Message-ID: <43e72e890902071249i756af5cfrc15c1f4bc7d48358@mail.gmail.com> (sfid-20090207_214938_746497_1940A153)
Subject: Re: location of binaries and libraries of new wifi tools
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 7, 2009 at 12:15 AM, Daniel Mierswa <impulze@impulze.org> wrote:
> On 07.02.2009 05:41, Dan Williams wrote:
>> Stuff in /bin or /sbin can certainly link to stuff in /usr without
>> breaking.  The only time it breaks is when you're using network
>> mounted /usr and you need the wireless stack to boot the machine and
>> mount /usr.  But then you have to ask yourself, why are you using a
>> network mounted /usr over wifi?  That seems odd.  Somebody turns on a
>> microwave or starts to use a cordless phone and you're hosed.
> Right, point taken. But why should there be a non-working binary in
> /sbin if you don't have /usr mounted. Couldn't we just stick all the
> tools in /usr/{s,}bin then?

So right now the libs I see from /usr/ that our new wireless tools may
use is libnl and openssl (libgcrypt goes into /lib/ at least on my
box), iw is already on /usr/sbin/ and crda can be moved to /usr/sbin/
if that makes everything peachy but just please note the udev rule
will change location, which should be fine, it is just noted.

  Luis
