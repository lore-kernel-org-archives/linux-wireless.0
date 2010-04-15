Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39899 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab0DOQ6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 12:58:08 -0400
Message-ID: <4BC74598.8060504@openwrt.org>
Date: Thu, 15 Apr 2010 18:58:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/97] ath9k: add AR9003 support
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-15 5:29 AM, Luis R. Rodriguez wrote:
> Here's a respin of our last series for AR9003 support. We've taken
> the feedback given and made a few respective changes. The initval
> Lindent patch was completely removed, instead we figure we'll address
> a new style for the new initvals after this series. We've fixed a few
> bugs while addressing some of the feedback, and at the same time have
> taken the time to merge a few patches together where it made sense,
> namely in the EEPROM area.
> 
> All these patches have been tested with sparse v0.4.2 and checkpatch.pl,
> the only remaining complaints you'll see are for volatile use for gcc
> bug #37014 [1], one false positive which we need to fix upstream on
> checkpatch [2], and the usual WARNINGs for > 80 lines on header files
> for macros, and just a few places in code where it was just not
> a good idea yet to split the code to avoid the 80 column length.
> 
> The new style for the initvals will be addressed by using a userspace
> program [3] which reads the existing initvals and regenerates it at our will.
> This same program was also used by us to verify the integrity of the
> initvals during our code shuffle, the checksums for existing wireless-testing
> and after this patch series matches.
> 
> Worth noting also is we have disabled ANI, although it has been
> working for us, our systems team has not completed its testing
> yet so no point in filing bugs for it if its not working yet :)
> TX interrupt mitigation is also disabled due to pervious issues we
> (ath9k) have seen with AR9280, we'll enable it later after some more
> testing.
> 
> I'll note I've used -M on this patch series on forma-patch, please let
> me know if there are any issues with it.
> 
> [1] http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37014
> [2] ERROR: trailing statements should be on next line
> #576: FILE: drivers/net/wireless/ath/ath9k/recv.c:734:
> +       while (ath_edma_get_buffers(sc, qtype));
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/initvals.git
John, please don't merge this series just yet. I'm still working on
tracking down a few more bugs in it.

- Felix
