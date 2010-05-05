Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57224 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0EES7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 14:59:09 -0400
Received: by fxm10 with SMTP id 10so4534678fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 May 2010 11:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE1B2DF.8070506@lwfinger.net>
References: <4BE1B2DF.8070506@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 5 May 2010 20:58:47 +0200
Message-ID: <AANLkTilJFWACm4GYM0QwWywdVzLc1I-0C64lPMoQbHPX@mail.gmail.com>
Subject: Re: First results with netbook from John
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One thing to try: swap the cards between the laptop and the netbook,
to check if the differences depend on the card or the system.

On Wed, May 5, 2010 at 8:03 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I received the netbook from John last Saturday. It took a while to get
> it integrated into my network as this is my first Fedora system, but I
> now have some results to report.
>
> I loaded wl logging both MMIO and PCI configuration register reads and
> writes. The two types are now interleaved. The latter are logged with
> trace_printk() calls. Note: There is a bug in current kernel code that
> keeps these calls from being logged. Thanks to Stephen Rostedt for
> sorting out this problem.
>
> Both systems have the same core sequence and the same revisions. The
> cores in order are ChipCommon rev 0x16, IEEE 802.11 rev 0x0F, PCMCIA rev
> 0x0A, and PCI-E rev 0x09.
>
> I now know for certain that the netbook has an SPROM at offset 0x800.
> Trying to read at offset 0x1000, which is the SPROM location in the
> laptop, locks the machine, thus we need to determine the SPROM location
> without reading 0x1000.
>
> Fortunately, the wl driver reads and writes PCI configuration space from
> the Linux shim code, not from the binary blob, thus these operations can
> be traced.
>
> The _only_ differences between the laptop and netbook operations between
> startup and the reading of the SPROM are as follows:
>
> Register           Laptop           Netbook     Explanation
>
> PCI 0x0C             0x10            0x08       Cache Line Size
> PCI 0x04       0x00100106     0x001000006       Command Features [1]
> Core 0 0x2C          0x10            0x12       Chip Status Reg [2]
> Core 3 0x800       0x2801          0x3801       On laptop 0x3801 written
> Core 3 0x280a      0x6dbe          0xedbe       On laptop 0xedbe written
>
> The code then switches to Core 1 (802.11) and begins reading SPROM. On
> the laptop, it reads from 0x1000 and does a try at the smaller size
> SPROM, then switches to the larger size, just as ssb does. On the
> netbook, it immediately reads the larger size at offset 0x800.
>
> I have not yet looked closely at the differences between wl and ssb, but
> I did note one difference. In wl, bits 0xFF00 are cleared in PCI
> register 0x40. The only thing I could find is this code fragment from
> ipw2100 and ipw2200:
>
>   /* We disable the RETRY_TIMEOUT register (0x41) to keep
>    * PCI Tx retries from interfering with C3 CPU state */
>   pci_read_config_dword(pdev, 0x40, &val);
>   if ((val & 0x0000ff00) != 0)
>       pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
>
> Larry
>
> [1] The Wikipedia article on PCI configuration space says that this is a
> bitmask of features that can be enabled/disabled. I have no explanation
> of the details.
>
> [2] This extra bit looks most promising of all the differences. It is
> the bit involved in the is_sprom_available() routine for the 4315 device
> in the Broadcom driver that has been reverse engineered; however, the
> definition must have changed as that code would say there is no SPROM,
> which is clearly untrue.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
