Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39483 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYJ0SBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 14:01:48 -0400
Date: Mon, 27 Oct 2008 14:00:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	tomas.winkler@intel.com, kernel@nn7.de,
	linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027180049.GF20389@tuxdriver.com> (sfid-20081027_190154_398204_708813B8)
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271839.39236.rjw@sisk.pl> <20081027175719.GA5759@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081027175719.GA5759@localhost.aei.mpg.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 06:57:19PM +0100, Carlos R. Mafra wrote:
> On Mon 27.Oct'08 at 18:39:38 +0100, Rafael J. Wysocki wrote:
> > On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> > > Hi,
> > > 
> > > So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> > > to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> > > when moving to new BSS") by Tomas Winkler (Cc:-ed).
> > > 
> > > Unfortunately it doesn't revert cleanly so I can't double check it.
> > 
> > Why are you saying it doesn't revert cleanly?  For me it does revert without
> > rejects from 2.6.28-rc2.
> 
> I get this
> 
> [mafra@localhost:linux-2.6]$ git checkout v2.6.28-rc2 -b s2ram
> Switched to a new branch "s2ram"
> [mafra@localhost:linux-2.6]$ git revert 3b7ee69d
> warning: too many files, skipping inexact rename detection
> Auto-merged net/mac80211/mlme.c
> CONFLICT (content): Merge conflict in net/mac80211/mlme.c
> Automatic revert failed.  After resolving the conflicts,
> mark the corrected paths with 'git add <paths>' or 'git rm <paths>' and commit the result.
> 
> I don't know what is happening here :-(

That conflict is easy to resolve.  Just delete everything between
"<<<<" and ">>>>" (including those lines).

Hth!

John

P.S.  I don't see any obvious reason why that should affect X on
resume -- maybe the iwlwifi guys have some ideas.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
