Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:34653 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754403AbcAVSFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 13:05:32 -0500
Message-ID: <1453485926.13870.27.camel@perches.com> (sfid-20160122_190537_172502_748F086F)
Subject: Re: wireless-drivers: random cleanup patches piling up
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jan 2016 10:05:26 -0800
In-Reply-To: <20160122151211.GB1500@tuxdriver.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	 <1453423965.3856.22.camel@perches.com>
	 <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
	 <20160122151211.GB1500@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-01-22 at 10:12 -0500, John W. Linville wrote:
> On Fri, Jan 22, 2016 at 02:21:20PM +0200, Kalle Valo wrote:
> > Joe Perches <joe@perches.com> writes:
> > 
> > > On Thu, 2016-01-21 at 16:58 +0200, Kalle Valo wrote:
> > > > Hi,
> > > > 
> > > > I have quite a lot of random cleanup patches from new developers waiting
> > > > in my queue:
> > > > 
> > > > https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
> > > > 
> > > > (Not all of them are cleanup patches, there are also few patches
> > > > deferred due to other reasons, but you get the idea.)
> > > > 
> > > > These cleanup patches usually take quite a lot of my time and I'm
> > > > starting to doubt the benefit, compared to the time needed to dig
> > > > through them and figuring out what to apply. And this is of course time
> > > > away from other patches, so it's slowing down "real" development.
> > > > 
> > > > I really don't know what to do. Part of me is saying that I just should
> > > > drop them unless it's reviewed by a more experienced developer but on
> > > > the other hand this is a good way get new developers onboard.
> > > > 
> > > > What others think? Are these kind of patches useful?
> > > 
> > > Some yes, mostly not really.
> > > 
> > > While whitespace style patches have some small value,
> > > very few of the new contributors that use tools like
> > > "scripts/checkpatch.pl -f" on various kernel files 
> > > actually continue on to submit actual defect fixing
> > > or optimization or code clarity patches.
> > 
> > That's also my experience from maintaining wireless-drivers for a year,
> > this seems to be a "hit and run" type of phenomenon.
> 
> Should we be looking for someone to run a "wireless-driver-cleanups"
> tree?  They could handle the cleanups and trivial stuff, and send
> you a pull request a couple of times per release...?

If you are really interested in this sort of code cleanup,
and not in a new developer that might show up because of
a "my first kernel patch" process, maybe it'd be better
to do a preemptive run of something like:

$ git ls-files drivers/net/wireless | \
  while read file ; do \
    ./scripts/checkpatch.pl -f --fix-inplace --types=spacing $file ; \
  done

with git diff -w, compile every modified file, use objdiff, etc.
and a commit per subdirectory or driver.

A problem with that is checkpatch messages really aren't
dicta and there are some things that maybe look nicer
before the script mucks them up.

For instance, in the first file from that pass:

drivers/net/wireless/admtek/adm8211.c
[]
@@ -273,7 +273,7 @@ static void adm8211_write_sram_bytes(struct ieee80211_hw *dev
                }
        } else {
                for (i = 0; i < len; i += 4) {
-                       u32 val = (buf[i + 0] << 0 ) | (buf[i + 1] << 8 ) |
+                       u32 val = (buf[i + 0] << 0) | (buf[i + 1] << 8 ) |
                                  (buf[i + 2] << 16) | (buf[i + 3] << 24);
                        adm8211_write_sram(dev, addr + i / 4, val);
                }

You could reasonably argue that the "<< 0 )" was used
for alignment and doesn't need to be changed.  Perhaps
this should be "<<  0)" instead.

But a better change would be not be a whitespace change
but "get_unaligned_le32(buf + i)", maybe removing the
temporary too.

And there's an equivalent change that could use
get_unaligned_le16 in the preceding block that
checkpatch doesn't flag.

Anyway, a trivial change like the first block I looked
at could be done automatically, but it really doesn't
improve the code much.

