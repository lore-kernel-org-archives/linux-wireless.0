Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:25371 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZELReh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:34:37 -0400
Received: by fk-out-0910.google.com with SMTP id 18so56883fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 10:34:36 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905121024i79f743efo68c858bc0a0939a@mail.gmail.com>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
	 <1241606838.18657.1.camel@maxim-laptop> <1241642056.3289.6.camel@mj>
	 <1241958023.6051.14.camel@maxim-laptop>
	 <43e72e890905101133w2314250s7b95a8c100e83cce@mail.gmail.com>
	 <1241984076.6051.18.camel@maxim-laptop>
	 <43e72e890905101236h2cd24edewae808da384ae48dd@mail.gmail.com>
	 <1242140728.5626.3.camel@maxim-laptop>
	 <43e72e890905121024i79f743efo68c858bc0a0939a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 20:34:31 +0300
Message-Id: <1242149671.5210.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-12 at 10:24 -0700, Luis R. Rodriguez wrote:
> On Tue, May 12, 2009 at 8:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Sun, 2009-05-10 at 12:36 -0700, Luis R. Rodriguez wrote:
> >> On Sun, May 10, 2009 at 12:34 PM, Maxim Levitsky
> >> <maximlevitsky@gmail.com> wrote:
> >> > On Sun, 2009-05-10 at 11:33 -0700, Luis R. Rodriguez wrote:
> >> >> On Sun, May 10, 2009 at 5:20 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> >> > On Wed, 2009-05-06 at 16:34 -0400, Pavel Roskin wrote:
> >> >> >> gdb /lib/modules/`uname -r`/kernel/net/wireless/cfg80211.ko
> >> >> >
> >> >> > I have recompiled the kernel with debugging info.
> >> >> >
> >> >> > This is new backtrace:
> >
> > Ok, here is what I found:
> >
> > The real BUG_ON that fires up is at
> >
> > wireless/reg.c: __set_regdom: BUG_ON(!country_ie_regdomain)
> >
> > Confirmed by replacing it with printk.
> >
> >
> > I attach a beacon sample that triggers this:
> 
> Thanks for that. Was this from wireless-testing? If so as of what SHA1
> sum? Can you provide steps to reproduce? What AP? What card?
wireless-testing, b2382a4aeff07a481ccf860e4f716b48b52e3781

Steps to reproduce is to connect to an AP that transmits a beacon frame
like I attached.
Happens always.

-git NM and wpa_supplicant, running normally.


What AP? I don't know myself.

What card?,  iwl3945


Best regards,
	Maxim Levitsky

