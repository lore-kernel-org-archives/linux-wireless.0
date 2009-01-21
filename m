Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:60973 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZAUAHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 19:07:53 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1620232ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 16:07:52 -0800 (PST)
Message-ID: <43e72e890901201607h359018eew3bf7f99b5d1b0759@mail.gmail.com> (sfid-20090121_010758_446375_6AD32B00)
Date: Tue, 20 Jan 2009 16:07:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Kyle McMartin" <kyle@infradead.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Cc: "Greg KH" <greg@kroah.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Paul Hickey" <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	"Kyle McMartin" <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090120220810.GE17452@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1232319854.4596.1.camel@localhost.localdomain>
	 <1232404986.3641.2.camel@localhost.localdomain>
	 <20090120000336.GB4018@tesla>
	 <1232433738.3696.3.camel@localhost.localdomain>
	 <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com>
	 <20090120201316.GG19581@tesla> <20090120201613.GA5313@kroah.com>
	 <20090120211630.GJ19581@tesla>
	 <20090120220810.GE17452@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 2:08 PM, Kyle McMartin <kyle@infradead.org> wrote:
> On Tue, Jan 20, 2009 at 01:16:30PM -0800, Luis R. Rodriguez wrote:
>> As Michael pointed out -- its tough, in fact I am not sure how to do this with
>> static inlines. Advice on how to do this is welcomed. I have no clue.
>>
>
> In this case, where a header will be providing a static inline, and you
> need to provide a stub function, and you're unable to test on a typedef,
> you'll have to use a weak function.
>
> kyle@phobos ~ $ cat foo.c
> #include "bar.h"
> #include "compat.h"
>
> int main(void) {
>        int a = 0;
>
>        a = foo(a);
>
>        return a;
> }
>
> kyle@phobos ~ $ cat compat.h
> int __attribute__((weak)) foo(int x);
>
> kyle@phobos ~ $ cat bar.h
> static inline int foo(int a) {
>        return a;
> }
>
> kyle@phobos ~ $ cat compat.c
> int __attribute__((weak)) foo(int a)
> {
>        return a+1;
> }
>
> kyle@phobos ~ $ gcc -Wall -O2 -o foo foo.c compat.c
> kyle@phobos ~ $ ./foo
> kyle@phobos ~ $ echo $?
> 0
>
> Seems to work ok and not whinge about the double definition.

Thanks Kyle, that's pretty neat, unfortunately my compat.c includes
compat.h and since compat.h includes pci.h the compiler nags about the
double header redefinition of foo() where pci.h already has that
present (on those systems only). Essentially I'd need a way for
systems without foo() to define the header line and for systems that
already have it to not add the line. Know any trick for that?

Any particular strong reason to add that pci inline onto FC10 headers?

  Luis
