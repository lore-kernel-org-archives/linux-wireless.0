Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:46677 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124AbbFGNBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:01:40 -0400
Date: Sun, 7 Jun 2015 14:47:05 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error
 detected.
Message-ID: <20150607124705.GA29715@light.dominikbrodowski.net> (sfid-20150607_150144_682949_AAB34286)
References: <20150525181043.GA10755@light.dominikbrodowski.net>
 <CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com>
 <20150525184047.GA12142@light.dominikbrodowski.net>
 <20150529200405.GA27272@light.dominikbrodowski.net>
 <CANUX_P0M1shWOhjJLqN+2vj3iTYXvSY678QGa=203x+60raRAg@mail.gmail.com>
 <20150531065246.GA17869@isilmar-3.linta.de>
 <CANUX_P2=mVLu6yNd-TP1VffzAMqz12=3i3+OcsVtF2Q_nD+JUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
In-Reply-To: <CANUX_P2=mVLu6yNd-TP1VffzAMqz12=3i3+OcsVtF2Q_nD+JUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 31, 2015 at 12:37:19PM +0300, Emmanuel Grumbach wrote:
> On Sun, May 31, 2015 at 9:52 AM, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> > On Sun, May 31, 2015 at 09:29:22AM +0300, Emmanuel Grumbach wrote:
> >> >
> >> > No joy. Firmware 25.27.13.0 also is not happy at times:
> >>
> >> Are you using 40Mhz or 20Mhz?
> >
> > Well, at the moment (and the problem appeared again just minutes ago):
> >
> >         channel 1 (2412 MHz), width: 40 MHz, center1: 2422 MHz
> >
>=20
> can you try to move to 20Mhz just to see if you still have the same probl=
em?
> You can load cfg80211 with cfg80211_disable_40mhz_24ghz set to true if
> you don't want to play with the settings of your AP.

On 20MHz, I do not see the queue issue, but the "Microcode SW error"
persists:

iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:02:00.0: CSR values:
iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X80000040
iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000144
iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X00000000
iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X80000000
iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X803a0000
iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080040
iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000000
iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000060
iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X88215528
iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:02:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:02:00.0: FH register values:
iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2140f900
iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02140f80
iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000048
iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X02030000
iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:02:00.0: Loaded firmware version: 25.27.13.0
iwlwifi 0000:02:00.0: 0x00000034 | NMI_INTERRUPT_WDG          =20
iwlwifi 0000:02:00.0: 0x000000E3 | uPc
iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
iwlwifi 0000:02:00.0: 0x00000B2E | branchlink2
iwlwifi 0000:02:00.0: 0x00016218 | interruptlink1
iwlwifi 0000:02:00.0: 0x000082F2 | interruptlink2
iwlwifi 0000:02:00.0: 0x00000000 | data1
iwlwifi 0000:02:00.0: 0x00000002 | data2
iwlwifi 0000:02:00.0: 0x02039842 | data3
iwlwifi 0000:02:00.0: 0xF300076B | beacon time
iwlwifi 0000:02:00.0: 0x5DEB98B6 | tsf low
iwlwifi 0000:02:00.0: 0x00000002 | tsf hi
iwlwifi 0000:02:00.0: 0x00000000 | time gp1
iwlwifi 0000:02:00.0: 0x78E966A4 | time gp2
iwlwifi 0000:02:00.0: 0x00000000 | time gp3
iwlwifi 0000:02:00.0: 0x0004191B | uCode version
iwlwifi 0000:02:00.0: 0x00000144 | hw version
iwlwifi 0000:02:00.0: 0x40489204 | board version
iwlwifi 0000:02:00.0: 0x0000001C | hcmd
iwlwifi 0000:02:00.0: 0x26F63002 | isr0
iwlwifi 0000:02:00.0: 0x11806000 | isr1
iwlwifi 0000:02:00.0: 0x0000001A | isr2
iwlwifi 0000:02:00.0: 0x40417C82 | isr3
iwlwifi 0000:02:00.0: 0x00000000 | isr4
iwlwifi 0000:02:00.0: 0x10804112 | isr_pref
iwlwifi 0000:02:00.0: 0x00000000 | wait_event
iwlwifi 0000:02:00.0: 0x00004288 | l2p_control
iwlwifi 0000:02:00.0: 0x00009C22 | l2p_duration
iwlwifi 0000:02:00.0: 0x000003BF | l2p_mhvalid
iwlwifi 0000:02:00.0: 0x000000E7 | l2p_addr_match
iwlwifi 0000:02:00.0: 0x00000017 | lmpm_pmg_sel
iwlwifi 0000:02:00.0: 0x21051936 | timestamp
iwlwifi 0000:02:00.0: 0x1F844858 | flow_handler
ieee80211 phy0: Hardware restart was requested

Best,
	Dominik

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVdD1JAAoJEJqXYIlMjaMN72UP/2ILOYvb8VTcTrR6q4rXkpWo
r/ujtc5KNXy5LFsIQ9ZBuMaSlgUIEZGnOodfrAEKQvdCwdQRALW4w06ht2bEDPJh
3kjk5zQv0+74G3vXIJEr2NtR7LpOSNnL0XRaeWz5b3qL/NFEizZgV8Mf9rtfpRD/
FfBeON+vp0dX3mwhP+OzYAqXs11NvwOWfcpN1Yg8EI5M02wqfHLcLztTl68VvTDJ
68eS2oQCzlKnYI250o63EZ4ta9Sc+tTJ2Dtedvbr/73KTObGDusaU+Ol9flzxMdZ
6mzU1paiHJ4yx6oeOSTcC/pr3XEPOfKzyJobEgScS+kBuaM43LlkEUH4a2xJKI5W
A+ANJIgSp98YNXOzShhaPt6QA/euxJR0rflqYyvQNJa+eoJtO8T9S+C8fOPvrIJZ
xz9VRiBbdowD+x7SbeQYgvodZqkXme/o231iAI5iEgU2LyFmXJJNckoJvVwAiTRp
cYZzGaBc82lh3UNPRVEvYD9SvzHfGpMiHoV0Sa0kHVjUvN+X2dKSPb5PFsckoYHs
o9p+tNQDkehVcIqGEfLmIRVsFkaJhauT4Qfi+yAUGa6a6DFLuB/0KxXbyurWSR9d
C8q+kqwSi5Fhbhw1+FeqnOsnSZ3cu23jdtEN6ageVhM0tWAbQs/wYSbYPhjG3yRl
GBbaSBekqT7Jn5h/QnAO
=fmOH
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
