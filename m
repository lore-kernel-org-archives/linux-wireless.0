Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:37297 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD3C7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 22:59:19 -0400
Received: by mail-ve0-f179.google.com with SMTP id db12so1429625veb.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 19:59:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Apr 2014 19:59:18 -0700
Message-ID: <CAFjWW+Yt5RxZStkyfMgW9j0SV7RX_ZKC4JT9B-8_WbYNmP7RFg@mail.gmail.com> (sfid-20140430_045922_615196_A121FD27)
Subject: Unable to Compile 3.14-1
From: Aaron Hamilton <aaron@logicdatasystems.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In trying to compile backports-3.14-1 with a 2.6.39.4 kernel, I get
the following compilation errors:

backport-include/linux/compat.h:18: error: expected ';', ',' or ')'
before '*' token

If I comment out line 18 in compat.h which just reads "extern int
compat_put_timespec(const struct timespec*, void __user *)", then I
get past that error.

Next, things get stuck on compat/crypto-ccm.c on lines 250 and 255,
stating "too few arguments to function 'scatterwalk_map'" and "too few
arguments to function 'scatterwalk_unmap'". Both of these function
calls pass only one argument, yet my kernel headers define the
functions with two parameters.

I also checked for further references in compat code, but couldn't
find any declarations that map this function properly to one take a
single argument.
