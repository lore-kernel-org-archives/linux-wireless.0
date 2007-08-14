Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3597 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766013AbXHNUGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 16:06:45 -0400
Date: Tue, 14 Aug 2007 15:43:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bcm43xx-dev@lists.berlios.de, ipw3945-devel@lists.sourceforge.net,
	rt2400-devel@lists.sourceforge.net
Subject: wireless-dev rebased, new rebasing policies
Message-ID: <20070814194352.GG7198@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings!

Some of you have already noticed that the wireless-dev tree has
been rebased.  I adopted the mac80211 work of Jiri Benc as a base,
then re-imported all of the mac80211 drivers (and the SSB stuff) from
wireless-dev into individual branches.  There is also an 'everything'
branch into which all the other branches get pulled, and an 'mm-master'
branch which has the sole purpose of feeding patches to akpm while
minimizing conflicts with the other networking trees.  The master
branch is a direct pull of something relatively recent from Linus,
usually an -rc or release tag.

Recent versions of git seem to hide remote branches by default when
cloning a tree, so by default you will just get my master branch.
Since this isn't very interesting for wireless development, you will
want to recreate one or more of my branches to work from as a base.

At a minimum, everyone from "early adopter" users to driver maintainers
will want the 'everything' branch, so I will illustrate recreating
that below.  Other branches are done similarly.

/home/linville/git/wireless-dev
[linville-t43.mobile]:> git branch
* master

/home/linville/git/wireless-dev
[linville-t43.mobile]:> git branch -r
  origin/HEAD
  origin/adm8211
  origin/b43
  origin/everything
  origin/iwlwifi
  origin/mac80211
  origin/master
  origin/merged-upstream
  origin/mm-master
  origin/p54
  origin/rt2x00
  origin/ssb
  origin/zd1211rw

/home/linville/git/wireless-dev
[linville-t43.mobile]:> git checkout -b everything origin/everything
Switched to a new branch "everything"

/home/linville/git/wireless-dev
[linville-t43.mobile]:> git branch
* everything
  master

Unlike the way wireless-dev was used in the past, I make no promises
about rebasing.  I intend to rebase most/all of the branches at least
as often as Linus produces an -rc or release tag, and I reserve the
right to rebase more often as I deem necessary.  I'm sorry, but as
you can see I have to manage a lot of patches.  Keeping them based
off a recent head is helpful to me.

I will entertain suggestions for how to minimize rebasing pain for
anyone following this tree.  However, the best suggestion I have
for anyone tracking wireless-dev is for them to get their favorite
driver(s) merged upstream.  Barring that, I understand that quilt
can be a good tool for tracking stacks of patches in development.
The git-format-patch, git-applymbox, and git-rebase commands are
handy as well.

Those simply following the tree should learn about the "--reference"
option to git-clone, and should use it often.  Keeping a backup of
previous git trees with any work in progress wouldn't hurt either.

Questions?  Complaints?  Comments?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
