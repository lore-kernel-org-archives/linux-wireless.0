Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web50208.mail.yahoo.com ([206.190.38.49]:46790 "HELO
	web50208.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965597AbXBTDEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 22:04:01 -0500
Date: Mon, 19 Feb 2007 19:04:00 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Kernel bug in bcm43xx-d80211
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <1171931043.8133.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <178298.69840.qm@web50208.mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- Pavel Roskin <proski@gnu.org> wrote:

> On Mon, 2007-02-19 at 15:48 -0800, Alex Davis wrote:
> > --- Pavel Roskin <proski@gnu.org> wrote:
> >=20
> > > On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
> > > > I go the following Oops with the latest wireless-dev git when s=
tarting wpa_supplicant:
> > >=20
> > > Wireless topics moved from this list to linux-wireless@vger.kerne=
l.org.
> > > Broadcom drivers are discussed in bcm43xx-dev@lists.berlios.de.
> > > wireless-dev is horribly broken, and the fixes haven't been merge=
d yet.
> > >=20
> > > The current Broadcom driver can be loaded from
> > > http://bu3sch.de/git/wireless-dev.git (please load it on top of
> > > wireless-dev.git to save bandwidth)
> > What command do I use to load Mike's tree on top of wireless-dev?
>=20
> This should do it for you:
>=20
> git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
> git-branch bcm43xx
> git-config branch.bcm43xx.remote bcm43xx
> git-config branch.bcm43xx.merge refs/heads/master
> git-checkout bcm43xx
> git-pull
>=20
> Sorry, I didn't expect it to be so hairy.  Perhaps it should be
> documented somewhere.
>=20
I merged Michael's changes. It doesn't panic anymore, but I still can't=
 associate. Here's the
output from wpa_supplicant 0.4.9:

ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCSIWMODE]: Device or resource bu=
sy
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
WEXT auth param 4 value 0x0 - Trying to associate with 00:0f:66:d9:25:9=
1 (SSID=3D'ace' freq=3D2437
MHz)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:0f:66:d9:25:91 (SSID=3D'ace' freq=3D2437 MH=
z)
Association request to the driver failed
CTRL-EVENT-TERMINATING - signal 15 received

Here's the dmesg when the driver is loaded:
[   65.113061] ssb: Sonics Silicon Backplane found on PCI device 0000:0=
2:03.0
[   65.116542] bcm43xx_d80211: Broadcom 4306 WLAN found
[   65.261596] wmaster0: Selected rate control algorithm 'simple'
[   65.344671] bcm43xx_d80211: Adding Interface type 2
[   65.446213] bcm43xx_d80211: Found PHY: Analog 2, Type 2, Revision 2
[   65.446235] bcm43xx_d80211: Found Radio: Manuf 0x17F, Version 0x2050=
, Revision 2
[   65.568141] bcm43xx_d80211: Loading firmware version 371.1122 (2006-=
11-08 22:02:13)
[   65.576305] bcm43xx_d80211: Radio turned on
[   65.576310] bcm43xx_d80211: Radio enabled by hardware
[   65.696296] bcm43xx_d80211: Chip initialized
[   65.696466] bcm43xx_d80211: 30-bit DMA initialized
[   65.712733] bcm43xx_d80211: Wireless interface started
[   65.712755] wmaster0: Does not support passive scan, disabled
[   75.700550] wlan0: no IPv6 routers present

