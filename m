Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:22870 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbYDCNP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:15:59 -0400
Received: by el-out-1112.google.com with SMTP id v27so1609656ele.17
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 06:15:58 -0700 (PDT)
Message-ID: <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com> (sfid-20080403_141602_246433_5F230782)
Date: Thu, 3 Apr 2008 09:15:57 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX non-WEP frame, but expected encryption"
Cc: "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1207226756.3636.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 3, 2008 at 8:45 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
>  Please copy the mailing list, I've done that now.
>
>
>  > My log files are filling up with these messages:
>  >
>  >        [ 8722.198929] wlan0: RX non-WEP frame, but expected encryption
>  >        [ 8726.506345] __ratelimit: 14 messages suppressed
>
>
> > ./rx.c:                       printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
>
>
>
> > It seems that others who are using Netgear WPN824 access points are
>  > also seeing these messages in their logs.
>  > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1614
>  > http://ubuntuforums.org/showthread.php?t=637084
>  >
>  > I am wondering whether this indicates a problem situation with the
>  > access point that really needs to be reported.  Is this being reported
>  > because it is a security risk?   Is this a condition that really needs
>  > to be reported by wireless drivers?
>
>  Hm. You shouldn't actually be getting this when your AP is configured to
>  use encryption. It either points to somebody trying to invade your
>  network (unlikely) or an AP bug.
>
>  Can you use 'iw' to add a new monitor interface and capture some of the
>  unencrypted packets with that? Use
>
>  $ git clone http://git.sipsolutions.net/iw.git/
>  $ cd iw
>  $ make
>
>  # ./iw dev wmaster0 interface add moni0 type monitor
>
>  and then wireshark/tcpdump on it, you can also send me the dump in
>  private mail if you cannot identify the problem. If you *disable* hw
>  crypto I won't even be able to read your actual traffic :)

Thanks Johannes,

I tried to build iw, but got an error:

# make
 CC   iw.o
/bin/sh: cgcc: not found
make[1]: *** [iw.o] Error 127
make: *** [check] Error 2

After poking around, I found
http://ftp.idilis.ro/mirrors/ftp.kernel.org/pub/software/devel/sparse/news.html
which seems to be where I can find the tool.
I compiled, and (after setting $HOME to /usr) installed it.
Now, when I try to compile iw, I get:

# make
 CC   iw.o
iw.c:9:11: error: unable to open 'netlink/genl/genl.h'
iw.c:9:31: error: netlink/genl/genl.h: No such file or directory
iw.c:10:33: error: netlink/genl/family.h: No such file or directory
iw.c:11:33: error: netlink/genl/ctrl.h: No such file or directory
iw.c:12:25: error: netlink/msg.h: No such file or directory
iw.c:13:26: error: netlink/attr.h: No such file or directory
iw.c: In function 'nl80211_init':
iw.c:23: error: implicit declaration of function 'nl_handle_alloc'
iw.c:23: warning: assignment makes pointer from integer without a cast
iw.c:29: error: implicit declaration of function 'genl_connect'
iw.c:35: error: implicit declaration of function 'genl_ctrl_alloc_cache'
iw.c:35: warning: assignment makes pointer from integer without a cast
iw.c:42: error: implicit declaration of function 'genl_ctrl_search_by_name'
iw.c:42: warning: assignment makes pointer from integer without a cast
iw.c:52: error: implicit declaration of function 'nl_cache_free'
iw.c:54: error: implicit declaration of function 'nl_handle_destroy'
iw.c: In function 'nl80211_cleanup':
iw.c:60: error: implicit declaration of function 'genl_family_put'
iw.c: In function 'get_phy_or_dev':
iw.c:83: error: implicit declaration of function 'strcmp'
make[1]: *** [iw.o] Error 1

Help?

        Miles
