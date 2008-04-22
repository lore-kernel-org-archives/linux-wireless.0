Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:10666 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbYDVRu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 13:50:28 -0400
Received: by an-out-0708.google.com with SMTP id d31so617953and.103
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 10:50:27 -0700 (PDT)
Message-ID: <43e72e890804221050i47ba5974i59d89cde55645f4@mail.gmail.com> (sfid-20080422_195116_152830_2ED209BC)
Date: Tue, 22 Apr 2008 10:50:27 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: prism54 regression in current -git
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Roy Marples" <uberlord@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <480DFCB4.3040104@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <480D6CA4.8040205@trash.net>
	 <1208874998.17364.7.camel@localhost.localdomain>
	 <480DFCB4.3040104@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2008 at 7:56 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> Dan Williams wrote:
>
> > On Tue, 2008-04-22 at 06:42 +0200, Patrick McHardy wrote:
> >
> > > The patch "prism54: set carrier flags correctly" makes my
> > > prism54 device in AP mode come up without a carrier, which
> > > in causes IPv6 to not add a link-local address, which in
> > > turn causes radvd (configured to announce routes on that
> > > device) to refuse to start, breaking IPv6 for the entire
> > > network.
> > >
> > > I didn't check whether a carrier is detected once a client
> > > associates, but in any case it seems to me that a device
> > > in AP mode should always indicate a carrier.
> > >
> >
> > Should always indicate a carrier _when it's configured and up_.  If you
> > just go 'iwconfig eth1 mode master' it shouldn't, but if you do:
> >
> > ifconfig eth1 up
> > iwconfig eth1 mode master essid foobar
> >
> > then it should.
> >
>
>  Yes, it was up and running of course. No carrier though.

Good catch. The carrier is set upon a firmware trigger so it is
possible that when in AP mode we don't hit the trigger in firmware. I
left open the possibility for this happening and go figure it happens.
Even if we had docs this probably wouldn't be documented :) I'll try
to cook up an exception patch now.

  Luis
