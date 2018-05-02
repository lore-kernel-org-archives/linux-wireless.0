Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42382 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751347AbeEBIAf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 04:00:35 -0400
Message-ID: <c6315e121c63cfc1e23ec7c84bba0334f75eeed1.camel@coelho.fi> (sfid-20180502_100319_415361_5F51E00B)
From: Luca Coelho <luca@coelho.fi>
To: Stephen Wille Padnos <steve@thothsystems.com>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Date: Wed, 02 May 2018 11:00:32 +0300
In-Reply-To: <3e72561c-c531-95c3-5fc8-b195ce8dae4b@thothsystems.com>
References: <3e72561c-c531-95c3-5fc8-b195ce8dae4b@thothsystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Patch: Support Killer 1550 in MSI laptop
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-01 at 11:51 -0400, Stephen Wille Padnos wrote:
> Hello, all
> 
> I have an MSI 8th-gen notebook with a Killer 1550 wifi card.  This
> card 
> has a different subsystem ID than I have seen in prior patches:
> 
> Output of lspci -nnvvv:
> 00:14.3 Network controller [0280]: Intel Corporation Wireless-AC
> 9560 
> [Jefferson Peak] [8086:a370] (rev 10)
>      Subsystem: Bigfoot Networks, Inc. Device [1a56:1552]
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- 
> Stepping- SERR- FastB2B- DisINTx+
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>      Latency: 0, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 16
>      Region 0: Memory at ad414000 (64-bit, non-prefetchable)
> [size=16K]
>      Capabilities: <access denied>
>      Kernel driver in use: iwlwifi
>      Kernel modules: iwlwifi
> 
> Without this patch no driver is shown, not even pci_stub. This has
> been 
> tested on my laptop, and only on my home wifi which is wireless-N,
> not 
> -AC (no 5GHz).  The speed seems to be slower than the Windows
> driver, 
> but at least this gets the device recognized and working.
> 
> Signed-off-by: Stephen Wille Padnos
> ---

We have a patch that will add the Killer wifi cards to our list of
supported devices.  They will be pushed upstream as soon as we iron out
some final details.

--
Cheers,
Luca.
