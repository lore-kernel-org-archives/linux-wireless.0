Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:49357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYAMKRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 05:17:35 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1814888fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 02:17:33 -0800 (PST)
Message-ID: <9f50a7a00801130217pabe3925w1561aadf10c486b0@mail.gmail.com> (sfid-20080113_101746_644279_FA7CB7CF)
Date: Sun, 13 Jan 2008 04:17:33 -0600
From: "Jerone Young" <jerone@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>
Subject: Re: [ipw3945-devel] iwl3945 driver is still unusable!
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <fmclu6$dvl$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <fmclu6$dvl$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Thinkpad T61. Though I have a feeling your problem could be
your software combination. For kicks could  try Ubuntu 7.10 (even as
just running from a Live CD) and see what happens. I often roam a lot
with my T61, but I do have an Intel 4965 wireless chipset. The Gutsy
Live CD can be found here:
http://www.ubuntu.com/getubuntu/download

I have been using Gnome & Network Manger with WPA2 at home & some
other places without issue (all using DHCP).

Could you try it out and let the list know of the result. You actually
may have found a real bug. Though it seems like other things may be in
the way. So something know nto be somewhat sane and seeing the same
result whould help a lot. So try running the Gutsy Live CD and using
Gnome & Network Manger and see if you see the same results switching
between these networks. This issue could just be the combination of
software you are using...it's worth a shot.

On Jan 13, 2008 3:33 AM, Thomas B=E4chler <thomas@archlinux.org> wrote:
> Some history of this problem can be found here:
> http://bughost.org/bugzilla/show_bug.cgi?id=3D1468
>
> I want to describe my problem here again to get some more people to p=
ay
> attention, as Intel doesn't seem to be able to reproduce this problem=
,
> although it is quite easy and I am not the only one who experiences i=
t.
>
> I will start with my setup: I own a Lenovo 3000 N100, which includes =
a
> Core 2 Duo CPU and an Intel 3945ABG Wireless LAN chip. I am working w=
ith
> Archlinux x86_64 and use wpa_supplicant 0.5.9 (0.5.8 and 0.5.7 in the
> past) combined with autowifi, a small tool that starts dhclient
> automatically once a wireless connection has been established by
> wpa_supplicant.
>
> I am roaming with my Laptop a lot, so I have to switch between networ=
ks
> often. After I had some problems with the driver over half a year ago=
, I
>  figured out this test case:
>
> - Connect to my own WPA network.
> - Tell wpa_supplicant to switch to an open network.
> - Switch to another open network or (if none available) back to my WP=
A
> network.
>
> The first network I use after loading the driver always works fine.
> After some switching networks (always the second or at most third
> network I try to connect to), I don't get DHCP anymore. Sometimes I
> still get a DHCPNAK, but after that, there is no response to my
> DHCPDISCOVER messages. When apppropriate, I assign a static IP and st=
ill
> cannot transmit any traffic. However, I can always reconnect to the l=
ast
> working network (so long-term, the driver works with exactly one netw=
ork).
>
> One of the debug outputs I generated for the bug report (see above)
> suggests that only the first package is transmitted over the link, af=
ter
> that no data is transmitted at all!
>
> This problem persists even if I
> - restart wpa_supplicant
> - unload the driver and the mac80211 stack completely and reload them
> - do both of the above and then suspend to RAM, then resume later and
> try again
>
> This issue is not limited to switching between encrypted and unencryp=
ted
> networks. I am pretty sure that if I connect to my WPA network here a=
t
> home, go to the university and connect to their WPA network, the issu=
e
> persists (however, this is not a practical test case, as there is a 3=
0
> minute walk in between).
>
> These are the test cases I did today (I could get similar results wit=
h
> older kernel versions and drivers):
>
> Linux 2.6.23.13, iwlwifi 1.2.23 from Intel's website:
> - Connect to WPA network succeeds
> - Connect to an open network succeeds
> - Going back to the WPA network: Associates fine, but no DHCP, with
> static IP no traffic can be transmitted
>
> Linux 2.6.24-rc7-gd0c4c9d4 (latest git as of today), included iwl3945
> version:
> - Connect to WPA network succeeds
> - Connect to an open network: Associates fine, no DHCP (same network
> that I could connect to in the last test).
>
> Linux 2.6.24-rc7-gd0c4c9d4 (latest git as of today), iwlwifi 1.2.23:
> - Does not compile!
>
> All these test cases _always_ worked perfectly with the old ipw3945
> driver. Unloading the iwl driver and loading the ipw driver always ma=
kes
> my connection work again. BUT, the ipw3945 driver has been discontinu=
ed
> and does not compile anymore with 2.6.24 (as iwl3945 is considered a
> replacement, which it is obviously not).
> All this means, if I update to 2.6.24 (which I want to, due to severa=
l
> improvements), I have no usable driver for my wireless anymore.
>
> What I need is a solution, meaning either a working iwl3945 version o=
r a
> patch to ipw3945 to compile with 2.6.24.
>
> Thanks in advance for any help or comments.
>
>
> ---------------------------------------------------------------------=
----
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/mark=
etplace
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
