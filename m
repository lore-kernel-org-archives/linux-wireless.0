Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:32872 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KKVtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 16:49:07 -0500
Received: by mail-ia0-f174.google.com with SMTP id y32so3996366iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 13:49:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKErNvpyUxNxEMEt6gcVCr_3MTNpHaSU=5yZy2YsYmYOSCJLsw@mail.gmail.com>
References: <CAKErNvpyUxNxEMEt6gcVCr_3MTNpHaSU=5yZy2YsYmYOSCJLsw@mail.gmail.com>
From: Maxim Mikityanskiy <maxtram95@gmail.com>
Date: Sun, 11 Nov 2012 23:48:46 +0200
Message-ID: <CAKErNvq9O5d_vEQnBhD6PSy-gc37UfvhRA4nRh1r=xFSdC98Yw@mail.gmail.com> (sfid-20121111_225051_586117_095B6AE9)
Subject: Re: Need help with RTL8187SE staging driver
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I'm sorry, mailing list rejected my previous letter, I'm resending)

Hello,

I've decided to refactor and improve rtl8187se kernel driver from
staging directory, because it is buggy and lacks some features. It
causes full system freeze after resume from suspend, there are some
typos in interrupt handler that affect logic, it causes OOPS when
rmmoding, it has not rfkill support, it uses private ieee80211 stack
etc.

I'm writing to you, because your address is mentioned in
drivers/staging/rtl8187se/TODO file. Also I'm CCing to linux-wireless
mailing list in hope that there are people that could also help me.

You can clone git repository with modified driver source code here:
git@bitbucket.org:gentoo_root/
rtl8187se-staging.git. At first, I've removed some non-vital features
and dead code from original driver in order to simplify code. Then
I've fixed some bugs and created more clear structure of code. For
now, I did not fully follow Linux kernel coding style, there are lots
of long lines, and I hope to fix that later.

The last commit 84fa3ebfbb2a15ddbe160f4cd9ebfb6f8762750c was a try to
get rid of private ieee80211 stack and to replace it with in-kernel
mac80211. I've done minimal changes in driver to make it use mac80211.
But I faced a problem. After that commit I'm unable to connect to
wireless network. Here is syslog from insmod to rmmod:
http://paste.ubuntu.com/1351816/. Before that commit all things
worked. Also, I've tried to modify kernel rtl8180 driver to make it
work with rtl8187se NIC, but I had the same problem. When I added some
debug output, I saw that rtl8187se_tx() is called after every auth
try, then I saw timeout message, and after that there were three TX OK
interrupts.

Please help me to find source of this problem and to deal with it. I'm
stuck here and I have no idea what causes it.

Thanks in advance,

Maxim Mikityanskiy
