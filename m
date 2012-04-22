Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:47871 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2DVS2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 14:28:37 -0400
Received: from [217.150.252.179] (confino [217.150.252.179]) (Authenticated sender: ordex@autistici.org) by localhost (Postfix) with ESMTPSA id D046CC8E53
	for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 18:28:34 +0000 (UTC)
Date: Sun, 22 Apr 2012 20:29:29 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi warn_slowpath with 3.*
Message-ID: <20120422182928.GA2854@ritirata.org> (sfid-20120422_202844_231348_64CE4858)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

since linux-3.0 (I don't remember if it was the case even before), I'm gett=
ing
this output in dmesg:

[   53.662990] ------------[ cut here ]------------
[   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
intel_unmap_page+0x14b/0x180()
[   53.663047] Hardware name: Latitude E5420
[   53.663066] Driver unmaps unmatched page at PFN ffd1a000
[   53.663091] Modules linked in: usb_storage hid_cherry usbhid uvcvideo
videobuf2_core videodev v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_mem=
ops
iwlwifi mac80211 cfg80211 snd_hda_codec_hdmi snd_hda_codec_idt psmouse
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore
snd_page_alloc ehci_hcd usbcore usb_common
[   53.663106] Pid: 1852, comm: ifconfig Tainted: G        W    3.3.2-pf #1
[   53.663107] Call Trace:
[   53.663109]  [<ffffffff8137dc00>] ? intel_unmap_page+0x70/0x180
[   53.663113]  [<ffffffff8103102b>] ? warn_slowpath_common+0x7b/0xc0
[   53.663116]  [<ffffffff81031125>] ? warn_slowpath_fmt+0x45/0x50
[   53.663119]  [<ffffffff814874e3>] ? _raw_spin_unlock_irqrestore+0x13/0x40
[   53.663121]  [<ffffffff8137dcdb>] ? intel_unmap_page+0x14b/0x180
[   53.663127]  [<ffffffffa015f32c>] ? iwl_trans_rxq_free_rx_bufs+0x4c/0xf0
[iwlwifi]
[   53.663131]  [<ffffffffa016079c>] ? iwl_trans_pcie_start_device+0x17c/0x=
df0
[iwlwifi]
[   53.663135]  [<ffffffffa014dc3d>] ? iwl_load_ucode_wait_alive+0x2d/0x3a0
[iwlwifi]
[   53.663138]  [<ffffffff810579e9>] ? get_parent_ip+0x9/0x20
[   53.663140]  [<ffffffff810579e9>] ? get_parent_ip+0x9/0x20
[   53.663142]  [<ffffffff81057a87>] ? sub_preempt_count+0x87/0xb0
[   53.663144]  [<ffffffff814874e3>] ? _raw_spin_unlock_irqrestore+0x13/0x40
[   53.663147]  [<ffffffffa014c7ee>] ? iwlagn_mac_start+0x12e/0x1f0 [iwlwif=
i]
[   53.663154]  [<ffffffffa010fa66>] ? ieee80211_do_open+0x276/0x6a0 [mac80=
211]
[   53.663158]  [<ffffffffa010dd12>] ?
ieee80211_check_concurrent_iface+0x22/0x1a0 [mac80211]
[   53.663162]  [<ffffffff8139c3c6>] ? __dev_open+0x86/0xd0
[   53.663164]  [<ffffffff8139c63a>] ? __dev_change_flags+0x9a/0x180
[   53.663166]  [<ffffffff8139c7d0>] ? dev_change_flags+0x20/0x70
[   53.663169]  [<ffffffff813f7a8f>] ? devinet_ioctl+0x5bf/0x750
[   53.663172]  [<ffffffff81383289>] ? sock_do_ioctl+0x29/0x60
[   53.663174]  [<ffffffff81383323>] ? sock_ioctl+0x63/0x2b0
[   53.663177]  [<ffffffff8110773e>] ? do_vfs_ioctl+0x8e/0x4f0
[   53.663179]  [<ffffffff81107c38>] ? sys_ioctl+0x98/0xa0
[   53.663181]  [<ffffffff81488022>] ? system_call_fastpath+0x16/0x1b
[   53.663183] ---[ end trace e93713a9d40cd06e ]---


I tried to dig a bit but I didn't really understand how this slowpath warni=
ng
should be interpreted. However the card seems to work fine. I'm experiencing
some kernel panic from time to time, but I cannot understand if it is really
realted to this issue or not.

I hope this output makes sense for someone.

Best regards,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPlE4IAAoJEFMQTLzJFOZFs4sIAIM2WFXNvknP1HiHjvco7g6w
k5pnxiOLl/sm9UDGi/OHwastnAPlHUKG529ECMVxGUXJp7rp1UavqJ8M0tDs7UlD
lRGC/G/lR8L1VWVzqZ1ux90VXpQKLbYlTN30kag61EtGasKdCqn8E7HRfKteIOzF
YQM87zRaIZ+sv8uF3XnT433sxjRFC/2BGxyM6SKrtbYrUlh3KMuAGGrgR+60kstT
z4YnpqmegHjFL03s5GUDUa7Vq5mLnK99LlnYclsjgVIMesHqif/WsZViiGzitziD
zj/3Qk89sNujBsUJLeGoHuXpycvXKSCWFgqyG6Gnb9u9noBRaf/P4K8n6YRheQk=
=QEnQ
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
