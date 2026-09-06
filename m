Received: from outbound.pv.icloud.com (pv-2001j-snip4-11.eps.apple.com [57.103.64.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD1236493A
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788731704; cv=none; b=JK5ioitIgaC9xWj92PGoXgagzrTLxHj5nsRt5kS6CxNSJHL4xU69pJRW0ulzjkZCS7/9dq2OHkOJYg5jYkYc0jO+/lHn5F+YVetpZiUvBv+7jkZScaCuzzfImwUUdscyte1u3NatLqREYUAp7MKM3T15brJD2k5uhRb7Iz440a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788731704; c=relaxed/simple;
	bh=iKW1JsyQGxnc/97y3hZUPLq2rPMCubvlEIMucDmaJro=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=nTFglFfQVS3sbWDlKgTRdxXWvMc2+gUBl4Ebu9bv+Ixhi3IBpxKmcd+RsTyg6xm/GcnzBJt+qay5Ln2dfUguT1ugavujX+dpeZjF0kjpwd9B5kKo2ykNmQhUADYdlXYpjorpplU6mDe7P7pG+j6Bp0gIzw5pab3shYyT9MY4iFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com; spf=pass smtp.mailfrom=me.com; dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b=haNw6wY5; arc=none smtp.client-ip=57.103.64.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=me.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b="haNw6wY5"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-10 (Postfix) with ESMTPS id 26F6C18000BC;
	Sun, 06 Sep 2026 21:54:59 +0000 (UTC)
X-ICL-RepId: 01a078b7-b368-78f6-a298-8a878e720aea
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ5LHVwCWRxCCEgdXgJLVxQEFFUMdwZXXloXXk1RDw8dXFZQAlpLQBMEShMFUgddTVYNRw9YHlwUFwhFQ14IXh9MHB0OWAYSAE0KDjYGWQVeCVYDQwU2EhRdRV4IGQhdHRkVWgkKVwM1ekgEL3JdHzMMTwFAAy4KRRRAcFt1RgdFAU8GVAAvCkEBTnMAUkVRH1RGExlOG1dNUBtfAkIP
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1788731702; x=1791323702; bh=HuSPwl7gP5qYGb4NJVZ+R1TGpTKHE9OkhXR3Dzyl8Po=; h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To:x-icloud-hme; b=haNw6wY51+w9bWzP0GHI+N/GXl2G86lSQNPiVrzccbgNFyhm3kQCJUEkTS0UwmGq7FNbTTPWx9uGnoapfF3fqss+DTomnKSPv7s1aAbeBLBY+tKteGaTJvbzNd+wyiJpI44BrPRCxW4ISq6PMeDO+X1PqLP1/cqZZe1nFGwOM+pgM5sWqjEkXaG69lB9Gfr3P5/vmKZshXpl4C5uo7HZBTMF6Lkz+lecWt4S8yMUSG6wBF4dC/WNm4qYgBm+ONZJmCtGzup5z/bUWbsz2Q6P/trmeef0ccrH7SI5zrekcqpHCQ+RrKJQKvBIiIxU+y3+AbvntFTWCrw0ESMxXOoQ/Q==
Received: from smtpclient.apple (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-10 (Postfix) with ESMTPSA id 2F4781800146;
	Sun, 06 Sep 2026 21:54:59 +0000 (UTC)
From: Luis Albisu <lfa@me.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: [BUG] wifi: rtw88: WARN_ON storm from rtw_get_channel_group() - 5GHz
 channel 163 missing from switch
Message-Id: <1EC07BE6-C572-4E85-8C6B-5587597D8186@me.com>
Date: Sun, 6 Sep 2026 17:54:47 -0400
Cc: Ping-Ke Shih <pkshih@realtek.com>
To: linux-wireless@vger.kernel.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Proofpoint-ORIG-GUID: UBYQ6SVd3N-_W28FwR9ZAxxef12Mqmmw
X-Proofpoint-GUID: UBYQ6SVd3N-_W28FwR9ZAxxef12Mqmmw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI0NiBTYWx0ZWRfX6KIIfaw+ajGP
 hf01rll8+c8IV+ARS+m0T5D3UpZk6BjftTLzSN/PccA2B/grfmFKBOmMzvxxoTGxajsRI1MFi2z
 xxtO84Qd7MgrM6whhfJBHJTB1K4pqGSK9lVTTPxjVqTrIH/hoWiPI+VHrlPMfa3yKAtHNS6qwfq
 8nyaR4bSNVVBqJYj6jX7vezlMrgSdKLe7EPvsup6NNKX/az7sf8OUre018TvqVWLVC6JHT8q8hn
 lEeeAh8ryAgPV8qDI1w9L4iuA2E0ZDmifWvqj5UbYHIV6VicEf6vXUs5OsuyxY68o69g1Q0nDZp
 XKwqinmFVEwFsd4gOYHDdzrDc0bJ02i3R74wXdOjZk5MB64qa40Ac3T3HXHJ8w=
X-Authority-Info-Out: v=2.4 cv=criWUl4i c=1 sm=1 tr=0 ts=6a9de134
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=mGY5EbcxwKcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=W9F3IG1dZ-kh2J9wOSEA:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAAB1iEfbVqYjlYtsXZWDRssQOv3JnWSqG6efd5fXbS6tSrVR+cczQmvVOrw3QSAdpETYwrIp8DIkR2pCJXKZzSmwuEbDXIL/JHaDWwT00kSGkzBa1/r18q5p5H/F+lZqy/BiNTY3nE9SlwVU2bX5c14iGtQpESvDtUsC1AHzX3porbRkpA911kSSeUssaWVG6WyOD8K6fJXvtHa9knqSzRL2TQ9dbwhp2tZlCMJKNg6KZ+xmDzx0fksf/NsZ52/cm8zG6EL/WadjiQsIxA2+k+ryx87KmJWiMRPODQamDlDiGj0e4W2DueADvZIYFzcp3HdbNGfWLqupuPcR0RWWX4kILlQCEtdfiSjih6y/o4cdEpizC9kK7ebH6Z10L5NiRxfEtQLcZYeYqI3YDs1ErN3uFZsjMpVRvWNJyg5oIdbzPhp4OZHacOfbQUFKhxjZ/a494e9F/GgK0gP4ASIPjU2GeWJFTBNTIGgnJgv87cIjCVN0fm+QFVl7C/uskN3l8FCd/NaF+Gn2Hg2dpDe133n9vMbiVb0AtQTUBFnld7KFnpAp9Li9WjCRg3KhB4UENJOkeOWtP6j2gzZRgfodiC0iEpbJlask/hNwvBTswmsMLC9yADxvSimDZ39sVZTDxsO9ug7R1v4KtDj9CKRIn11T83p/KEoNXvlUsGSqBdkLiVcT3SQz6LOgsVZYKdQjeKgbQ+T/aM1TSC7xuXFrs19U7/YqadpEyXi6nhqfDuBw5m83z7o5JiBIBOxRasU89Av0Z9QdBeArh8UUejza5MrE7Td6+scAI/22SK7SbeY+21+4NKEddjqlg8CXrf/C3+yuVyfEahKTW/8dTWooGQQRO+n19UXzxVYRUkxQY6PhxlMbrDfuOGB+8+U7PwC9dHhGMtYOf6oGqsJaHynF5l24/ovzdDPwkhzS+vpgcdLoK/Flj/lE3gg4l4ZxBWgXQQGMOc3XSN6e30uNYnTjYcVlZ5
 wzZ43uQwj4YPjep4c/qbcCG+jIpmeu/L9V3CTPWtUg9QQUhdtpt0o95nGjTz9z0cQbWhXrWDhRWQJTWh+jGH8Z29bQDpQcNKz+MbZzWMX5/rfCVA4eHDX/z52AhHNh0zLIUPxd86XxdEjQ7cjFP7Qgkf7zYHiLK95WHVgipm5ulNVMtf7LveDeJ6V4Gdmw6ZDAT/pH/+JJ0klbFBsUSEFEYJBPGYcgPU60bxBa734OfmAMzKKNx6mvd2eYuhsFwYgJ6NMt/hjjMvEUwWNkdvPok9PWMoEOQZn15+9MIJ2xbkzSl2YynvoELpGR+omLxXWaZ9TZCGWD3CUC+YvteMAeC+Fq+w2

Hi,

This report was generated by Claude Code after it addressed an issue it =
found on one of my machines. =20

It suggested I submit this since it might be of interest.
=20
Thank you for developing and making this code available and I hope this =
is helpful!

Sincerely,

LFA

On 6.18.29 an RTL8821AU in monitor mode produces a WARN_ON backtrace on
every channel hop that lands on 5GHz channel 165 with HT40, at roughly
152 warnings per visit. Over a day this wrote 2.8 GB of journal on the
host and cut log retention from ~15 days to ~1.5. Not fatal, but it
taints the kernel and buries every other log line.

Hardware / software
-------------------
Adapter:  Alfa AWUS036ACS, USB 0bda:0811
          "Realtek 8812AU/8821AU 802.11ac WLAN Adapter"
Driver:   rtw88_8821au / rtw88_8821a / rtw88_88xxa / rtw88_usb / =
rtw88_core
Kernel:   6.18.29+rpt-rpi-2712 #1 PREEMPT Debian 1:6.18.29-1+rpt1, =
aarch64
Machine:  Raspberry Pi 5 Model B Rev 1.0
Regdom:   country US (DFS-FCC); relevant range (5730 - 5850 @ 80)
Consumer: Kismet, monitor VIF, channel_hop_speed=3D1/sec

Reproduction
------------
Put the adapter in monitor mode and set the channel to 165 with HT40
(Kismet's linuxwifi source does this automatically as part of its hop
list). Every such hop emits the backtrace below. Channels 1-11, 36-64,
100-144, 149-161 are all clean; only hops involving 165 warn.

I isolated it by sampling `iw dev wlan1mon info` every 150 ms for 60 s
and joining the samples to warning timestamps. All 152 warnings in that
window fell in the two sample windows adjacent to the single visit to
channel 165. A visit to channel 161 at HT40 in a cycle that did not
include 165 produced zero warnings, as did every 20 MHz and 80 MHz
visit to every other channel.

Removing 165 from the hop list stops it completely: 480 warnings per
10 minutes before, 0 across three separate 10-minute windows after.

Backtrace
---------
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1058727 at =
drivers/net/wireless/realtek/rtw88/phy.c:1876 =
rtw_get_tx_power_params+0x3c4/0x940 [rtw88_core]
CPU: 0 UID: 0 PID: 1058727 Comm: kismet_cap_linu Tainted: G        W     =
      6.18.29+rpt-rpi-2712 #1 PREEMPT  Debian 1:6.18.29-1+rpt1
Tainted: [W]=3DWARN
Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
pc : rtw_get_tx_power_params+0x3c4/0x940 [rtw88_core]
lr : rtw_phy_get_tx_power_index+0x44/0x1c8 [rtw88_core]
x29: ffffc0008955b2d0 x28: 00000000000000a3 x27: 0000000000000004
x26: 0000000000000000 x25: 00000000000000a3 x24: ffffc0008955b333
x23: ffff800141082080 x22: 0000000000000001 x21: 0000000000000004
x20: ffff800141082040 x19: ffff800141082040 x18: 0000000000006640
Call trace:
 rtw_get_tx_power_params+0x3c4/0x940 [rtw88_core] (P)
 rtw_phy_get_tx_power_index+0x44/0x1c8 [rtw88_core]
 rtw_phy_set_tx_power_level+0xf4/0x180 [rtw88_core]
 rtw_set_channel+0x120/0x168 [rtw88_core]
 rtw_ops_config+0x9c/0xf8 [rtw88_core]
 drv_config+0x3c/0x148 [mac80211]
 ieee80211_emulate_add_chanctx+0x4c/0x78 [mac80211]
 ieee80211_add_chanctx+0x58/0x190 [mac80211]
 ieee80211_new_chanctx+0x44/0xd8 [mac80211]
 _ieee80211_link_use_channel+0x378/0x3e8 [mac80211]
 ieee80211_set_monitor_channel+0xac/0x1e0 [mac80211]
 cfg80211_set_monitor_channel+0x7c/0x190 [cfg80211]
 __nl80211_set_channel+0x218/0x358 [cfg80211]
 nl80211_set_wiphy+0x33c/0xc28 [cfg80211]
 genl_family_rcv_msg_doit+0xe8/0x160
 genl_rcv_msg+0x228/0x2b8
 netlink_rcv_skb+0x68/0x140
 genl_rcv+0x40/0x60
 netlink_unicast+0x344/0x3c8
 netlink_sendmsg+0x198/0x3f8
 __sock_sendmsg+0x64/0xc0
 ____sys_sendmsg+0x26c/0x2a8
 ___sys_sendmsg+0xb8/0x120
 __sys_sendmsg+0xa4/0x110
 __arm64_sys_sendmsg+0x2c/0x40
 invoke_syscall+0x4c/0x100
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x38/0x120
 el0t_64_sync_handler+0xa0/0xe8
 el0t_64_sync+0x198/0x1a0
---[ end trace 0000000000000000 ]---

A second variant appears interleaved with the above, same call path, at
phy.c:2193 / rtw_get_tx_power_params+0x5a8/0x940. In a 60-second sample
the split was 80 warnings at :1876 and 72 at :2193.

Suspected cause
---------------
x25 and x28 both hold 0xa3 =3D 163. Channel 163 is not a hop target - it
is the 40 MHz centre channel of the 161+165 bond (5815 MHz), which is
what rtw_set_channel() ends up looking up.

rtw_get_channel_group() appears to omit 163 from its 5GHz switch while
covering the rest of the band in steps of 2:

  ... 149, 151, 153, 155, 157, 159, 161, [163 absent], 165, 167, 169,
  171, 173, 175, 177

Every other value in that run is present, so this looks like a single
missing case label rather than a deliberate exclusion. An unlisted
channel hits WARN_ON(1) and falls through, returning group 0, so the
tx power index is also silently wrong for that centre channel.

I have not built a patched module to confirm, and I read the switch via
a source listing rather than from a local tree, so please treat the
exact cause as a suggestion - the trace and the reproduction are the
solid parts. If adding `case 163:` alongside 161/165 is the right fix I
am happy to test a patch on this hardware.

Impact
------
Any monitor-mode user (Kismet, airodump-ng, tcpdump) whose hop list
includes channel 165 with HT40, on any regulatory domain permitting
5730-5850. Reception on 165 still works; the damage is log volume, the
kernel taint, and an incorrect tx power group for that centre channel.

Thanks,

