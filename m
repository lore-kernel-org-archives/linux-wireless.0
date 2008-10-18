Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:26787 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYJRXau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 19:30:50 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1246476wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 18 Oct 2008 16:30:50 -0700 (PDT)
Message-ID: <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com> (sfid-20081019_013054_664588_D8F12A2E)
Date: Sun, 19 Oct 2008 01:30:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dominik Brodowski" <linux@dominikbrodowski.net>,
	"reinette chatre" <reinette.chatre@intel.com>
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20081018231046.GA10977@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081018231046.GA10977@isilmar.linta.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 1:10 AM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> Hi,
>
> with current Linus' tree, I cannot connet my notebook to the AP any more.
>
> 02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
>        Subsystem: Intel Corporation PRO/Wireless 3945ABG Network Connection
>        Flags: bus master, fast devsel, latency 0, IRQ 380
>        Memory at f0300000 (32-bit, non-prefetchable) [size=4K]
>
> [   20.645198] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
> [   20.645337] iwl3945: Copyright(c) 2003-2008 Intel Corporation
> [   20.645767] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   20.645913] iwl3945 0000:02:00.0: setting latency timer to 64
> [   20.645996] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> [   20.708706] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> [   20.712625] phy0: Selected rate control algorithm 'iwl-3945-rs'
> [   20.733199] iwl3945 0000:02:00.0: PCI INT A disabled
> ...
> [   34.824476] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   34.824637] iwl3945 0000:02:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
> [   34.825269] iwl3945 0000:02:00.0: firmware: requesting iwlwifi-3945-1.ucode
> [   37.340901] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> [   37.340944] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4413 ser 0x0000004B
> [   37.342349] iwl3945: Can't stop Rx DMA.
>
> The iwlwifi-3945-1.ucode is the one shipped with Ubuntu's 2.6.24-21-generic
> kernel sources (md5sum: 26d10014b09439dc5a8573c2a6f85b0a ). And, as
> mentioned in the subject, 2.6.27 or 2.6.26 work perfectly fine.

I think you need new uCode, the API has changed to support stealth APs
.... I believe there was
some misscommunication...
Tomas
