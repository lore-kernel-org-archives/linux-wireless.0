Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3225 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYKPFx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 00:53:57 -0500
Date: Sun, 16 Nov 2008 00:53:12 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan McGee <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081116055312.GA14126@hash.localnet> (sfid-20081116_065400_164426_554CEED4)
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com> <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com> <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com> <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com> <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com> <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 09:48:13PM -0800, Luis R. Rodriguez wrote:
> Not sure why its 00000001, nor do I know if its poison. One thing I am
> fairly positive about is that the reason why this was wrong all along
> was because we were trying to get the device's ->driver structure to
> get driver->name but the device won't get its ->driver pointer
> assigned until *after* a successful probe. Lets review the PCI probe:

No, as I later corrected myself, that is pci_dev->driver, but what
mac80211 is using is pci_dev->dev.driver.  Which actually happens to be
set up fine.  (I verified this by inserting a printk into the ath5k
driver and it all works fine.)

> Yeah don't bother, the issue on this e-mail was fixed, another issue
> has come up though so that is separate.

I think the second issue is just the first issue, but the fix papered
over the first bug.

-- 
Bob Copeland %% www.bobcopeland.com

