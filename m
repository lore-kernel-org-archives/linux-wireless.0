Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54656 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765493AbXHGRyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 13:54:00 -0400
Date: Tue, 7 Aug 2007 10:51:57 -0700
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070807175157.GB2804@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070730145358.327D.MOKUNO@sm.sony.co.jp> <20070730144726.GA6586@tuxdriver.com> <20070807153150.A867.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070807153150.A867.MOKUNO@sm.sony.co.jp>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 07, 2007 at 04:41:00PM +0900, Masakazu Mokuno wrote:
> 	Hi
> 
> On Mon, 30 Jul 2007 10:47:26 -0400
> "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > Have you tested the both the old and the new wireless-tools on
> > a kernel with your patch applied?  Both 32- and 64-bit versions?
> > Do they all work equally well?
> 
> Sorry for my late reply.

	Don't be sorry, we prefer to be correct than to be quick. You
did a great job, thanks very much for the detailed bug report.

> OK, I tested the following this week:
>   - kernel 2.6.23-rc2 (geoff's PS3 tree)
>      - the patch applied(*1) and unpatched
>       (*1) another patch also applied.  See later section
>       
>   - wirlesstools version 28 and 29 pre22
>      - 64bit and 32bit compiled
>      - iwpriv and iwconfig
>   
> Test 
>   - boot each kernel of two versions (patched and unpatched) on PS3
>   - associate zd1211rw to an access point with wpa_supplicant (64bit
>     compiled)
>   - run 'iwconfig eth1' and 'iwpriv eth1'
>     four versions 
>        wirelesstools v28/32bit, v28/64bit
>        wirelesstools v29/32bit, v29/64bit
>   - compare the outputs

	That's pretty complete.

> As I expected, 32bit iwconfig and iwpriv did not show proper result on
> unpatched kernel, like:
> 
> > [root@localhost wireless_tools.28.32]# ./iwpriv eth1
> > eth1      no private ioctls.
> > 
> > [root@localhost wireless_tools.28.32]# ./iwconfig eth1
> > Warning: Driver for device eth1 has been compiled with version 22
> > of Wireless Extension, while this program supports up to version 20.
> > Some things may be broken...
> > 
> > eth1      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
> >           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
> >           Bit Rate:24 Mb/s   
> >           Encryption key:<too big>
> > [root@localhost wireless_tools.29.32]# ./iwpriv eth1
> > eth1      no private ioctls.
> > 
> > [root@localhost wireless_tools.29.32]# ./iwconfig eth1
> > eth1      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
> >           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
> >           Bit Rate=24 Mb/s   
> >           Encryption key:<too big>

	Ok, that was expected.

> On the patched kernel, 32bit iwconfig and iwpriv showed appropriate
> outputs and were same as 64bit's output:
> 
> > [root@localhost wireless_tools.28.32]# ./iwpriv eth1
> > eth1      Available private ioctls :
> >           set_regdomain    (8BE0) : set   1 byte  & get   0      
> >           get_regdomain    (8BE1) : set   0       & get   1 byte 
> > 
> > [root@localhost wireless_tools.28.32]# ./iwconfig eth1
> > Warning: Driver for device eth1 has been compiled with version 22
> > of Wireless Extension, while this program supports up to version 20.
> > Some things may be broken...
> > 
> > eth1      IEEE 802.11b/g  ESSID:"planexuser"  Nickname:"zd1211"
> >           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
> >           Bit Rate:24 Mb/s   
> >           Encryption key:9741-5654-B44F-7C71-2B3A-F918-1908-431F   Security mode:open
> >           Link Quality=81/100  Signal level=45/100  
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > [root@localhost wireless_tools.28.64]# ./iwpriv eth1
> > eth1      Available private ioctls :
> >           set_regdomain    (8BE0) : set   1 byte  & get   0      
> >           get_regdomain    (8BE1) : set   0       & get   1 byte 
> > 
> > [root@localhost wireless_tools.28.64]# ./iwconfig eth1
> > Warning: Driver for device eth1 has been compiled with version 22
> > of Wireless Extension, while this program supports up to version 20.
> > Some things may be broken...
> > 
> > eth1      IEEE 802.11b/g  ESSID:"planexuser"  Nickname:"zd1211"
> >           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
> >           Bit Rate=24 Mb/s   
> >           Encryption key:9741-5654-B44F-7C71-2B3A-F918-1908-431F   Security mode:open
> >           Link Quality=82/100  Signal level=45/100  
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> So I think SIOCGIWPRIV and SOICGIWSTAT issues were fixed without
> regressions.

	This is pretty much what I was expecting.

> While this testing, I've found another problem for iocompat32. 
> 
> fs/compat_ioctl.c:do_wireless_ioctl() copies the contents of the
> argument of the 32bit ioctls into allocated area.  But it does not copy
> back the contents on the return from 64bit ioctl calls.  So the caller
> would get the unmodified argument even if the ioctl handler modified it.
> For example, SIOCGIWENCODE could not return proper key length to the
> caller, then iwconfig would show the strange result:
> 
> >           Encryption key:<too big>

	Good catch ! I was not aware of that problem.
	That problem would also apply to a few other calls, such as
SIOCGIWRANGE, SIOCGIWSPY, SIOCGIWSCAN, SIOCGIWESSID, SIOCGIWNICKN and
SIOCGIWGENIE. However, for all these calls the problem would not show
up because userspace put the length as the maximum permissible length
and then parsing of the result would stop properly because the
returned data is NUL terminated. You would also miss the flags, but
most people probably did not pay attention to that.
	In any case, this problem need to be fixed.

> The applied patch fixes the issue.
> 
> As I mentioned early in this mail, I did testing showed above with this
> patch and found no obvious issue, but I did not have time/test-suite to
> do comprehensive testing.  Please someone do review this new patch and
> test more.

	The testing you did is pretty much all that's needed. All
ioctls will look the same. SIOCGIWENCODE was a good candidate as you
tested both the length, the pointer and the flags (Security mode).
	As far as I can see, the patch looks great. But, I'm not
familiar with the 64/32 bit conversions, so I may have overlooked
something.

Acked-by: Jean Tourrilhes <jt@hpl.hp.com>

> regards
> 
> --
> Masakazu MOKUNO

	Thanks a lot !

	Jean

