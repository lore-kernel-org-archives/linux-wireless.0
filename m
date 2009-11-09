Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56825 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZKIPqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 10:46:50 -0500
Received: by ewy3 with SMTP id 3so3234403ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 07:46:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911061931.16509.mb@bu3sch.de>
References: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com>
	 <200911061822.17121.mb@bu3sch.de>
	 <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
	 <200911061931.16509.mb@bu3sch.de>
Date: Mon, 9 Nov 2009 16:46:54 +0100
Message-ID: <ba4215e10911090746g58fda2bdte98fca959ab0c466@mail.gmail.com>
Subject: Re: b43: firmware loading problem and sleeping BUG
From: Martin Fuzzey <mfuzzey@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the archives:

On Fri, Nov 6, 2009 at 7:31 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> Your userspace firmware helper (I guess it's not udev on your device?)
> might be throwing crap at the kernel.
>
Yes it is udev (at least for the moment - running on NFS root and
concentrating on kernel stuff)

My problem was that I had _two_ udev rules invoking /lib/udev/firmware.sh
this resulted in a race between them and the kernel sometimes getting the
firmware for the previous request - hilarity ensued!

One of the rules (50-udev-default.rules) was from the upstream udev source
The other (udev.rules) was put there by openembedded.
Have reported this to the OE list.

With that sorted out it all seems to work fine - I haven't done any stress tests
yet though.

Thanks for your help

Cheers,
Martin
