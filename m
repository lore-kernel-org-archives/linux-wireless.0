Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:13734 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXJVP1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 11:27:48 -0400
Received: by py-out-1112.google.com with SMTP id u77so2512073pyb
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 08:27:48 -0700 (PDT)
Message-ID: <43e72e890710220827k2aa7a8d9m3653ec51ff461b32@mail.gmail.com> (sfid-20071022_162753_586196_5B25CD82)
Date: Mon, 22 Oct 2007 11:27:46 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710211316.06772.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200710211316.06772.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/07, Frans Pop <elendil@planet.nl> wrote:
> Hi,
>
> I just gave the new ath5k driver a go, but it fails for me with:
> pccard: CardBus card inserted into slot 0
> PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
> ath5k_pci 0000:02:00.0: can't get channels
>
> I did a git fetch of wireless/everything branch:
> $ git describe
> v2.6.23-469-g4bcbd55
>
> Modules were loaded automatically: mac80211 and ath5k.
>
> I was hoping for a better result as [1] lists my PCI ID as "OK", but maybe
> that is for the PCI version and not the PCMCIA one?
> The card works well with the madwifi driver (see below).
>
> The host system is a Toshiba Satellite A40 laptop (i386, Mobile Pentium 4)
> running Debian unstable.
>
> I can't help with coding, but am willing to test. Feel free ask for any
> additional info you need. Please CC me as I'm not subscribed.
>
> [1] http://linuxwireless.org/en/users/Drivers/ath5k
>
> Cheers,
> Frans Pop
>
> From lspci -nn:
> 01:0b.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support [1179:0617] (rev 33)
> 02:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5212 802.11abg NIC [168c:0013] (rev 01)
>
> From lspci -vv:
> 01:0b.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support (rev 33)
>         Subsystem: Toshiba America Info Systems Unknown device 0001
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 168
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at cff00000 (32-bit, non-prefetchable) [size=4K]
>         Bus: primary=01, secondary=02, subordinate=02, sec-latency=0
>         Memory window 0: 28000000-2bfff000 (prefetchable)
>         Memory window 1: 30000000-33fff000
>         I/O window 0: 0000c000-0000c0ff
>         I/O window 1: 0000c400-0000c4ff
>         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
>         16-bit legacy interface ports at 0001
>
> 02:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
>         Subsystem: Global Sun Technology Inc Unknown device 7103
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at 30000000 (32-bit, non-prefetchable) [size=64K]

Get this line again from lspci, and for example if its 30000000 again
run from madwifi:

./tools/ath_info 0x30000000

Note I'm prepending the "0x", otherwise use whatever address it gives you.

  Luis
