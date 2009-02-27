Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbZB0VHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:07:13 -0500
Subject: Re: mac80211 does transmit frames with stopped queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200902192150.38424.mb@bu3sch.de> (sfid-20090219_215246_765191_79856B6C)
References: <200902192150.38424.mb@bu3sch.de>
	 (sfid-20090219_215246_765191_79856B6C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sw3QYul+2LZ+WqEo0+o8"
Date: Fri, 27 Feb 2009 18:48:46 +0100
Message-Id: <1235756926.7426.81.camel@johannes.local> (sfid-20090227_220717_746799_5BBB564D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sw3QYul+2LZ+WqEo0+o8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-19 at 21:50 +0100, Michael Buesch wrote:
> This is the B43_WARN_ON(ring->stopped) in b43_dma_tx() triggering.
>=20
> [292334.105762] WARNING: at /home/mb/kernel/compat-wireless-2009-02-17/dr=
ivers/net/wireless/b43/dma.c:1314 b43_dma_tx+0x9fc/0xa30 [b43]()
> [292334.105808] Modules linked in: b43 ssb mac80211 cfg80211 [last unload=
ed: cfg80211]
> [292334.105861] Pid: 3143, comm: nfsd Tainted: G        W  2.6.28.5 #7
> [292334.105886] Call Trace:
> [292334.105904]  <IRQ>  [<ffffffff80240b64>] warn_on_slowpath+0x64/0xa0
> [292334.105955]  [<ffffffffa008cf9a>] ccmp_encrypt_skb+0x1ba/0x220 [mac80=
211]
> [292334.105995]  [<ffffffffa009d2bf>] ieee80211_duration+0x1af/0x230 [mac=
80211]
> [292334.106032]  [<ffffffffa0017a3c>] b43_dma_tx+0x9fc/0xa30 [b43]
> [292334.106070]  [<ffffffffa009e19e>] invoke_tx_handlers+0xe5e/0xfb0 [mac=
80211]
> [292334.106104]  [<ffffffffa0001d84>] b43_op_tx+0x74/0xe0 [b43]
> [292334.106141]  [<ffffffffa009e9f6>] __ieee80211_tx+0x56/0x160 [mac80211=
]
> [292334.106180]  [<ffffffffa009f992>] ieee80211_master_start_xmit+0x272/0=
x530 [mac80211]
> [292334.106224]  [<ffffffff8062a70e>] __qdisc_run+0x20e/0x260
> [292334.106928]  [<ffffffff8060c770>] net_tx_action+0xe0/0x130
> [292334.106953]  [<ffffffff80246803>] __do_softirq+0x93/0x160
> [292334.106980]  [<ffffffff8020d49c>] call_softirq+0x1c/0x30
> [292334.107003]  <EOI>  [<ffffffff8020ee45>] do_softirq+0x35/0x70
> [292334.107034]  [<ffffffff802466d5>] local_bh_enable+0xa5/0xb0
> [292334.107060]  [<ffffffff8060e9fc>] dev_queue_xmit+0xfc/0x570
> [292334.107088]  [<ffffffff8067e486>] ip_queue_xmit+0x1f6/0x3e0
> [292334.107114]  [<ffffffff80686cbf>] sk_stream_alloc_skb+0x3f/0x110
> [292334.107140]  [<ffffffff8069151b>] tcp_transmit_skb+0x4eb/0x760
> [292334.107167]  [<ffffffff80693ec0>] __tcp_push_pending_frames+0x260/0x9=
60
> [292334.107195]  [<ffffffff80690a1c>] tcp_current_mss+0x5c/0x100
> [292334.107221]  [<ffffffff80687f12>] tcp_sendpage+0x652/0x6e0
> [292334.107247]  [<ffffffff805feea6>] kernel_sendpage+0x16/0x40
> [292334.107274]  [<ffffffff80740f56>] svc_sendto+0x216/0x360
> [292334.107300]  [<ffffffff803786c1>] encode_fattr3+0x141/0x1f0
> [292334.107326]  [<ffffffff80378831>] encode_post_op_attr+0xc1/0xd0
> [292334.107353]  [<ffffffff80741d8c>] svc_tcp_sendto+0x4c/0xb0
> [292334.107380]  [<ffffffff8074be0b>] svc_send+0x9b/0xd0
> [292334.107404]  [<ffffffff8073f6f2>] svc_process+0x232/0x800
> [292334.107429]  [<ffffffff80239f50>] default_wake_function+0x0/0x10
> [292334.107458]  [<ffffffff8076e4c7>] __down_read+0x17/0xa6
> [292334.107484]  [<ffffffff80369639>] nfsd+0x1a9/0x2c0
> [292334.107509]  [<ffffffff80369490>] nfsd+0x0/0x2c0
> [292334.107534]  [<ffffffff80256da7>] kthread+0x47/0x90
> [292334.107558]  [<ffffffff8023dfb7>] schedule_tail+0x27/0x70
> [292334.107583]  [<ffffffff8020d139>] child_rip+0xa/0x11
> [292334.107608]  [<ffffffff80256d60>] kthread+0x0/0x90
> [292334.107633]  [<ffffffff8020d12f>] child_rip+0x0/0x11
> [292334.107657] ---[ end trace 43778c870e1cf6c0 ]---
>=20
> It indicates that mac80211 queued a frame on the queue although
> ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb)); was called=
 on that queue.
