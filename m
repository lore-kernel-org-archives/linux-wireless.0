Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:41072 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751536AbdINJ1p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 05:27:45 -0400
Date: Thu, 14 Sep 2017 19:27:39 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170914092738.GG20283@us.netrek.org> (sfid-20170914_112749_257471_CD5E683D)
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 13, 2017 at 07:39:35PM -0500, Larry Finger wrote:
> On 09/13/2017 04:46 PM, James Cameron wrote:
> >
> >I'll give it some more testing and let you know, but it seems as
> >capable of keeping a connection as 4.13 plus my earlier revert.
> >

Testing went well; removing the call to enable ASPM was as good as
changing the DBI read back to 16-bit width.

> The change I sent earlier should be as good as reverting the change
> to write_byte in your reversion.

Yes, that would be the hope.

But with the 16-bit DBI read, the register REG_DBI_CTRL+0 is being
read as well, in the first read in _rtl8821ae_enable_aspm_back_door,
so perhaps reading that register has an unexpected side-effect.

Is there any documentation for that register?  I see other code writes
to REG_DBI_CTRL+3, in _rtl8821ae_check_pcie_dma_hang

Evidence of read from REG_DBI_CTRL was captured with an instrumented
kernel; git diff http://dev.laptop.org/~quozl/y/1dsQ6B.txt yielding
these dmesg lines;

[    6.010255] rtl_pci: _rtl_pci_update_default_setting const_amdpci_aspm=03
[    6.010338] rtl_pci: rtl_pci_enable_aspm
[    6.034295] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    6.034806] rtlwifi: rtlwifi: wireless switch is on
[    6.196958] rtl8821ae 0000:02:00.0 wlp2s0: renamed from wlan0
[    7.979186] rtl_pci: rtl_pci_disable_aspm
[    7.979306] rtl8821ae: _rtl8821ae_check_pcie_dma_hang
[    8.295360] rtl8821ae: _rtl8821ae_enable_aspm_back_door
[    8.295437] rtl8821ae: _rtl8821ae_dbi_read  070f -> ffff (@034f)
[    8.295449] rtl8821ae: _rtl8821ae_dbi_write 070f <- ff (@870c)
[    8.295462] rtl8821ae: _rtl8821ae_dbi_read  0719 -> 0200 (@034d)
[    8.295474] rtl8821ae: _rtl8821ae_dbi_write 0719 <- 18 (@2718)
[    8.295477] rtl_pci: rtl_pci_enable_aspm
[    8.469734] rtl_pci: rtl_pci_disable_aspm
[    8.469857] rtl8821ae: _rtl8821ae_check_pcie_dma_hang
[    8.686955] rtl8821ae: _rtl8821ae_enable_aspm_back_door
[    8.687013] rtl8821ae: _rtl8821ae_dbi_read  070f -> ffff (@034f)
[    8.687025] rtl8821ae: _rtl8821ae_dbi_write 070f <- ff (@870c)
[    8.687038] rtl8821ae: _rtl8821ae_dbi_read  0719 -> 0218 (@034d)
[    8.687050] rtl8821ae: _rtl8821ae_dbi_write 0719 <- 18 (@2718)
[    8.687053] rtl_pci: rtl_pci_enable_aspm

Observe how the windowed read of DBI register 0x70f causes a read of
16-bits at 0x34f, which includes first 8-bits of 0x350 REG_DBI_CTRL.

By the way, the cold boot value of DBI register 0x719 is 0x00, and
the warm boot value is 0x18, so I'm confident there isn't a
comprehensive register reset.  It means that BIOS has relevance; and
this BIOS is outside my control.  BIOS variation may explain
difficulty reproducing.

> There has been a report (in Russian unfortunately) at
> https://www.linux.org.ru/forum/desktop/12620193 of delays in ARP
> handling.

Thanks.  I've considered and excluded ARP handling delay.  Though ARP
renewal is typical reason for device sleep to end.

With the call to enable ASPM disabled, instead of changing the DBI
read to 16-bit width, what happens is that the device stops accepting
data from the access point, packets are buffered there, and are
transmitted as soon as the device makes the next transmission.

http://dev.laptop.org/~quozl/z/1dsQBf.txt has the ping and IP tcpdump
to confirm this.

I've a monitor mode tcpdump I can send by private mail if required.
In that the burst of packets shows ICMP echo requests were buffered by
the access point.

> According to Google translate is as follows:
> 
> ============================================================
> Periodically, Wi-Fi networker rtl8821ae ceases to respond to ARP,
> which causes the Internet to end. Wireshark looks quite interesting:
> ARP replays can be sent by one large packet a few seconds after
> receiving the requests, ie. they seem to be buffered somewhere.

Yes, buffering at access point.

> I need to explore that ENOBUFS return code.

I've seen ENOBUFS up at the application level with ping too, when the
original problem happens with v4.10 plus stable.

> Your case where the device is unresponsive to pings from another NIC
> until the device transmits may also be an ARP problem.
> 
> For completeness, are you using the 2.4 of 5 GHz band? What is the
> make/model your AP? If possible for you to determine, what firmware
> is it running?

2.4 GHz and 5 GHz reproduces the problem.

Open or WPA reproduces the problem.

Netgear WNDR3800 OpenWrt 12.09-beta, r33312.

Several other access points reproduce the problem, including a
customer's TP-Link TL-WR1042ND with unknown firmware version.

No access point as yet does not reproduce the problem.

Hope that helps, thanks for your ideas.

-- 
James Cameron
http://quozl.netrek.org/
