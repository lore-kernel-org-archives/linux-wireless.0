Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:63491 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab3BGUC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 15:02:28 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so2414459wgb.9
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 12:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319014B7731@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319014B7731@sbs2003.acksys.local>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 7 Feb 2013 12:02:06 -0800
Message-ID: <CAG6hwVOEdFoac=TO8AcZVSB4Y15usHRwNkrK3cVWerHTvArO9g@mail.gmail.com> (sfid-20130207_210230_960692_026BC177)
Subject: Re: Mesh regression
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org,
	open11s <devel@lists.open80211s.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ o11s-devel, Chun-Yeow

For once I don't think this regression is my fault :)

$ git log master-2012-06-08...master-2012-09-07  --oneline
net/mac80211/mesh_hwmp.c
4bd4c2d mac80211: clean up mpath_move_to_queue()
2c53040 net: Fix (nearly-)kernel-doc comments for various functions
bdcbd8e mac80211: clean up debugging
7ebfa46 mac80211: fix and improve mesh RANN processing
728b19e {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
3fbf4b7 mac80211: implement the proactive PREP generation
a69cc44 mac80211: implement the proactive PREQ generation
35b3fe1 mac80211: Rename stainfo variable for the more common sta
e3f5d16 mac80211: Remove unused variable

Chun-Yeow, can you please take a look at the PREQ forwarding logic in
the context of Cedric's problem?

On Thu, Feb 7, 2013 at 8:29 AM, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
> My test Platform is:
>
> LAPTOP_A ---------------- MeshGate 1 ---------------- MeshGate2
> 192.168.3.1                  192.168.3.252               192.168.3.253
> 08:00:27:c1:bf:06     Wistron_aa:41:ed              Wistron_aa:40:a8
>                                                 Acksysco_00:2d:ef
>
> The meshgate2 have a mesh interface and a lan interface bridged
> together, and IP address is set on the bridge.
>
> If I run a ping from LAPTOP_A to MeshGate2 and on the same time, I
> launch the following mesh initialization script
>         iw phy phy0 interface add wlan0 type mp
>         iw wlan0 set channel 36
>         ifconfig wlan0 up
>         iw wlan0 mesh join cvtest
>         brctl addif br-lan wlan0
>
> In this case, I get no response from the ping.
> I spied the wireless with airpcap and wireshark:
>         A PREQ frame is sent from the mesh gate but the "sta target"
> field is not set with the other mesh gate. In this frame, the "sta
> target" field is set to the destination mac address (Acksysco_00:2d:ef).
>
> I don't have this default with compat-2012-06-14.
> I have this default with compat-2013-01-07 and compat-2012-09-07
>
> I attach a wireshark capture with the default. The frame #49 is PREQ
> with field target sta address set to MAC address of LAPTOPB.
>
> Do not hesitate to request more information or new test, if necessary to
> understand the default.
>
> Any help will appreciate.
> Best regards.
>
> Voncken cedric



-- 
Thomas
