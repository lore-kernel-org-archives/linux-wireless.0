Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:59205 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbXJLGsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 02:48:20 -0400
Received: by py-out-1112.google.com with SMTP id u77so1490461pyb
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 23:48:18 -0700 (PDT)
Message-ID: <40f31dec0710112348s79d652c9j6d6f9701a641a24f@mail.gmail.com> (sfid-20071012_074827_901304_670C21D4)
Date: Fri, 12 Oct 2007 06:48:17 +0000
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [Oops] EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k] (2.6.23, latest wireless git)
Cc: "Frank de Lange" <lkml-f@unternet.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <470EFD24.7020206@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071011230030.GA6725@unternet.org> <470EFD24.7020206@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you plz run ath_info tool found in madwifi/tools directory and
post here the output ???

2007/10/12, Patrick McHardy <kaber@trash.net>:
> Frank de Lange wrote:
> > Just got an Atheros-based card from eBay, stuffed it into my Thinkpad
> > T23 (ignoring the complaints about two ethernet cards being installed)
> > and got myself this Oops:
> >
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000000
> >  [...]
> > CPU:    0
> >    Not tainted VLI
> > EFLAGS: 00010246   (2.6.23-t23-01 #3)
> > EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k]
>
>
> I had the same Oops with the internal card of a Thinkpad T42.
> The reason is that the rate table lookup for MODE_ATHEROS_TURBOG
> returns NULL because the capability bit is not set. I haven't
> tracked down the cause yet, but this patch fixes the Oops for me.
>
> On a related issue, the same card can receive packets fine,
> but all packets sent are received with the first 16 bytes of
> ethernet and IP header missing (the remaining data is fine).
> I didn't find the cause for this either, the packet appears
> to be fine up to the tx function. Anyone have a hint where to
> continue looking? Could this be related to the missing
> capability bit and an incorrect rate table being used?
>
> lspci -vvv:
>
> 02:02.0 Ethernet controller: Atheros Communications, Inc. AR5212
> 802.11abg NIC (rev 01)
>         Subsystem: AMBIT Microsystem Corp. Unknown device 0408
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at c0210000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>
> iwconfig output:
>
> ath0      IEEE 802.11b  ESSID:"wlan"
>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
>           Tx-Power=27 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2346 B
>           Encryption key:[...]
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index ae4c5b5..8018af5 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -499,9 +499,10 @@ const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
>  {
>         AR5K_TRACE;
>
> +#if 0
>         if (!test_bit(mode, hal->ah_capabilities.cap_mode))
>                 return NULL;
> -
> +#endif
>         /* Get rate tables */
>         switch (mode) {
>         case MODE_IEEE80211A:
>
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
