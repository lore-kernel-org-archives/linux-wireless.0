Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45577 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1DYRPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:15:49 -0400
Date: Mon, 25 Apr 2011 13:07:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	ath9k-devel@venema.h4ckr.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	stable@kernel.org
Subject: Re: ath9k: Regression in 2.6.38 (30% package losses, ~20KBit/s
 throughput) with AR9285
Message-ID: <20110425170750.GB28814@tuxdriver.com> (sfid-20110425_191553_104474_2E517A90)
References: <4DB56E5B.4090101@hauke-m.de>
 <4DB57180.40208@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DB57180.40208@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You can send stuff to stable yourself.  The main rule is that it is
already in Linus's tree...

Stable folks, please apply 115dad7a7f42e68840392767323ceb9306dbdb36
for the 2.6.38.y tree.

John

On Mon, Apr 25, 2011 at 03:05:04PM +0200, Hauke Mehrtens wrote:
> On 04/25/2011 02:51 PM, Hauke Mehrtens wrote:
> > Hi,
> > 
> > with kernel 2.6.38 the wifi connection with my Atheros AR9285 is
> > unusable when the distance from the AP is more that 3 meters. (30%
> > package losses, ~20K/s throughput compared to ~3M/s) Tested with two
> > cards on different devices. With kernel 2.6.35 or kernel 2.6.38 +
> > compat-wireless 15 meters distance is no problem. The problem only
> > occurs in 2.6.38-rc1 to 2.6.38.4 but not in any more recent versions. I
> > did a git bisect and found the commit fixing the problem.
> > 
> > commit 115dad7a7f42e68840392767323ceb9306dbdb36
> > Author: Felix Fietkau <nbd@openwrt.org>
> > Date:   Fri Jan 14 00:06:27 2011 +0100
> > 
> >     ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"
> > 
> > http://www.spinics.net/lists/linux-wireless/msg62742.html
> > 
> > Please send this commit to the stable series for 2.6.38.
> > 
> > The problem is also described at the Ubuntu launchpad:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/735431
> > 
> > Hauke
> 
> I linked to a wrong Ubuntu Launchpad bug report. This is a correct one,
> but there many many:
> https://bugs.launchpad.net/archlinux/+source/linux/+bug/735171
> 
> Here is also a description in the kernel bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=31452
> 
> Hauke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
