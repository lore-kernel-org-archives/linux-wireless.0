Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42178 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3JRSPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 14:15:23 -0400
Date: Fri, 18 Oct 2013 14:00:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.13] NFC updates
Message-ID: <20131018180021.GF28130@tuxdriver.com> (sfid-20131018_201532_117291_01BEC430)
References: <20131015161917.GF30191@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131015161917.GF30191@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 15, 2013 at 06:19:17PM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the first NFC pull request for the 3.13 kernel.
> 
> It's a fairly big one, with the following highlights:
> 
> - NFC digital layer implementation: Most NFC chipsets implement the NFC
>   digital layer in firmware, but others have more basic functionalities
>   and expect the host to implement the digital layer. This layer sits
>   below the NFC core.
> 
> - Sony's port100 support: This is "soft" NFC USB dongle that expects the
>   digital layer to be implemented on the host. This is the first user of
>   our NFC digital stack implementation.
> 
> - Secure element API: We now provide a netlink API for enabling,
>   disabling and discovering NFC attached (embedded or UICC ones) secure
>   elements. With some userspace help, this allows us to support NFC
>   payments.
>   Only the pn544 driver currently supports that API.
> 
> - NCI SPI fixes and improvements: In order to support NCI devices over
>   SPI, we fixed and improved our NCI/SPI implementation. The currently
>   most deployed NFC NCI chipset, Broadcom's bcm2079x, supports that mode
>   and we're planning to use our NCI/SPI framework to implement a
>   driver for it.
> 
> - pn533 fragmentation support in target mode: This was the only missing
>   feature from our pn533 impementation. We now support fragmentation in
>   both Tx and Rx modes, in target mode.
> 
> The following changes since commit b75ff5e84bb6c2d43a8ec39b240c80f0543821f0:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-09-19 13:57:28 -0500)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.13-1
> 
> for you to fetch changes up to ddc1a70b5f2a07a932ed31f989d63937bb813439:
> 
>   NFC: Fix SE API related sparse warning (2013-10-07 14:18:44 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