>=20
> This seems to only happen with fragmentation turned on (fts =3D 1024).
> (I only noticed it after I turned fragmentation on, so...)
> I'm not sure if it's related to AP mode, but this machine is in AP mode.

Just wanted to follow up on this for everybody to see -- I am aware of
the issue but the code is complicated enough and it happens infrequently
enough that I do not actually want to fix it immediately. I'm working on
rewriting the queueing code because it is needed for proper aggregation,
and will try to make sure this will work as expected.

Regardless of that, I still recommend to always keep around 10 spaces in
the queue free and use them up for a fragmented frame, only stopping the
queue on the last fragment. This is a little more driver code, but it
should be more efficient.

johannes

--=-Sw3QYul+2LZ+WqEo0+o8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqCd7AAoJEKVg1VMiehFYf+IP/Rtq6jYVRgs1HjimS9gcF9Nt
wj4BGaL92E3V62hHoYK83vah4KH+C0Kr/j1OK16AdlsXfmY1EsQaXwM4ggvu0nZi
zea6JI2u19v4JADz4c8BHyjrExfxBmjnr0rEaW3naVkWNDEn+nRM6IE2hVWsVtpL
QW3rZYq6t4zhR3oWqGxaBD0ctYZBuSve/psRlsJMuDg0IHomJ5aMN2fpiSMWpfdz
APzeROkFRf16+/yCSbHGPJoO2exdIr9uesCVlp5UH+Oo6Kia84WYshEIwR7bEcnl
lyrjPkK/9+9w7or8zfwkV2DDXLjQt7xYlz7PRtjVJcrKO5gglqsOobUeZHD8OgU5
1EjCCCax7XwtfptURZ+Ihjui9XtSaS84zKnToXX1kbyR/tbsT8lONS7g8fHHuTd4
MdzfUV7bN/kprgrH5VpgArhZTHSjWCmBy+koJx2nGSq1VPDzVCpievOl3MDRpnAp
8zFjqS8Z4vI7AS6A9+oFV1HYZMqa1MxQbI1usTdctRzHhPQtxFNaWJVLP3I7qlLg
DV3YiAIogmHAmV42WK6zpBXtfu+fKtv9v1YT6Gu4ztXvLg4IxVZoitlpwgYjnod8
lMAb+NrID6mV5HG9YHo5ImOcpHX5oxWOgO9N1Tdf03qTmzvVjo9fNxtgZaFpwgJi
rJskVLMPvUJ3uhvJ2KKK
=WWL4
-----END PGP SIGNATURE-----

--=-Sw3QYul+2LZ+WqEo0+o8--

