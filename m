Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58701 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GLHeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 03:34:22 -0400
Received: by vbbff1 with SMTP id ff1so1309878vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 00:34:21 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Jul 2012 10:34:21 +0300
Message-ID: <CAOzdAZRhMJ2pmidGCFLD6_LFvg5KY9SS64ub2uFyfYtw7sLvCw@mail.gmail.com> (sfid-20120712_093426_899072_B04425C9)
Subject: BUG in compat-2.6.28.h
From: Yaroslav Petrov <joy4eg@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, i have found a bug in file compat-2.6.28.h, here is it:

/home/userx/wifi/compat-wireless-2012-07-03/include/linux/compat-2.6.28.h:35:57:
warning: "defned" is not defined
/home/userx/wifi/compat-wireless-2012-07-03/include/linux/compat-2.6.28.h:35:63:
missing binary operator before token "("

Solution:
On line 35 file compat-2.6.28.h
Replace
#if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) ||
defned(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
On
#if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) ||
defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)

compat-wireless version:
[i14]~userx/wifi/compat-wireless-2012-07-03/ #tail .compat_*
==> .compat_autoconf_compat-wireless-2012-07-03-2-2-g40ec2b6 <==

==> .compat_base <==
compat-2012-07-03

==> .compat_base_tree <==
linux-next.git

==> .compat_base_tree_version <==
next-20120703

==> .compat_version <==
compat-wireless-2012-07-03-2-2-g40ec2b6

--
Yaaroslav Ivanov