Here's trying to associante via wpa_supplicant:
[ 3555.573064] wlan0: starting scan
[ 3556.458869] wlan0: scan completed
[ 3556.459048] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3556.467250] wlan0: Initial auth_alg=3D0
[ 3556.467254] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3556.670310] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3556.869811] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3557.069311] wlan0: authentication with AP 00:0f:66:d9:25:91 timed ou=
t
[ 3561.458416] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3561.458478] wlan0: starting scan
[ 3562.344163] wlan0: scan completed
[ 3562.344287] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3567.333708] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3567.333769] wlan0: starting scan
[ 3568.219441] wlan0: scan completed
[ 3568.219571] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3573.209003] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3573.209065] wlan0: starting scan
[ 3574.094760] wlan0: scan completed
[ 3574.094882] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3579.084302] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3579.084363] wlan0: starting scan
[ 3579.970041] wlan0: scan completed
[ 3580.021891] bcm43xx_d80211: Removing Interface type 2
[ 3580.021910] bcm43xx_d80211: Wireless interface stopped
[ 3580.021915] bcm43xx_d80211: DMA-32 0x0200 (RX) max used slots: 1/64
[ 3580.021950] bcm43xx_d80211: DMA-32 0x02A0 (TX) max used slots: 0/128
[ 3580.022257] bcm43xx_d80211: DMA-32 0x0280 (TX) max used slots: 0/128
[ 3580.022564] bcm43xx_d80211: DMA-32 0x0260 (TX) max used slots: 0/128
[ 3580.022870] bcm43xx_d80211: DMA-32 0x0240 (TX) max used slots: 0/128
[ 3580.023176] bcm43xx_d80211: DMA-32 0x0220 (TX) max used slots: 0/128
[ 3580.023483] bcm43xx_d80211: DMA-32 0x0200 (TX) max used slots: 0/128
[ 3580.023792] bcm43xx_d80211: Radio turned off
[ 3680.040344] bcm43xx_d80211: Adding Interface type 2
[ 3680.141356] bcm43xx_d80211: Found PHY: Analog 2, Type 2, Revision 2
[ 3680.141378] bcm43xx_d80211: Found Radio: Manuf 0x17F, Version 0x2050=
, Revision 2
[ 3680.200510] bcm43xx_d80211: Loading firmware version 371.1122 (2006-=
11-08 22:02:13)
[ 3680.208672] bcm43xx_d80211: Radio turned on
[ 3680.208677] bcm43xx_d80211: Radio enabled by hardware
[ 3680.329891] bcm43xx_d80211: Chip initialized
[ 3680.330074] bcm43xx_d80211: 30-bit DMA initialized
[ 3680.346356] bcm43xx_d80211: Wireless interface started
[ 3680.346374] wmaster0: Does not support passive scan, disabled
[ 3680.520414] wlan0: starting scan
[ 3681.396239] wlan0: scan completed
[ 3681.396476] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3681.396676] wlan0: Initial auth_alg=3D0
[ 3681.396679] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3681.597712] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3681.797212] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3681.996713] wlan0: authentication with AP 00:0f:66:d9:25:91 timed ou=
t
[ 3686.385815] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3686.385868] wlan0: starting scan
[ 3687.271537] wlan0: scan completed
[ 3687.271713] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3691.103921] wlan0: no IPv6 routers present
[ 3692.261104] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3692.261162] wlan0: starting scan
[ 3693.146836] wlan0: scan completed
[ 3693.146987] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3697.006343] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3697.059037] bcm43xx_d80211: Removing Interface type 2
[ 3697.059055] bcm43xx_d80211: Wireless interface stopped
[ 3697.059060] bcm43xx_d80211: DMA-32 0x0200 (RX) max used slots: 1/64
[ 3697.059086] bcm43xx_d80211: DMA-32 0x02A0 (TX) max used slots: 0/128
[ 3697.059392] bcm43xx_d80211: DMA-32 0x0280 (TX) max used slots: 0/128
[ 3697.059699] bcm43xx_d80211: DMA-32 0x0260 (TX) max used slots: 0/128
[ 3697.060005] bcm43xx_d80211: DMA-32 0x0240 (TX) max used slots: 0/128
[ 3697.060311] bcm43xx_d80211: DMA-32 0x0220 (TX) max used slots: 0/128
[ 3697.060617] bcm43xx_d80211: DMA-32 0x0200 (TX) max used slots: 0/128
[ 3697.060926] bcm43xx_d80211: Radio turned off
[ 3723.125212] bcm43xx_d80211: Adding Interface type 2
[ 3723.223555] bcm43xx_d80211: Found PHY: Analog 2, Type 2, Revision 2
[ 3723.223576] bcm43xx_d80211: Found Radio: Manuf 0x17F, Version 0x2050=
, Revision 2
[ 3723.282700] bcm43xx_d80211: Loading firmware version 371.1122 (2006-=
11-08 22:02:13)
[ 3723.290858] bcm43xx_d80211: Radio turned on
[ 3723.290863] bcm43xx_d80211: Radio enabled by hardware
[ 3723.407607] bcm43xx_d80211: Chip initialized
[ 3723.407783] bcm43xx_d80211: 30-bit DMA initialized
[ 3723.424049] bcm43xx_d80211: Wireless interface started
[ 3723.424067] wmaster0: Does not support passive scan, disabled
[ 3723.632545] wlan0: starting scan
[ 3724.518336] wlan0: scan completed
[ 3724.518468] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3724.518572] wlan0: Initial auth_alg=3D0
[ 3724.518577] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3724.719810] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3724.919310] wlan0: authenticate with AP 00:0f:66:d9:25:91
[ 3725.118811] wlan0: authentication with AP 00:0f:66:d9:25:91 timed ou=
t
[ 3729.507850] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3729.507926] wlan0: starting scan
[ 3730.393635] wlan0: scan completed
[ 3730.393728] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3733.517793] wlan0: no IPv6 routers present
[ 3735.383154] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3735.383211] wlan0: starting scan
[ 3736.268934] wlan0: scan completed
[ 3736.269050] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3741.258474] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3741.258530] wlan0: starting scan
[ 3742.144233] wlan0: scan completed
[ 3742.144330] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3747.133744] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3747.133795] wlan0: starting scan
[ 3748.019530] wlan0: scan completed
[ 3748.019616] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3753.009047] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3753.009101] wlan0: starting scan
[ 3753.894829] wlan0: scan completed
[ 3753.894933] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3758.884346] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3758.884400] wlan0: starting scan
[ 3759.770133] wlan0: scan completed
[ 3759.770275] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3764.759642] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3764.759695] wlan0: starting scan
[ 3765.645427] wlan0: scan completed
[ 3765.645517] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3770.634948] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3770.635004] wlan0: starting scan
[ 3771.520733] wlan0: scan completed
[ 3771.520832] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3776.510239] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3776.510305] wlan0: starting scan
[ 3777.396023] wlan0: scan completed
[ 3777.396111] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3782.385534] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3782.385585] wlan0: starting scan
[ 3783.271322] wlan0: scan completed
[ 3783.271408] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3788.260835] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3788.260886] wlan0: starting scan
[ 3789.136645] wlan0: scan completed
[ 3789.136731] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3794.126162] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3794.126214] wlan0: starting scan
[ 3795.011945] wlan0: scan completed
[ 3795.012042] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3799.213881] bcm43xx_d80211: Using hardware based encryption for keyi=
dx: 0, mac:
ff:ff:ff:ff:ff:ff
[ 3799.273272] bcm43xx_d80211: Removing Interface type 2
[ 3799.273290] bcm43xx_d80211: Wireless interface stopped
[ 3799.273294] bcm43xx_d80211: DMA-32 0x0200 (RX) max used slots: 1/64
[ 3799.273320] bcm43xx_d80211: DMA-32 0x02A0 (TX) max used slots: 0/128
[ 3799.273625] bcm43xx_d80211: DMA-32 0x0280 (TX) max used slots: 0/128
[ 3799.273928] bcm43xx_d80211: DMA-32 0x0260 (TX) max used slots: 0/128
[ 3799.274232] bcm43xx_d80211: DMA-32 0x0240 (TX) max used slots: 0/128
[ 3799.274535] bcm43xx_d80211: DMA-32 0x0220 (TX) max used slots: 0/128
[ 3799.274839] bcm43xx_d80211: DMA-32 0x0200 (TX) max used slots: 0/128
[ 3799.275145] bcm43xx_d80211: Radio turned off

