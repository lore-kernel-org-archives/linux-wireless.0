Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49323 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2GFSs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 14:48:28 -0400
Date: Fri, 6 Jul 2012 14:35:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/18] brcmsmac: update to get SoCs working
Message-ID: <20120706183547.GC2353@tuxdriver.com> (sfid-20120706_204832_841469_2FE9FCA5)
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <4FF29B89.3040300@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF29B89.3040300@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 03, 2012 at 09:13:13AM +0200, Arend van Spriel wrote:
> On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> > This series contains some patches needed to get brcmsmac working on 
> > SoCs like the BCM4718.
> > The last part which adds core rev 17 (used in the BCM4718) to the list 
> > of supported cores is missing, because we do not have a firmware 
> > supporting this core yet, but I extended the b43 fwcutter to generate 
> > a firmware which brcmsmac accepts. With this firmware my BCM4718 
> > works. I would appreciate an official firmware release from Broadcom 
> > adding support for this core.
> > The final patch adding support for the BCM43224 is missing because 
> > the PCIe host controller on the BCM4718 still causes problems and I 
> > have to add some more read after writes into the code, for now it uses 
> > an ugly hack and sometimes the problems still occur.
> > 
> > The wifi is not stable on the BCM4718, I had no problems connecting to 
> > my ath9k driven access point but I have problems connecting to my 
> > BCM47186 based AP running the vendor firmware with the Broadcom 
> > proprietary driver.
> > I get 12MBit/s max with the BCM4718 connected to ath9k on the 2.4 GHz 
> > band and 35 MBit/s max with the BCM43224 on the 5Ghz band connected to 
> > a Broadcom based AP running the proprietary driver. This seams to be 
> > CPU bounced as I have over 50% sirq in both cases.
> > 
> > brcmsmac starts on the BCM47186 (id: 0x5357), but it does not tx or rx 
> > any traffic.
> > 
> > One patch extends the xmtfifo_sz array for more core revs, I just toke 
> > the values from the other phy-n cores and hope this is correct.
> > 
> > These patches are depending on: "[PATCH v2 0/9] bcma misc updates" and 
> > based on wireless-testing.
> > 
> > I will send a patch for bcma which converts the warning message when it 
> > found a PCI and not a PCIe card into a WARN.
> > 
> > v2:
> >   - when something depends on a patch for bcma, which is not in 
> >     wireless-testing yet, I add that to the commit comment.
> >   - removed changes for BCM43421 and BCM6362 as I do not have a device
> >     to test this.
> >   - xmtfifo_sz now starts at core rev 17 and contains the correct values 
> >     for core rev 28
> >   - make brcms_c_chipmatch() also work for SoCs
> >   - typos and format changes
> > 
> 
> I have acked all patches, but would like to do some sanity testing today.

Have you had a chance to do this testing?  Are you OK with this series?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
