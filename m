Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2KFMyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 07:54:49 -0500
Date: Tue, 6 Nov 2012 13:54:47 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Piotr Haber <phaber@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121106125447.GC17892@ubuntu-mba51> (sfid-20121106_135500_977285_BA897E1B)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <5098B858.7090802@monom.org>
 <5098C7FF.2060308@monom.org>
 <5098E488.5020206@broadcom.com>
 <5098EA0C.1020806@broadcom.com>
 <5099023E.70506@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5099023E.70506@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2012 at 01:27:42PM +0100, Daniel Wagner wrote:
> Hi Piotr,
> 
> On 06.11.2012 11:44, Piotr Haber wrote:
> > On 11/06/12 11:20, Arend van Spriel wrote:
> >> On 11/06/2012 09:19 AM, Daniel Wagner wrote:
> >>> On 06.11.2012 08:12, Daniel Wagner wrote:
> >>>> Hi Seth,
> >>>>
> >>>> I am owner of a MBA 2012 and the mainline driver is kind of 'not fun'
> >>>> (read broken). Since a few days I am using it and the situation improved
> >>>
> >>> it = your patch set on top of 3.7-rc3
> >>>
> >>> (/me should not write emails right after getting up)
> >>>
> >>>
> >>
> >> Just looked at the screen shots. Only could read the last one. It seems
> >> to indicate a problem in the receive path.
> >>
> >> Gr. AvS
> > Hi Daniel,
> > 
> > could you describe your hardware (lspci -nn), infrastructure (iw wlanx
> > link/scan) and kernel version?
> 
> Sure, forgot to include this details in the beginning.
> 
> $ lspci -nn
> 00:00.0 Host bridge [0600]: Intel Corporation Ivy Bridge DRAM Controller [8086:0154] (rev 09)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Device [8086:0166] (rev 09)
> 00:14.0 USB Controller [0c03]: Intel Corporation Panther Point USB xHCI Host Controller [8086:1e31] (rev 04)
> 00:16.0 Communication controller [0780]: Intel Corporation Panther Point MEI Controller #1 [8086:1e3a] (rev 04)
> 00:1a.0 USB Controller [0c03]: Intel Corporation Panther Point USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
> 00:1b.0 Audio device [0403]: Intel Corporation Panther Point High Definition Audio Controller [8086:1e20] (rev 04)
> 00:1c.0 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 1 [8086:1e10] (rev c4)
> 00:1c.1 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 2 [8086:1e12] (rev c4)
> 00:1c.4 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 5 [8086:1e18] (rev c4)
> 00:1d.0 USB Controller [0c03]: Intel Corporation Panther Point USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
> 00:1f.0 ISA bridge [0601]: Intel Corporation Panther Point LPC Controller [8086:1e56] (rev 04)
> 00:1f.2 SATA controller [0106]: Intel Corporation Panther Point 6 port SATA AHCI Controller [8086:1e03] (rev 04)
> 00:1f.3 SMBus [0c05]: Intel Corporation Panther Point SMBus Controller [8086:1e22] (rev 04)
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/g/n [14e4:4353] (rev 01)
> 
> 
> $ iw wlan0 link
> Connected to 10:8c:cf:b5:f7:4f (on wlan0)
>         SSID: Linux Foundation

<snip>

I'm running with the same card in the same environment but haven't had
any problems at all.

> I applied the patches on top of Linus' tree:
> 
> 1e207eb1c3f0e8b690401f02fe08e7b53903f010
> 
> > I was trying Seth's patches with 4313 and 43224 devices on 3.7-rc3 as
> > well and did not run into anything like this.
> 
> What I did was to resume the laptop and told ConnMan me that the automatic
> connect to to connect to 'Linux Foundation' network failed and then I told
> ConnMan to try again to connect. That triggered the panic.  I don't have 
> any logs for this. 

Do you have logs for the failed connection attempt before the panic? If
so I'd be interested in seeing them.

Seth

