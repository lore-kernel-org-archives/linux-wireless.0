Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1D3Vle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 17:41:34 -0400
Received: by bwz15 with SMTP id 15so3846111bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 14:41:32 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Apr 2011 17:41:31 -0400
Message-ID: <BANLkTi=OiZu4i7S_N5Y8oiom--N2B3L1Hg@mail.gmail.com> (sfid-20110430_234149_830452_25E4395F)
Subject: bug: implicit declaration error in nightly build compat-wireless-2011-04-29
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After checking linux-wireless.org, I think this is the right place to
report a bug (albiet simple).

I believe there is a missing header file in the nightly build for
compat-wireless-2011-04-29, which pops up when trying to cross-compile
compat-wireless to the arm architecture.  It does not show when
building not cross-compiling.

compat-wireless-2011-04-29/compat/compat-2.6.37.c: In function 'vzalloc':
compat-wireless-2011-04-29/compat/compat-2.6.37.c:350: error: implicit
declaration of function 'vmalloc'

I believe compat-2.6.37.c is missing:
#include <linux/vmalloc.h>

... which fixed my compilation.

- George
