Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754137AbZCWAqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 20:46:08 -0400
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Mon, 23 Mar 2009 01:45:58 +0100
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linville@tuxdriver.com,
	davem@davemloft.net, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-kernel@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <200903152227.16676.s.L-H@gmx.de>
In-Reply-To: <200903152227.16676.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903230146.02071.s.L-H@gmx.de> (sfid-20090323_014615_315936_364A3686)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Sonntag, 15. M=C3=A4rz 2009, Stefan Lippers-Hollmann wrote:
> Hi
>=20
> On Mittwoch, 7. Januar 2009, Jiri Slaby wrote:
> > On 01/07/2009 02:51 PM, Jiri Slaby wrote:
> > > Dhaval Giani wrote:
> > >> I see this on current git. Not sure how to reproduce it, has hap=
pened on
> > >> two random occasions. At both times, I was not connected to a wi=
reless
> > >> network, but to wired networks.
> > >>
> > >> ------------[ cut here ]------------
> > >> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
> > >> ...
> > >> Call Trace:
> > >>  [<f80d4192>] __ieee80211_rx+0x7f/0x559 [mac80211]
> > >>  [<f80a19f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
> > >> ...
> > >=20
> > > Hmm, maybe ath5k is culprit. Could you apply the attached patch a=
nd
> > > use the kernel till the problem appears again?
>=20
> It seems as if this problem wouldn't be restricted to ath5k, I just=20
> triggered something very similar on b43 and 2.6.29-rc8-git1 (i386, ha=
rd=20
> preemption):
>=20
> b43-phy0: Broadcom 4306 WLAN found (core revision 5)
[...]
> wlan1: no IPv6 routers present
> b43-phy0 ERROR: PHY transmission error
> b43-phy0 ERROR: PHY transmission error
>=20
> [ lots of these, likely to be caused by minstrel being a little too=20
>   optimistic about the possible wlan rates (it was more conservative =
in=20
>   2.6.28 and didn't happen there); the distance between both stations=
 is=20
>   on the upper end ]
>=20
> b43-phy0 ERROR: PHY transmission error
> __ratelimit: 9 callbacks suppressed
> b43-phy0 ERROR: PHY transmission error
> b43-phy0 ERROR: PHY transmission error
> ------------[ cut here ]------------
> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0xa2/0x6a0 [mac8021=
1]()
> Hardware name: Amilo D-Series
> Modules linked in: ppdev lp aes_i586 aes_generic ipv6 af_packet rfkil=
l_input arc4 ecb b43 rfkill rng_core mac80211 cfg80211 led_class input_=
polldev ssb joydev pcmcia snd_via82xx gameport snd_ac97_codec ac97_bus =
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_u=
art snd_rawmidi snd_seq_device i2c_viapro serio_raw snd i2c_core pcspkr=
 psmouse evdev soundcore via686a via_agp shpchp yenta_socket rsrc_nonst=
atic pcmcia_core pci_hotplug rtc_cmos battery rtc_core rtc_lib parport_=
pc parport ac button ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generi=
c pata_acpi pata_via uhci_hcd ehci_hcd floppy firewire_ohci libata tuli=
p firewire_core crc_itu_t usbcore scsi_mod thermal processor fan
> Pid: 0, comm: swapper Not tainted 2.6.29-rc8-sidux-686 #1
> Call Trace:
>  [<c01319d7>] warn_slowpath+0x87/0xe0
>  [<d00523b7>] op32_set_current_rxslot+0x27/0x40 [b43]
>  [<d0052d93>] b43_dma_rx+0x193/0x420 [b43]
>  [<c0124fc3>] __wake_up_common+0x43/0x70
>  [<cfffcc62>] __ieee80211_rx+0xa2/0x6a0 [mac80211]
>  [<c011e9a5>] default_spin_lock_flags+0x5/0x10
>  [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
>  [<cffeb337>] ieee80211_tasklet_handler+0x107/0x130 [mac80211]
>  [<c013692c>] tasklet_action+0x6c/0xf0
>  [<c0137147>] __do_softirq+0x87/0x140
>  [<c011e9a5>] default_spin_lock_flags+0x5/0x10
>  [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
>  [<c0137255>] do_softirq+0x55/0x60
>  [<c0137495>] irq_exit+0x75/0x90
>  [<c0106378>] do_IRQ+0x48/0x90
>  [<c0104527>] common_interrupt+0x27/0x2c
>  [<cf8372e4>] acpi_idle_enter_simple+0x17a/0x1f4 [processor]
>  [<c02fd3bf>] cpuidle_idle_call+0x6f/0xc0
>  [<c0102de6>] cpu_idle+0x66/0xa0
> ---[ end trace c754f566bbe5ac47 ]---
[...]
> Sometimes even the firmware crashes and gets reloaded continously.
[...]
> Setting a fixed wlan rate (like 11M) seems to avoid this problem.
>=20
> > I don't think this will print anything, the rate won't be 32, it's =
rather
> > too high. Could you apply also the appended debug one?
>=20
> I will apply this patch and give it some more testing tomorrow evenin=
g,=20
> this problem is almost 100% reproducable for me at the end of my rout=
er's
> range and doesn't happen in closer proximity.
[...]

Sorry for the late response, but I've been unexpectedly away from my=20
BCM4306 system until today.

Thanks to the following (not yet mainline) patches by Michael Buesch an=
d=20
Lorenzo Nava on top of 2.6.29-rc8-git5, these problems seem to be "fixe=
d"=20
(well, the PHY errors are basically just hidden, but as they don't=20
trigger the firmware watchdog anymore, it's much less of a problem and=20
isn't actually a user visible problem anymore).

[PATCH] b43: Mask PHY TX error interrupt, if not debugging
	http://marc.info/?l=3Dlinux-wireless&m=3D123748731831778&w=3D2

[PATCH] b43: fix b43_plcp_get_bitrate_idx_ofdm return type
	http://marc.info/?l=3Dlinux-wireless&m=3D123774585529189&w=3D2


Confirming the patch descriptions, Jiri Slaby's debugging patch did rev=
eal=20
a signedness problem of the return value of in=20
b43_plcp_get_bitrate_idx_ofdm(), which has been fixed by the patch abov=
e:

[ this trace happened *without* "b43: fix b43_plcp_get_bitrate_idx_ofdm=
=20
  return type", and only "b43: Mask PHY TX error interrupt, if not=20
  debugging" applied on top of 2.6.29-rc8-git5 ]
------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2236 __ieee80211_rx+0xab/0x6b0 [mac80211]=
()
Hardware name: Amilo D-Series
RATE=3D255, BAND=3Dc
Modules linked in: ppdev lp aes_i586 aes_generic ipv6 af_packet rfkill_=
input arc4 ecb b43 rfkill rng_core mac80211 cfg80211 led_class input_po=
lldev ssb joydev snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_o=
ss snd_mixer_oss pcmcia snd_pcm snd_timer snd_page_alloc snd_mpu401_uar=
t snd_rawmidi i2c_viapro serio_raw snd_seq_device pcspkr i2c_core psmou=
se snd evdev soundcore via686a shpchp yenta_socket rsrc_nonstatic pcmci=
a_core via_agp pci_hotplug rtc_cmos parport_pc battery rtc_core rtc_lib=
 parport ac button ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic =
pata_acpi pata_via uhci_hcd ehci_hcd floppy firewire_ohci libata tulip =
firewire_core crc_itu_t usbcore scsi_mod thermal processor fan
Pid: 0, comm: swapper Not tainted 2.6.29-rc8-sidux-686 #1
Call Trace:
 [<c0131a67>] warn_slowpath+0x87/0xe0
 [<d002d377>] op32_set_current_rxslot+0x27/0x40 [b43]
 [<d002dd53>] b43_dma_rx+0x193/0x420 [b43]
 [<c01ae229>] add_partial+0x19/0x70
 [<cfcd834f>] ieee80211_tasklet_handler+0x11f/0x130 [mac80211]
 [<c03a4195>] _spin_unlock+0x5/0x20
 [<cfce9c6b>] __ieee80211_rx+0xab/0x6b0 [mac80211]
 [<c011ea35>] default_spin_lock_flags+0x5/0x10
 [<c03a3d7e>] _spin_lock_irqsave+0x3e/0x60
 [<cfcd8337>] ieee80211_tasklet_handler+0x107/0x130 [mac80211]
 [<c01369bc>] tasklet_action+0x6c/0xf0
 [<c01371d7>] __do_softirq+0x87/0x140
 [<c011ea35>] default_spin_lock_flags+0x5/0x10
 [<c03a3d7e>] _spin_lock_irqsave+0x3e/0x60
 [<c01372e5>] do_softirq+0x55/0x60
 [<c0137525>] irq_exit+0x75/0x90
 [<c0106378>] do_IRQ+0x48/0x90
 [<c0104527>] common_interrupt+0x27/0x2c
 [<cf8372cb>] acpi_idle_enter_simple+0x17a/0x1f4 [processor]
 [<c02fcfcf>] cpuidle_idle_call+0x6f/0xc0
 [<c0102de6>] cpu_idle+0x66/0xa0
---[ end trace ba8601a4d52a20d2 ]---
------------[ cut here ]------------	=09

So far (after 2.9 GB continuous kernel tarball downloads from a local=20
mirror) b43 seems to be fine again:

wlan1     IEEE 802.11bg  ESSID:"gemini"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:21:27:FF:=
51:A8
          Bit Rate=3D54 Mb/s   Tx-Power=3D20 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B
          Power Management:off
          Link Quality=3D54/100  Signal level:-82 dBm  Noise level=3D-6=
9 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wlan1     Link encap:Ethernet  HWaddr 00:0f:66:d8:67:ca
          inet addr:192.168.0.70  Bcast:192.168.0.255  Mask:255.255.255=
=2E0
          inet6 addr: fe80::20f:66ff:fed8:67ca/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2090104 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1082081 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:3146865411 (2.9 GiB)  TX bytes:93054386 (88.7 MiB)

=46etched 83.2MB in 1min18s (1058kB/s)
[...]
=46etched 83.2MB in 1min1s (1362kB/s)

Thank you and sorry about the late response.

Regards
	Stefan Lippers-Hollmann


Post scriptum: I'm not able to trigger this trace with ath5k/ AR2425.
--=20
> >  net/mac80211/rx.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 7175ae8..5e17e57 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -2230,8 +2230,10 @@ void __ieee80211_rx(struct ieee80211_hw *hw,=
 struct sk_buff *skb,
> >  		 * MCS aware. */
> >  		rate =3D &sband->bitrates[sband->n_bitrates - 1];
> >  	} else {
> > -		if (WARN_ON(status->rate_idx < 0 ||
> > -			    status->rate_idx >=3D sband->n_bitrates))
> > +		if (WARN(status->rate_idx < 0 ||
> > +			    status->rate_idx >=3D sband->n_bitrates,
> > +			    "RATE=3D%u, BAND=3D%x\n", status->rate_idx,
> > +			    sband->n_bitrates))
> >  			return;
> >  		rate =3D &sband->bitrates[status->rate_idx];
> >  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
