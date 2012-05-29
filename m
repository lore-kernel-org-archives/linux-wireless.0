Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55378 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2E2MNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:13:24 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20420.48433.260465.183715@gargle.gargle.HOWL> (sfid-20120529_141328_380245_C764FA9A)
Date: Tue, 29 May 2012 17:42:33 +0530
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
In-Reply-To: <201205291212.46377.tvrtko.ursulin@onelan.co.uk>
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk>
	<201205281528.15852.tvrtko.ursulin@onelan.co.uk>
	<20420.41522.130102.644989@gargle.gargle.HOWL>
	<201205291212.46377.tvrtko.ursulin@onelan.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tvrtko Ursulin wrote:
> I've collected several interesting events but the compressed log is quite 
> large. Not sure if it will make it to the mailing list, but you should at 
> least get it privately.

Thanks.

> There are events ranging from short to long connection dropouts (in the light 
> of that it is possible that the path Mohammed suggested did indeed help, at 
> least partially to unwedge some situation which would hang it completely 
> without the patch). There is always mention of the 'DMA' keyword when it 
> happens, so if you grep for that in my log you will see events happening at, 
> in printk time:
> 
> 118.779362 - 118.795238 (WARN_ON WARNING: at 
> drivers/net/wireless/ath/ath9k/recv.c:531 ath_stoprecv+0x118/0x130 [ath9k]())
> 
> 524.162432 - 524.753750
> 1544.610658 - 1550.218324
> 1685.668241 - 1686.991166
> 1773.268867 - 1804.465933
> 
> Hope this helps?

Yes !

Here are a couple of patches to help narrow down the issue.

http://sujith.github.com/patches/wl/0001-ath9k-Add-some-debug-messages.patch
http://sujith.github.com/patches/wl/0002-ath9k-Resync-beacons-after-a-reset.patch

The first one adds some messages, the second sets up beacons properly in case
a HW reset happens. Can you try these and post the log ?

If you are willing to move to a more recent kernel, then current wireless-testing
would be a good choice since it has various driver fixes. There are a few
pending ath9k patches which have not been merged yet, you can find it here:

http://sujith.github.com/patches/wl/wl-ath9k-May-29-2012.patch

Sujith
