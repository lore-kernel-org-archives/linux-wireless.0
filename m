Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58834 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAIA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:00:29 -0400
Received: by ewy10 with SMTP id 10so1982299ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 01:00:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090731T125828-710@post.gmane.org>
References: <loom.20090731T125828-710@post.gmane.org>
Date: Sat, 1 Aug 2009 09:00:29 +0100
Message-ID: <3ace41890908010100v7c48ce17p69044d1faad44789@mail.gmail.com>
Subject: Re: zd1211rw with MIPS architecture: mysterious behavior with zd1211b
	and AL2230/AL2230S RF Chip
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Mladen Horvat <acid-burn@opendreambox.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:11 PM, Mladen
Horvat<acid-burn@opendreambox.org> wrote:
> Hello again,

> the same stick runs flawless on a x86 pc with kernel 2.6.30.
> as i said, also on the same machine with kernel 2.6.12 and the vendor driver
> this stick works without problems.
>
> perhaps someone has an idea ?

Well, you could mount debugfs and usbmon (follow the instruction at
Documentation/usb/usbmon.txt) and compare the data flow in the working
situation & non-working situation. Try to keep everything else
(software/module/version-wise) the same.

It is a bit unfortunate, but I think only 32-bit x86 (both rw &
vendor) is well-tested; I know the rw driver works on 64-bit x86_64
and the vendor driver does not; it looks like for 32-bit non-x86 it is
the reverse. (or at least, the 2.22 driver works correctly, and the
3.0 driver regressed but still goes a bit further than the rw driver).

Good luck.
