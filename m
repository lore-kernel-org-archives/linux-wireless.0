Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:42440 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZIBVZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 17:25:29 -0400
Received: by iwn6 with SMTP id 6so517100iwn.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 14:25:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <95408c820909021353i5b2d0e5dpeddefcdb5065d724@mail.gmail.com>
References: <95408c820909021353i5b2d0e5dpeddefcdb5065d724@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Sep 2009 14:25:10 -0700
Message-ID: <43e72e890909021425s13784658r342e52eefb7b582d@mail.gmail.com>
Subject: Re: building compat-wireless for other than running kernels
To: Natanael Copa <natanael.copa@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 2, 2009 at 1:53 PM, Natanael Copa<natanael.copa@gmail.com> wrote:
> Hi,
> I'm trying to create a compat-wireless package for Alpine Linux. I get
> errors like this:
> FATAL: Could not load
> /lib/modules/2.6.29.4-vs2.3.0.36.14-ARCH/modules.dep: No such file or
> directory
> This comes from the fact that the package is not for the current running kernel.
>
> It would be nice if modprobe and depmod could respect the KLIB
> variable in makefile. (I have not figured out how to do that for
> modprobe -l)
>
> Alternatively you could define a DEPMOD=/sbin/depmod in the Makefile
> so its possible to override it with: make DEPMOD=: ...

Patches are welcomed. I considered just now added the depmod stuff you
mentioned but remembered that there are also scripts which may use
this on compat-wireless. We could just export it though and then all
the scripts would have access to it -- but note that it means then
that you'd need the Makefile to run certain scripts -- and if you
don't you have to define your own depmod. Because of this I welcome
your patches on this if you test it.

  Luis
