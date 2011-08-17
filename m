Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58085 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1HTAb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 20:31:27 -0400
Received: by fxh19 with SMTP id 19so2243216fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 17:31:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Panu Avakul <avakulpa@gmail.com>
Subject: bison++ detection (was: Problem Building carl9170)
Date: Wed, 17 Aug 2011 11:44:27 +0200
Cc: linux-wireless@vger.kernel.org, cmake@cmake.org
References: <CAFHVRfdha1e-+E+hTKPv2JAu5ywOkNo+we2k5FUGtdtRDTV4Aw@mail.gmail.com> <CAFHVRfcUANEJpG6y+XYw_6SYFdxGG8S+Zf3YU+6257KQP9P3Pw@mail.gmail.com> <CAFHVRfdetBxqp4DzHPpT--oJAiWX6LgBaz=nhLa8YBB=V_yXxA@mail.gmail.com>
In-Reply-To: <CAFHVRfdetBxqp4DzHPpT--oJAiWX6LgBaz=nhLa8YBB=V_yXxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201108171144.27282.chunkeey@googlemail.com> (sfid-20110820_023130_113656_04DE3840)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, August 17, 2011 03:03:16 AM Panu Avakul wrote:
> Hello, some one in the cmake mailing list point out to me that
> In line 296 of the CMakeCache.txt
> FIND_PACKAGE_MESSAGE_DETAILS_BISON:INTERNAL=[/usr/bin/bison][vbison++
> Version 1.21.9-1, adapted from GNU bison by coetmeur@icdc.fr
> Maintained by Magnus Ekdahl <magnus@debian.org>()]
>
> There is a \n character in it.
> I went to tried use command bison --version and it print out the same
> lines in two separate line and that might be where the parsing problem
> came from.
I don't think that the \n is a problem, because my bison prints lots of
them as well.

$ bison --version
> bison (GNU Bison) 2.4.1
> Written by Robert Corbett and Richard Stallman.
>
> Copyright (C) 2008 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
But apparently, bison++ is not compatible with bison files we use [actually,
the build system kconfig was taken from the linux kernel]. I would suggest to
try the original non-plusplus bison: http://packages.ubuntu.com/natty/bison

Anyway, carl9170 uses cmake's own bison detection script from
/usr/share/cmake-2.8/Modules/FindBISON.cmake
So I guess there should be a note somewhere that the current
FindBISON.cmake does not work with bison++ very well and it
should be able to detect the incompatible bison++ in the
future. 

Regards,
	Chr
