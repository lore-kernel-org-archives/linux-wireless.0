Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:26146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYJXVck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 17:32:40 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1079281fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 14:32:39 -0700 (PDT)
Message-ID: <45e8e6c40810241432q4d25d352g5f7f50961ecc0194@mail.gmail.com> (sfid-20081024_233245_513969_8FBE8B46)
Date: Fri, 24 Oct 2008 14:32:38 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Subject: iw: hanging when doing station or mpath dump
Cc: "Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We noticed that iw hangs after running "station dump" or "mpath dump"
commands.  The expected output is displayed before the hang.  For
example:

# iw dev mesh station dump

...will display stations (if any) and then hang until iw is killed.
According to strace, iw is waiting on the netlink socket like this:

recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0,
groups=00000000},
msg_iov(1)=[{"\24\0\0\0\3\0\2\0C\256\2I\27\20\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096}], msg_controllen=0, msg_flags=0}, 0) = 20
recvmsg(3,

...which never returns.  This seems to be a somewhat recent regression
but we haven't had a chance to look more closely into it so I'm
mentioning it here in case someone has an idea of what could have gone
wrong.  Thanks,

  -Andrey
