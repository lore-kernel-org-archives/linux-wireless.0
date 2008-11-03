Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYKCHSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:18:53 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com> (sfid-20081102_214920_731298_66DF16AA)
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 (sfid-20081102_214920_731298_66DF16AA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mU88DyTxCyfMMoO0771Y"
Date: Mon, 03 Nov 2008 08:18:12 +0100
Message-Id: <1225696692.3619.18.camel@johannes.berg> (sfid-20081103_081859_330756_5BB5DCC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mU88DyTxCyfMMoO0771Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-02 at 12:49 -0800, Luis R. Rodriguez wrote:
> On Sun, Nov 2, 2008 at 10:41 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Sun, Nov 02, 2008 at 11:10:04AM +0200, Nick Kossifidis wrote:
> >> Can you test the attached patch ?
> >>
> >> It works for me (tested on a AR5413)...
> >>
> >> makis linux # iperf -s
> >> ------------------------------------------------------------
> >> Server listening on TCP port 5001
> >> TCP window size: 85.3 KByte (default)
> >> ------------------------------------------------------------
> >> [  4] local 192.168.1.104 port 5001 connected with 192.168.1.10 port 4=
3192
> >> [ ID] Interval       Transfer     Bandwidth
> >> [  4]  0.0-10.6 sec  21.8 MBytes  17.2 Mbits/sec
> >
> > This patch works for me (I was seeing the same stalls).
> >
> > I somehow managed to trigger this after reloading the module:
> >
> > Nov  2 13:12:05 sludge kernel: ------------[ cut here ]------------
> > Nov  2 13:12:05 sludge kernel: WARNING: at net/mac80211/main.c:236
> > ieee80211_hw_config+0x82/0x8c [mac80211]()
> > Nov  2 13:12:05 sludge kernel: Modules linked in: ath5k af_packet
> > sha256_generic aes_i586 aes_generic cbc loop i915 drm binfmt_misc
> > acpi_cpufreq fan container nls_utf8 hfsplus dm_crypt dm_mod kvm_intel
> > kvm fuse sbp2 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss appletouc=
h
> > hid_apple snd_seq_dummy snd_seq_oss arc4 ecb snd_seq_midi usbhid
> > snd_rawmidi snd_seq_midi_event mac80211 snd_seq ohci1394 snd_timer
> > snd_seq_device sr_mod ieee1394 sky2 cfg80211 sg cdrom rtc ehci_hcd
> > uhci_hcd thermal bitrev crc32 snd snd_page_alloc battery ac processor
> > button evdev unix [last unloaded: ath5k]
> > Nov  2 13:12:05 sludge kernel: Pid: 9748, comm: ath5k_pci Tainted: G
> > W  2.6.28-rc2-wl #19
> > [...]
> >
> > But I think that was just a coincidence with the hardware getting
> > stuck in a bad state -- after reboot it was fine.  If not, this at leas=
t
> > papers over the warning :)
> >
> > diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/a=
th5k/base.c
> > index a298e8a..0308165 100644
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> > @@ -2796,7 +2796,8 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed=
)
> >        sc->bintval =3D conf->beacon_int;
> >        sc->power_level =3D conf->power_level;
> >
> > -       return ath5k_chan_set(sc, conf->channel);
> > +       ath5k_chan_set(sc, conf->channel);
> > +       return 0;
> >  }
>=20
> Not sure I agree with the WARN_ON() if the driver's mac80211 config()
> callback fails. In our case when we tune to a different channel we
> have to clear any DMA operations first and then we reset the chip.
> Reseting the chip can fail for whatever strange hw issue cases. The
> patch fixes the complaint but is the complaint sane?

What's mac80211 to do when it fails?

johannes

--=-mU88DyTxCyfMMoO0771Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDqWwAAoJEKVg1VMiehFYlGcQAJEAF/MXKU4wCpFOjNfwyqvZ
4JB2HmnOu5FETBgnSnjmgXd4gQVbgRNiBoJCR6nz9FUHYoPG17tgjynxG2tkwmLp
EZQfa5kF5wsR/+b0l1/MSg5vylnkGCM3JxrE9vjWdtyBU6j7ntgunAQTRy3p2VgM
B3qmQbSYtgoFV3uDOS6EIrLi4M4KojCwTNT3MzlZ9xH97YxOL7nF94gfVE/z12jY
2agQHnI2j+YKIp9cgko66ZR4u0RpE3zEJOm53IC7ylVnUnY71B6LI3hLdTXZBv+G
EOZAdF8FYqYwgFa0L0+uAvTefDF+jVS9pgHeKjzbMW7mj/bxMLjoMlA+/YXtOtbY
LgQ17rbVUEIHhm8Sc4wSBA/oMM9MRwG7/Q2Fy7c8xpgM/prkX0BwMdG4HOVeTQYg
XF2DBArlA0IH24xhr+9ksn0MQbdLTLMxVG4/jygkGsZJGSCQQuREkTDdWa0QcQG1
stcx5TtdZxSl1poB4Du55ZHAN968RSLiOhFt5w3K/IK/J2ikONdqxfo/0rmzMSE4
Em/8Zu89ohKPKYqljc7jCuY6pM2ZbDKxWexxOAMvRdso/XykrUYDB2tKPYnyBUW0
lUiUbOkmOC4NNiMKaOpQn1VWgjXd+PYitZdXlc9w345aodp44jU+9kQ228aQmkRq
Y8Evbaqm3Ip5dUxBbyYF
=tw7m
-----END PGP SIGNATURE-----

--=-mU88DyTxCyfMMoO0771Y--

