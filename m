Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39078 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaETOpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 10:45:10 -0400
Date: Tue, 20 May 2014 10:32:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: don't filter out the first beacon
Message-ID: <20140520143226.GC13981@tuxdriver.com> (sfid-20140520_164514_792791_AB4FFE6C)
References: <537B2FF7.5070908@gmail.com>
 <1400582238-18601-1-git-send-email-egrumbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400582238-18601-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 01:37:18PM +0300, Emmanuel Grumbach wrote:
> From: Avri Altman <avri.altman@intel.com>
> 
> Enabling beacon filtering should be done only after a beacon
> has been received. Doing that too early will cause
> disconnections.
> This has already been fixed, but the fix didn't take care
> about the case where the beacon is received after the
> association, it waited only for association which is not
> enough.
> 
> Signed-off-by: Avri Altman <avri.altman@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++---
>  drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 ---
>  drivers/net/wireless/iwlwifi/mvm/power.c    | 63 +++++++++--------------------
>  3 files changed, 27 insertions(+), 54 deletions(-)

It is very late in the release cycle for a fix of this size.
How serious is the issue?  A random disconnect doesn't seem like a
huge problem so long as it isn't common...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
