Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKDVaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 16:30:10 -0500
Date: Tue, 4 Nov 2014 15:50:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi 2014-11-03
Message-ID: <20141104205043.GC31033@tuxdriver.com> (sfid-20141104_223018_230229_36604D16)
References: <5457DC1C.7020200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5457DC1C.7020200@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 03, 2014 at 09:48:44PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> Here is a pull request for 3.18.
> 
> Details below, please pull.
> 
> Thanks!
> 
> The following changes since commit 7f2ac8fb31896c9fb70dbd2a2e6642b79996fc13:
> 
>   iwlwifi: pcie: fix polling in various places (2014-10-23 21:21:49 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-john-2014-11-03
> 
> for you to fetch changes up to 31b8b343e019e0a0c57ca9c13520a87f9cab884b:
> 
>   iwlwifi: fix RFkill while calibrating (2014-11-03 15:29:17 +0200)
> 
> ----------------------------------------------------------------
> I fix here two issues that are related to the firmware
> loading flow. A user reported that he couldn't load the
> driver because the rfkill line was pulled up while we
> were running the calibrations. This was happening while
> booting the system: systemd was restoring the "disable
> wifi settings" and that raised an RFKILL interrupt during
> the calibration. Our driver didn't handle that properly
> and this is now fixed.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       iwlwifi: mvm: initialize the cur_ucode upon boot
>       iwlwifi: fix RFkill while calibrating
> 
>  drivers/net/wireless/iwlwifi/mvm/fw.c       | 10 +++++++++-
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
>  drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
>  drivers/net/wireless/iwlwifi/mvm/ops.c      | 12 +++++++++++-
>  drivers/net/wireless/iwlwifi/pcie/trans.c   |  4 ++--
>  5 files changed, 24 insertions(+), 4 deletions(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
