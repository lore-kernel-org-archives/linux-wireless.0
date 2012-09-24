Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58782 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2IXI7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 04:59:53 -0400
Received: by oago6 with SMTP id o6so5164607oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 01:59:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 09:59:52 +0100
Message-ID: <CAPU73_t5_XjvPURXedOJGmfpRKZi9UG=_6rm7DXUBcRMDaqU8w@mail.gmail.com> (sfid-20120924_105956_705423_D4E33403)
Subject: compile error iw on centos 5
From: Anthony Griffiths <neuronetv@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to compile iw in centos5.8 server (command line only). I
have libnl and libnl-devel installed:
]# rpm -q libnl
libnl-1.0-0.10.pre5.5
I've tried 4 different versions of iw*.tar.bz2 but all give compile
errors that i can't resolve. The last one I tried was iw-0.9.1 but
make gives:
]# make
 CC   interface.o
In file included from /usr/include/net/if.h:26,
                 from interface.c:2:
/usr/include/sys/types.h:62: error: conflicting types for ‘dev_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:22:
error: previous declaration of ‘d                 ev_t’ was here
/usr/include/sys/types.h:67: error: conflicting types for ‘gid_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:54:
error: previous declaration of ‘g                 id_t’ was here
/usr/include/sys/types.h:72: error: conflicting types for ‘mode_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:24:
error: previous declaration of ‘m                 ode_t’ was here
/usr/include/sys/types.h:77: error: conflicting types for ‘nlink_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:25:
error: previous declaration of ‘n                 link_t’ was here
/usr/include/sys/types.h:82: error: conflicting types for ‘uid_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:53:
error: previous declaration of ‘u                 id_t’ was here
In file included from /usr/include/sys/types.h:133,
                 from /usr/include/net/if.h:26,
                 from interface.c:2:
/usr/include/time.h:105: error: conflicting types for ‘timer_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:31:
error: previous declaration of ‘t                 imer_t’ was here
In file included from /usr/include/sys/types.h:220,
                 from /usr/include/net/if.h:26,
                 from interface.c:2:
/usr/include/sys/select.h:78: error: conflicting types for ‘fd_set’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:21:
error: previous declaration of ‘f                 d_set’ was here
In file included from /usr/include/net/if.h:26,
                 from interface.c:2:
/usr/include/sys/types.h:235: error: conflicting types for ‘blkcnt_t’
/lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:142:
error: previous declaration of ‘                 blkcnt_t’ was here
make: *** [interface.o] Error 1

There is no iw yum package for centos5 that I can find.
I've been searching google but cannot find a solution to the above
error, thanks for any help.
