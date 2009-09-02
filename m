Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:38425 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZIBUxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 16:53:33 -0400
Received: by ewy27 with SMTP id 27so1312607ewy.40
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 13:53:35 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 20:53:35 +0000
Message-ID: <95408c820909021353i5b2d0e5dpeddefcdb5065d724@mail.gmail.com>
Subject: building compat-wireless for other than running kernels
From: Natanael Copa <natanael.copa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm trying to create a compat-wireless package for Alpine Linux. I get
errors like this:
FATAL: Could not load
/lib/modules/2.6.29.4-vs2.3.0.36.14-ARCH/modules.dep: No such file or
directory
This comes from the fact that the package is not for the current running kernel.

It would be nice if modprobe and depmod could respect the KLIB
variable in makefile. (I have not figured out how to do that for
modprobe -l)

Alternatively you could define a DEPMOD=/sbin/depmod in the Makefile
so its possible to override it with: make DEPMOD=: ...

Thanks!

--
Natanael Copa