I'm reposting the following for the bcm43xx mailing list.

lspci
02:03.0 Network controller: Broadcom Corporation BCM4309 802.11a/b/g (r=
ev 03)
        Subsystem: Dell Truemobile 1450 MiniPCI
        Flags: bus master, fast devsel, latency 32, IRQ 18
        Memory at faff6000 (32-bit, non-prefetchable) [size=3D8K]

Relevant part of .config
CONFIG_BCM43XX=3Dm
CONFIG_BCM43XX_DEBUG=3Dy
CONFIG_BCM43XX_DMA=3Dy
CONFIG_BCM43XX_PIO=3Dy
CONFIG_BCM43XX_DMA_AND_PIO_MODE=3Dy
# CONFIG_BCM43XX_DMA_MODE is not set
# CONFIG_BCM43XX_PIO_MODE is not set
# CONFIG_ZD1211RW is not set
CONFIG_BCM43XX_D80211=3Dm
CONFIG_BCM43XX_D80211_PCI=3Dy
CONFIG_BCM43XX_D80211_PCMCIA=3Dy
CONFIG_BCM43XX_D80211_DEBUG=3Dy
CONFIG_BCM43XX_D80211_DMA=3Dy
CONFIG_BCM43XX_D80211_PIO=3Dy
CONFIG_BCM43XX_D80211_DMA_AND_PIO_MODE=3Dy
# CONFIG_BCM43XX_D80211_DMA_MODE is not set
# CONFIG_BCM43XX_D80211_PIO_MODE is not set
# CONFIG_RT2X00 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ZD1211RW_D80211 is not set
CONFIG_NET_WIRELESS=3Dy


I'm using Wireless Tools v28

Another thing I've noticed: the output from iwconfig is corrupted:
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     v=B2#=C0=FC=B0=BFwlan0  ESSID:"ace" [176]  Nickname:"bos"
          Channel=3D-inf  Access Point: 23:C0:F0:1A:B0:BF   Bit Rate=3D=
-1.0714e+06 kb/s
          RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality:90/100  Signal level:-38 dBm  Noise level:-96 dB=
m
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Thanks for any info.


I code, therefore I am


=20
_______________________________________________________________________=
_____________
It's here! Your new message! =20
Get new email alerts with the free Yahoo! Toolbar.
http://tools.search.yahoo.com/toolbar/features/mail/
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
