Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:46879 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbXH2STh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 14:19:37 -0400
Message-ID: <46D5B8B9.8000803@telenet.be>
Date: Wed, 29 Aug 2007 20:19:37 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Robert_F=FChricht?= <the_master_of_disaster@gmx.at>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211, iwlwifi and packet injection
References: <20070829161655.7f68542c@doppelhertz>
In-Reply-To: <20070829161655.7f68542c@doppelhertz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reason for the oops is (almost certainly) that iwlwifi
wants to print the mac address.

7568 IWL_DEBUG_MAC80211("enter - id %d, type %d, MAC " MAC_FMT "\n",
7569 conf->if_id, conf->type, MAC_ARG(conf->mac_addr));

conf->mac_addr which is set to NULL before calling add_interface.
in ieee80211_start_hard_monitor
So this will not occur when you don't enable debug. And we should proba=
bly
check for that

In case you don't enable debug, iwlwifi will exit iwl_macc_add_interfac=
e
in the next if statement..

I'm believe that there are still other places where iwlwifi isn't
ready to inject packages into the network though. Would need some
work.

=46or the record, it would have been nice if you had copied the "oops"
in the mail. And that you had tested it on an untainted kernel...
some people really hate that otherwise ;-)

ian

Robert F=FChricht wrote:
> Hi,
>=20
> I wanted to try out packet injection with my ipw3945 card, and was
> thrilled that there are patches by Andy Green for mac80211 that shoul=
d
> make everything that is needed for this possible.
>=20
> So I patched 2.6.23-rc3 with wireless-git's everything branch, but wh=
en
> attemting to inject, Andy's packetspammer (and aireplay -9
> from aircrack-ng 1.0-dev) hung.
>=20
> After reporting this to him and several mails I switched on debugging
> flags, and modprobed iwl3945 with 'debug=3D0x43fff', ifconfig then oo=
psed:
>=20
> modprobe iwl3945 debug=3D0x43fff
> iwconfig wlan0 mode monitor
> ifconfig wlan0 up
> --- OOPS --- (see attachment)
>=20
> When omitting the debug parameter, ifconfig succeeds but the injectio=
n
> tools then hang. SysRq lets me reboot the system, as you can see in t=
he
> syslog excerpt I provided.
>=20
> I attached the .config I am using, the system in question is a Dell
> Inspiron 9400, running Gentoo Linux. Before attempting any of this, a=
ll
> unused processes were killed, leaving only udev, metalog and vixie-cr=
on.
> And yes, I know it says the kernel is tainted, because of the nvidia
> module. Say so and I'll try again without it, but quite frankly, I
> don't think that makes a difference...
>=20
> uname -a:
> Linux doppelhertz 2.6.23-rc3 #2 SMP PREEMPT Wed Aug 29 03:06:47 CEST
> 2007 x86_64 Intel(R) Core(TM)2 CPU T7200 @ 2.00GHz GenuineIntel
> GNU/Linux
>=20
> Thanks in advance for your help,
> Robert
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
