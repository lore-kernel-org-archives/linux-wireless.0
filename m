Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.244])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UNmtlo031855	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 18:49:27 -0500
Received: by an-out-0708.google.com with SMTP id c38so21137ana	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 15:48:54 -0800 (PST)
Date: Tue, 30 Jan 2007 18:48:54 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: Getting dscape running
In-reply-to: <03f001c744c2$9ac897d0$d059c770$@com>
Sender: wireless-bounces@tuxdriver.com
To: Mark Wallis <mwallis@serialmonkey.com>
Cc: wireless@lists.tuxdriver.org, rt2400-devel@lists.sourceforge.net
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301548q2bda029fs9dd1bde06b8cadea@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <03c901c744bd$78281930$68784b90$@com>
 <9e4733910701301441m5da25df8u3390ee9241eb4812@mail.gmail.com>
 <03f001c744c2$9ac897d0$d059c770$@com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

On 1/30/07, Mark Wallis <mwallis@serialmonkey.com> wrote:
> > check out my other post
>
> It would be helpful if you could provide a debug trace as well.
>
> > This is part of what makes working on wireless hard, the pieces are
> > scattered everywhere.
>
> Probably best to move this discussion to rt2400-devel and let us check
> if the problem still exists in our latest CVS. From there, if assoc
> is working fine you can bounce over to the NetworkManager list and go
> from there.

ralink CVS won't build with the current wireless-dev tree.
It tool a little while to check since I had to rebuild my kernel and
turn debugfs on.
I'll try Pavel's suggestions next.

jonsmirl@jonsmirl:/extra/ralink/rt2x00$ make
  CC [M]  /extra/ralink/rt2x00/ieee80211/ieee80211.o
In file included from /extra/ralink/rt2x00/ieee80211/ieee80211.c:13:
include/linux/netdevice.h:406: error: duplicate member 'ax25_ptr'
/extra/ralink/rt2x00/ieee80211/ieee80211.c: In function 'ieee80211_tx_h_rts':
/extra/ralink/rt2x00/ieee80211/ieee80211.c:858: error:
'IEEE80211_HW_SOFTWARE_RTS' undeclared (first use in this function)
/extra/ralink/rt2x00/ieee80211/ieee80211.c:858: error: (Each
undeclared identifier is reported only once
/extra/ralink/rt2x00/ieee80211/ieee80211.c:858: error: for each
function it appears in.)
/extra/ralink/rt2x00/ieee80211/ieee80211.c: In function
'ieee80211_tx_h_sequence':
/extra/ralink/rt2x00/ieee80211/ieee80211.c:947: error:
'IEEE80211_HW_SOFTWARE_SEQUENCE' undeclared (first use in this
function)
/extra/ralink/rt2x00/ieee80211/ieee80211.c: In function 'ieee80211_beacon_get':
/extra/ralink/rt2x00/ieee80211/ieee80211.c:1857: error:
'IEEE80211_HW_SOFTWARE_SEQUENCE' undeclared (first use in this
function)
/extra/ralink/rt2x00/ieee80211/ieee80211.c: In function '__ieee80211_if_config':
/extra/ralink/rt2x00/ieee80211/ieee80211.c:1993: error: 'struct
ieee80211_if_conf' has no member named 'beacon_control'
make[2]: *** [/extra/ralink/rt2x00/ieee80211/ieee80211.o] Error 1
make[1]: *** [_module_/extra/ralink/rt2x00] Error 2
make: *** [default] Error 2
jonsmirl@jonsmirl:/extra/ralink/rt2x00$



>
> Regards,
> Mark Wallis
> rt2x00 Project Admin
> mwallis@serialmonkey.com
>
>
>
>
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
