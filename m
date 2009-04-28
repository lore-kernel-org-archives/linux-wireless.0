Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52809 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZD1KuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 06:50:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Lykt0-0003rf-Lz
	for linux-wireless@vger.kernel.org; Tue, 28 Apr 2009 10:50:02 +0000
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 10:50:02 +0000
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 10:50:02 +0000
To: linux-wireless@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: "No ProbeResp from current AP" and then nothing more happens
Date: Tue, 28 Apr 2009 12:32:33 +0200
Message-ID: <87ocuhysou.fsf@nemi.mork.no> (sfid-20090428_125016_987218_1BFCC891)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm still configuring my wireless interface manually using iwconfig, an=
d
do not run any management daemons like wpasupplicant etc.  This provide=
s
the basic functionality I'm interested in.

But from time to time, I get the message=20
"No ProbeResp from current AP <ap address> - assume out of range"
and then my connection is dead.  I've found no other way out of this
(using only iwconfig/ifconfig) than trigger a reassociation by
temporariliy configuring different (non-existing) essid.

The wireless network consists of a large number of APs, and there are
always more than one accessible AP when this error occurs.  I suppose
the reason for the probe failure may be a temporary AP failure
(crash/whatever).  However, as you can see from the log below, the erro=
r
condition is permanent after such a timeout - even if the associated AP
become available again.  It does associate with the same AP after
manually triggering reassociation.

I'm currently using the iwlagn driver as you can see, but I've
previously had the same (or similar?) issues with both the ath5k and th=
e
b43 driver.


 -> iwconfig wlan0 essid "bar"; ifup wlan0=20
Apr 28 08:13:10 nemi kernel: [272487.353682] iwlagn 0000:03:00.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Apr 28 08:13:10 nemi kernel: [272487.353857] iwlagn 0000:03:00.0: irq 2=
6 for MSI/MSI-X
Apr 28 08:13:10 nemi kernel: [272487.379825] Registered led device: iwl=
-phy1:radio
Apr 28 08:13:10 nemi kernel: [272487.379853] Registered led device: iwl=
-phy1:assoc
Apr 28 08:13:10 nemi kernel: [272487.379877] Registered led device: iwl=
-phy1:RX
Apr 28 08:13:10 nemi kernel: [272487.379906] Registered led device: iwl=
-phy1:TX
Apr 28 08:13:11 nemi kernel: [272487.395683] ADDRCONF(NETDEV_UP): wlan0=
: link is not ready
Apr 28 08:13:11 nemi kernel: [272487.404641] wlan0: direct probe to AP =
00:22:90:f9:63:b2 try 1
Apr 28 08:13:11 nemi kernel: [272487.407965] wlan0 direct probe respond=
ed
Apr 28 08:13:11 nemi kernel: [272487.407970] wlan0: authenticate with A=
P 00:22:90:f9:63:b2
Apr 28 08:13:11 nemi kernel: [272487.410950] wlan0: authenticated
Apr 28 08:13:11 nemi kernel: [272487.410954] wlan0: associate with AP 0=
0:22:90:f9:63:b2
Apr 28 08:13:11 nemi kernel: [272487.414565] wlan0: RX AssocResp from 0=
0:22:90:f9:63:b2 (capab=3D0x421 status=3D0 aid=3D1)
Apr 28 08:13:11 nemi kernel: [272487.414569] wlan0: associated
Apr 28 08:13:11 nemi kernel: [272487.419542] ADDRCONF(NETDEV_CHANGE): w=
lan0: link becomes ready
Apr 28 08:13:21 nemi kernel: [272497.760019] wlan0: no IPv6 routers pre=
sent

  -> then it works until:
Apr 28 09:51:31 nemi kernel: [278388.088590] wlan0: No ProbeResp from c=
urrent AP 00:22:90:f9:63:b2 - assume out of range

 -> which leaves the interface in a non-functional state until I do:
 -> iwconfig wlan0 essid "foo"; iwconfig wlan0 essid "bar"
Apr 28 10:13:05 nemi kernel: [279681.489584] wlan0: direct probe to AP =
00:22:90:f9:63:b2 try 1
Apr 28 10:13:05 nemi kernel: [279681.492237] wlan0 direct probe respond=
ed
Apr 28 10:13:05 nemi kernel: [279681.492242] wlan0: authenticate with A=
P 00:22:90:f9:63:b2
Apr 28 10:13:05 nemi kernel: [279681.494645] wlan0: authenticated
Apr 28 10:13:05 nemi kernel: [279681.494651] wlan0: associate with AP 0=
0:22:90:f9:63:b2
Apr 28 10:13:05 nemi kernel: [279681.497428] wlan0: RX AssocResp from 0=
0:22:90:f9:63:b2 (capab=3D0x421 status=3D0 aid=3D3)
Apr 28 10:13:05 nemi kernel: [279681.497434] wlan0: associated

I've been trying to get a grasp of what happens here, and am wondering
whether it would make sense to force a scan after a direct probe
timeout?  Could this be done with something like:


diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 132938b..a12c408 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -679,6 +679,7 @@ static void ieee80211_direct_probe(struct ieee80211=
_sub_if_data *sdata)
                 * due to state =3D=3D IEEE80211_STA_MLME_DIRECT_PROBE.
                 * Hence, queue the STAs work again
                 */
+               set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
                queue_work(local->hw.workqueue, &ifmgd->work);
                return;
        }

I'm of course going to test this, but it would help alot if someone
knowing the code could say "that's ridiculous" or "please test".  The
error condition is quite rare, and I guess I'll have to test for weeks
to be somewhat certain whether a workaround really helps or not.


Bj=C3=B8rn

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
