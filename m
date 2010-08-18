Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58566 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0HRQon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:44:43 -0400
Date: Wed, 18 Aug 2010 12:44:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: do not spuriously call
 ieee80211_scan_completed
Message-ID: <20100818164405.GA2793@tuxdriver.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
 <1282149322-17928-3-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282149322-17928-3-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 09:35:22AM -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When a scan is aborted because the corresponding
> virtual interface is removed, we may still later
> attempt to tell mac80211 that the scan completed.
> This is obviously wrong, since we already told it
> that it was aborted, so don't do that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Does this really qualify as a fix for 2.6.36?  Is it a regression?
Does it generate an oops?  Or loss of connectivity?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
