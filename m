Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1FUNiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:38:51 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com> (sfid-20110620_204449_827132_DD43A304)
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 (sfid-20110620_204449_827132_DD43A304)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 15:38:46 +0200
Message-ID: <1308663526.4276.2.camel@jlt3.sipsolutions.net> (sfid-20110621_153854_193280_A04737D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 14:44 -0400, Andrew Lutomirski wrote:
> On 3.0-git today, I get:
> 
> [   40.142872] DRHD: handling fault status reg 2
> [   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
> [   40.142896] DMAR:[fault reason 05] PTE Write access is not set
> 
> lspci says:
> 
> 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> 
> This seems to be triggered by interface state changes.  The driver
> still works.  I don't see this on 2.6.39.1.

Thanks Andy. Do you happen to know if there's any way to figure out what
ffe38000 was? Clearly the device is attempting to write something that
we haven't mapped properly, but I'm not sure _what_?

johannes

