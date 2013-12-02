Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57274 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3LBSAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 13:00:15 -0500
Date: Mon, 2 Dec 2013 12:58:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2013-11-19
Message-ID: <20131202175810.GC26033@tuxdriver.com> (sfid-20131202_190020_268001_8558E82E)
References: <528BCEDB.8010703@gmail.com>
 <529231A4.5010503@gmail.com>
 <20131125204113.GC8228@tuxdriver.com>
 <5293BBB5.80302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5293BBB5.80302@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 25, 2013 at 11:05:57PM +0200, Emmanuel Grumbach wrote:
> 
> 
> On 11/25/2013 10:41 PM, John W. Linville wrote:
> > On Sun, Nov 24, 2013 at 07:04:36PM +0200, Emmanuel Grumbach wrote:
> >>
> >>
> >> On 11/19/2013 10:49 PM, Emmanuel Grumbach wrote:
> >>> Hi John,
> >>>
> >>> This is a pull request for 3.13.
> >>>
> >>> I have here a few fixes for BT Coex. One of them is a NULL pointer
> >>> dereference. Another one avoids to enable a feature that can make the
> >>> firmware unhappy since the firmware isn't ready for it yet. WE also
> >>> avoid a WARNING that can be triggered upon association in not-so-bad
> >>> cases even if the association succeeded. We add support for new NICs
> >>> (not yet on the market) and bump the API so that 3.13 will be able to
> >>> work with the new firmware that will be out soon hopefully.
> >>> I also have a boundary check from Johannes.
> >>>
> >>> I reset my tree to wireless/master as the time of this writing. I did
> >>> that mainly because I needed the changes that were in -next before 3.12
> >>> went out even if 3.13-rc1 isn't out yet. I plan to rebase my tree on
> >>> 3.13-rc2 (or 3.13-rc1 if this pull request makes it to 3.13-rc1 but that
> >>> seems unlikely).
> >>> Tell me if you have any issues.
> >>>
> >>>
> >>
> >> FWIW - since 3.13-rc1 is already out and you haven't pulled yet, I
> >> rebased this pull request --onto v3.13-rc1.
> > 
> > 3.13-rc1 is not in the wireless tree (because it isn't in the net
> > tree).  If it is in your tree, then I can't pull from you -- sorry!
> > 
> 
> 
> Sure - sorry... still starting with all this...
> Anyway - I rebased my tree on yours - so here is a new pull request.
> 
> Can you please make sure you pull -no-ff?
> It makes it easier for people to see when you pull from others rather
> than apply patches.
> 
> Thanks!
> 
> The following changes since commit 9d8506cc2d7ea1f911c72c100193a3677f6668c3:
> 
>   gso: handle new frag_list of frags GRO packets (2013-11-21 14:11:50 -0500)
> 
> are available in the git repository at:
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> master
> 
> for you to fetch changes up to 3c5da7eefce5835acfc73ebd0a4f961cdae4ae67:
> 
>   iwlwifi: mvm: use a cast to calculate the last seqno from the next one
> (2013-11-25 23:00:21 +0200)
> 
> ----------------------------------------------------------------
> Alexander Bondar (1):
>       iwlwifi: pcie: stop sending commands to dead firmware
> 
> Emmanuel Grumbach (5):
>       iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
>       iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
>       iwlwifi: mvm: BT Coex fix another NULL pointer dereference
>       iwlwifi: mvm: don't WARN about unsuccessful time event
>       iwlwifi: bump required firmware API version for 3160/7260
> 
> Johannes Berg (1):
>       iwlwifi: mvm: check sta_id/drain values in debugfs
> 
> Luciano Coelho (2):
>       iwlwifi: mvm: set seqno also when no keys are set
>       iwlwifi: mvm: use a cast to calculate the last seqno from the next one
> 
> Oren Givon (1):
>       iwlwifi: add new HW - 7265 series
> 
>  drivers/net/wireless/iwlwifi/iwl-7000.c       |   29
> +++++++++++++++++++++++--
>  drivers/net/wireless/iwlwifi/iwl-config.h     |    5 +++++
>  drivers/net/wireless/iwlwifi/iwl-csr.h        |    5 +----
>  drivers/net/wireless/iwlwifi/mvm/bt-coex.c    |    6 ++++-
>  drivers/net/wireless/iwlwifi/mvm/d3.c         |    5 +++--
>  drivers/net/wireless/iwlwifi/mvm/debugfs.c    |    4 ++++
>  drivers/net/wireless/iwlwifi/mvm/time-event.c |    7 ++++--
>  drivers/net/wireless/iwlwifi/pcie/drv.c       |   21 ++++++++++++++++++
>  drivers/net/wireless/iwlwifi/pcie/internal.h  |    8 +++++++
>  drivers/net/wireless/iwlwifi/pcie/rx.c        |    7 +++++-
>  drivers/net/wireless/iwlwifi/pcie/trans.c     |    3 ---
>  drivers/net/wireless/iwlwifi/pcie/tx.c        |    6 ++---
>  12 files changed, 88 insertions(+), 18 deletions(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
