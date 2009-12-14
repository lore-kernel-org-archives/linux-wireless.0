Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47256 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbZLNOYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 09:24:23 -0500
Received: by ewy19 with SMTP id 19so3428171ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 06:24:21 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 15:16:12 +0100
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net
References: <20091209211054.GB32058@tuxdriver.com>
In-Reply-To: <20091209211054.GB32058@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200912141516.12224.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 December 2009 10:10:55 pm John W. Linville wrote:
> Greetings,
> 
> So I'm tired of a) being asked how wireless-testing is managed; and,
> b) having trouble explaining it.  I think it is time to move to a
> more conventional process for wireless patches.
> 
> The main change I would like to make for now is to move wireless-2.6
> and wireless-next-2.6 to a default "immutable history" policy.
> By this I mean that I will strive to keep the history both clean
> and immutable in those trees.  If for some reason I can't make that
> happen and have to rebase those trees, I will make a loud and obvious
> announcement on the linux-wireless mailing list.  More likely, it
> means I may have to push an occasional revert through those trees
> that I might have otherwise avoided.
> 
> One of the ramifications of this will be that I will need to be
> extra careful about what gets merged into those trees.  I have been
> pushing patches into those trees quickly after merging them into
> wireless-testing, relying on linux-next to uncover some of the problems
> a quick review might miss.  Now I will need to have higher confidence
> in a patch before pushing it to wireless-next-2.6 or (especially)
> wireless-2.6, so some patches may take longer to get there.  All of
> your usual dilligent reviews are most helpful in this regard.
> 
> For now, the main change to wireless-testing will be that I will be
> pulling from wireless-2.6 and wireless-next-2.6 rather than reapplying
> most patches.  This should limit (and possibly eliminate) the confusing
> patch-revert-reapply-repeat practice I have been using there for a
> long time.  However, I still anticipate using w-t as a holding area
> for questionable patches.  So, at least some patches may still get
> the revert-reapply treatment.  I may ask Stephen to pull w-t into
> linux-next in order to expand testing of any such patches.
> 
> One advantage to this new process is that it will enable me to more
> readily accept actual git pull requests from driver/subsystem
> maintainers.  In order for this to work, those maintainers will need to
> send separate pull requests for fixes intended for the current release
> and for features intended for the next release.  They will also need to
> maintain their trees appropriately (i.e. separate trees or separate
> branches with appropriate bases) for this to work.  If anyone is
> interested in doing this, feel free to ask more questions.
> 
> Well, there is my overview.  Anyone have questions/objections/etc?

Thanks John!  This sounds great (especially w-t part) and addresses large
part of my past concerns regarding wireless/networking trees.

Now if only somebody could come up with a way to split 'monstermerges'
for Linus tree into something more fine-grained (thousands of commits in
a single merge is too much for anyone not directly involved into current
networking developments IMHO) I would be completely satisfied. ;)

--
Bartlomiej Zolnierkiewicz
