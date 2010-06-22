Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57985 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0FVPy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 11:54:26 -0400
Received: by pvh11 with SMTP id 11so438208pvh.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 08:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
References: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 08:54:05 -0700
Message-ID: <AANLkTilUuEtNWhzP-HUrUFjXqLpMkU_2_mp2uOcaBDGz@mail.gmail.com>
Subject: Re: ASPM status for iwlwifi and power-management (in general)
To: sedat.dilek@gmail.com
Cc: wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 22, 2010 at 3:44 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> yesterday, I was playing with PowerTop and my iwl3945 still is in the
> TOP 3 of energy user.
>
> Inspired by the recently published ASPM doc from Luis [2] I played a
> bit with ASPM.
>
> Currently, I am using a 2.6.35-rc3 Linux-kernel with latest
> acpi-2.6/release fixes.
>
> # dmesg | grep -i aspm
> [    0.226963] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe
> device.  You can enable it with 'pcie_aspm=force'
> [    0.227629] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe
> device.  You can enable it with 'pcie_aspm=force'
> [    0.228205] pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe
> device.  You can enable it with 'pcie_aspm=force'
>
> # for i in 01:00.0 08:00.0 10:00.0 ; do lspci -v | grep $i ; done
> 01:00.0 VGA compatible controller: ATI Technologies Inc M52 [Mobility
> Radeon X1300] (prog-if 00 [VGA controller])
> 08:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5753M
> Gigabit Ethernet PCI Express (rev 21)
> 10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
>
> # lspci -vvvv -s 10:00.0 | grep -i aspm
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
> <128ns, L1 <64us
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>
> Before I will try 'pcie_aspm=force' cheat-code

I should note I discourage the usage of pcie_aspm=force, it will try
to enable ASPM for all devices which do have the capability, and this
means when you are enabling it you are not only testing ASPM on the
device you had in mind but *all* devices capable of it.

> I wanted to ask about
> the status of iwlwifi and ASPM.
> Is there code available. yet?

Driver code for ASPM only exists to help tweak it if for whatever
reason it does need tweaking. An example is ath9k which disables the
PLL when it uses ASPM to save power. iwlagn or iwl3945 might have
similar stuff, but not sure. Technically drivers should not need any
code for ASPM unless its driver specific tweaks.

> Which kernel has it - linux-next,
> wireless-testing GIT, iwlwifi GIT?

ASPM can be used so long as you just have a PCIE bus. If the driver
has ASPM tweaks that's a different thing.

> Which user-space apps are required?

None.

> IIRC iw [3] from GIT has already "iw: add set/get power_save commands" [4].

That's different. Read:

http://wireless.kernel.org/en/users/Documentation/Power-consumption

  Luis

> Anyone tested ASPM with iwlwifi hardware? Experiences?
>
> Beyond ASPM code, what is the actual status on power-mangement for
> wifi-hardware in general?
> IIRC it was turned off by default (with 2.6.33?)?
>
> Thanks for any help in advance.
>
>
> Kind Regards,
> - Sedat -
>
>
> [1] http://wireless.kernel.org/en/users/Documentation/ASPM
> [2] http://marc.info/?l=linux-wireless&m=127716115227206&w=2
> [3] http://git.sipsolutions.net/?p=iw.git
> [4] http://git.sipsolutions.net/?p=iw.git;a=commit;h=cf40ef379fd6c74a01092d1dfdd936385ea402b0
>
