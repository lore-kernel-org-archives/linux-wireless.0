Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbeACLpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 06:45:38 -0500
Date: Wed, 3 Jan 2018 12:45:37 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180103114536.GB10306@redhat.com> (sfid-20180103_124542_471881_3C0A551D)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
 <20171213152017.GA3554@redhat.com>
 <alpine.LNX.2.21.99.1712261820080.22705@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1712261820080.22705@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 26, 2017 at 06:20:22PM +0100, Enrico Mioso wrote:
> Ok, observing a stall. Unfortunately, it still happens.
<snip>
> rt2800_wmac 10180000.wmac: loaded eeprom from mtd device "factory"
> ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 2872, rev 0200 detected
> ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected

Is possible that this is the FW problem for this particular RT2872
device or we do not correctly program registers for it. 

I think the issue is that at some point HW/FW is not capable to sent 
frames and do not report to driver failure of sending frames, hence
driver queue can not be moved forward. The solution to this will be
timeout mechanism for TX, similar like for rt2800usb, however this will
require substantial rt2800pci/mmio driver rewrite. I'm going to look
at this, but not sure when.

Cheers
Stanislaw
