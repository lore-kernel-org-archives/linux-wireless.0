Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:49899 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZA3TWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 14:22:47 -0500
Received: by mu-out-0910.google.com with SMTP id g7so487815muf.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 11:22:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
	 <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
	 <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
Date: Fri, 30 Jan 2009 19:17:35 +0000
Message-ID: <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com> (sfid-20090130_202251_966792_BD60B572)
Subject: Re: rtl8187 wireless issues
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 1:59 PM, P.G. Richardson
<p.g.richardson@phantomjinx.co.uk> wrote:
> Hi,
>
> Have compiled and install the latest driver and success!

Glad to hear.

> Just to answer your questions ...
>
> dmesg didnt offer much information other than "link is not ready"

No, my asking for "dmesg | grep rtl " wasn't for disagnostic purposes.
There are 4-5 variants of the rtl8187b hardware, and they shows
slightly different parts. e.g. mine says:

phy0: hwaddr <address>, RTL8187BvE V0 + rtl8225z2

and yours probably will say 8187BvB with a B at the end, and some
other for the 2nd part. I just like the info for curiosity, since you
have a different rtl8187b from mine.

> Should have explained the detail of "cannot ping". Essentially I take the
> network down doing /etc/init.d/network stop. Change around which
> ifcfg-interfaces start on boot then do /etc/init.d/network start. Thus,
> the default route was always the active interface.
>
> Do not use NetworkManager and use static ip addresses.

NetworkManager gives you the ability to switch interfaces quite easily
and automatically and somewhat painlessly (when it works). If you want
to have multiple interfaces active and working simultaneously, you
need to learn a bit about routing, and do some homework. The issue you
experienced is not specific to wireless but you would have the same
issue with multiple wired ethernet interfaces; and somewhat
irrelevant.

> Anyway, hopefully everything is working.
>
> Thanks for the response. Let me know if you require any more info or would
> like some testing done.

If it breaks or not working well, you can come back :-). What's in
compat-wireless now will eventually end up in mainline, but meanwhile
if you upgrade your kernel and find that you need compat-wireless, it
would be nice to know just for the record that "distribution X is not
quite up-to-date". (some distros like Fedora do selective back-ports
of some drivers or some fixes). Support of rtl8187b in 2.6.27 wasn't
very good, but the changes in wireless-testing/compat-wireless is
gradually being pushed into mainline; what is in compat-wireless today
is mostly 2.6.30 material.

> PS. A minor thing which is probably my fault. I compiled the driver using
> make then ran make install. The latter installed the new mac82011, ifcfg
> and b44 drivers. None of the other specific wireless drivers were copied
> to the kernel update directory. I had to copy the rtl8187 there manually.

That's wierd - are you sure? Compat-wireless is supposed to put the
whole lot (about 50MB of kernel modules, nearly 50 of them) into
updates, although only about 4-5 kernel modules are used for rtl8187b.
