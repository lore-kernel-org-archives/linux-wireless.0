Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:33855 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165AbYDJSXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 14:23:15 -0400
Date: Thu, 10 Apr 2008 14:16:12 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Maciek Kaliszewski <mkalkal@interia.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Kismet shows no clients (drivers iwl3945.ko or p54pci.ko)
Message-ID: <20080410181612.GB23971@drd1813.lan> (sfid-20080410_192346_316980_5F602990)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <47FDF732.7000304@interia.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
In-Reply-To: <47FDF732.7000304@interia.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2008 at 01:17:06PM +0200, Maciek Kaliszewski wrote:
> Hi,
>
> I have "02:00.0 Network controller: Intersil Corporation ISL3890 [Prism=
=20
> GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)"
> which does not work with prism54.ko driver . So I have to use p54pci.ko=
=20
> (from kernel 2.6.25-rc8) .
> When I run kismet ,it detects wifi networks , but shows there is no clien=
ts=20
> on the networks (I started data transfer on that network but it didn't=20
> help)

This is probably not the best forum (being related to kernel dev) - hit
me up on personal email or on the kismet forum for Kismet-specific
stuff...

That said:

> Tcpdump on wlan0 interface (Monitor mode ) shows :
>
> tcpdump: WARNING: wlan0: no IPv4 address assigned
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on wlan0, link-type IEEE802_11_RADIO (802.11 plus BSD radio=20
> information header), capture size 96 bytes
> 12:38:51.010818 490951797us tsft 1.0 Mb/s 2457 MHz (0x0480) 81dB signal=
=20
> [0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0=
=20
> Mbit] ESS CH: 11, PRIVACY

This mirrors my own experience with many of the mac80211 drivers in
their development status, which is that they typically return only
mgmt (or sometimes only beacon) frames.

> As far as I can read the log , it show there is no traffic on net APTEKA,=
=20
> but I know there is a data transfer on the net.
> I had similar results on other computer ,intel wifi card with iwl3945.ko=
=20
> driver(kernel 2.6.24.2).

I've held off complaining since I know the drivers are in a pretty heavy
dev state right now, however if it's useful I'll start throwing cards
into rfmon and reporting what happens.  Kismet and tcpdump use the same
data, so anyone who doesn't feel like getting Kismet going for rfmon
testing can obviously just throw the card into rfmon and tcpdump it, if
mgmt and data frames show up, I'll be happy :)

I can currently say that iwl4965, 2.6.24.3, rfmon returns no packets at
all.  In wireless-testing head as of 2 days ago, rfmon threw the card
into sw-rfkill, then got into a thrash where it couldn't find the
firmware anymore, and then kernel paniced the system.  Maybe tonight
I'll try again and post more logs, I'll include the errors at the time but
readily admit that since they're not from the wireless-test head they're
probably not incredibly useful.

iwl4965: Microcode SW error detected.  Restarting 0x2000000.
ACPI: PCI interrupt for device 0000:03:00.0 disabled
wlan0: deauthenticate(reason=3D3)
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
100102, writing 100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
device wlan0 entered promiscuous mode
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
ACPI: PCI interrupt for device 0000:03:00.0 disabled
device wlan0 left promiscuous mode
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
100102, writing 100106)
iwl4965: Radio disabled by SW RF kill (module parameter)
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
100102, writing 100106)
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy2: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: ucode not available for device bringup
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Could not read microcode: -22
general protection fault: ff04 [#1] PREEMPT SMP=20
Modules linked in: iwl4965(+) iwlcore mac80211 nvidia(P) ipt_MASQUERADE ipt=
able_nat nf_nat ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack iptable_=
filter ip_tables x_tables rfcomm l2cap bluetooth snd_seq snd_seq_device snd=
_pcm_oss snd_mixer_oss bridge ppp_generic slhc video snd_hda_intel snd_pcm =
snd_timer snd_page_alloc snd_hwdep uhci_hcd thinkpad_acpi ehci_hcd snd back=
light usbcore i2c_i801 soundcore i2c_core [last unloaded: mac80211]

Pid: 20349, comm: modprobe Tainted: P         (2.6.25-rc7-wl-git #2)
EIP: 0060:[<f898ad28>] EFLAGS: 00010246 CPU: 0
EIP is at iwl4965_pci_probe+0xe1/0x99e [iwl4965]
EAX: 00000000 EBX: f656ff04 ECX: f7526454 EDX: c02d4035
ESI: f7526454 EDI: c02780b8 EBP: 00000000 ESP: f656fefc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 20349, ti=3Df656e000 task=3Df39c60a0 task.ti=3Df656e=
000)
Stack: f656ff04 c0565210 f656ff10 c02d4196 f656ff1c f656ff34 c02d3611 f89a8=
8c0=20
       f747d1fc f747d200 f75264a8 00000000 f89a88c0 f89a88c0 f656ff40 c02d3=
eda=20
       c02d414d f656ff5c c02d3d00 c0565210 f6de1e40 f89a8890 f89a88c0 f89a8=
8c0=20
Call Trace:
 [<c02d4196>] ? __driver_attach+0x49/0x7d
 [<c02d3611>] ? bus_for_each_dev+0x3b/0x5d
 [<c02d3eda>] ? driver_attach+0x14/0x16
 [<c02d414d>] ? __driver_attach+0x0/0x7d
 [<c02d3d00>] ? bus_add_driver+0x97/0x1a7
 [<c02d4350>] ? driver_register+0x47/0xa3
 [<c0278275>] ? __pci_register_driver+0x35/0x64
 [<f88ec02c>] ? iwl4965_init+0x2c/0x71 [iwl4965]
 [<c015252c>] ? sys_init_module+0x80/0x162
 [<c01142ea>] ? sysenter_past_esp+0x5f/0x85
 [<c0400000>] ? init_centaur+0x177/0x281
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: e3 3e 6c 34 39 36 35 3a 20 25 63 20 25 73 20 52 75 6e 6e 69 6e 67 20 =
46 c1 21 b0 6c 65 6d 70 65 72 61 74 75 72 65 20 63 61 6c 53 <1f> 01 29 74 6=
9 6f 6e 0a 00 3c 33 3e 69 77 6c 34 39 36 35 3a 20=20
EIP: [<f898ad28>] iwl4965_pci_probe+0xe1/0x99e [iwl4965] SS:ESP 0068:f656fe=
fc


-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Life is a whim of several billion cells to be you for a while.

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkf+WWwACgkQ17KIInOLvbErYQCglZgsNfNMF6dxQ9Zkd/EbS43h
nIQAmgKdhwDqC9nGKPKXrtH3hA6nCm/w
=7Smz
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
