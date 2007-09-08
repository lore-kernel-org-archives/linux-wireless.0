Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXIHNBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 09:01:24 -0400
Date: Sat, 8 Sep 2007 14:01:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: COMMON symbol warnings
Message-ID: <20070908130118.GA11648@infradead.org>
References: <1189100314.28781.112.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189100314.28781.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 06, 2007 at 07:38:34PM +0200, Johannes Berg wrote:
> After my compile run with __CHECK_ENDIAN__ the modules were built and I
> got:
> 
> WARNING: "iwl_param_debug" [drivers/net/wireless/iwl3945] is COMMON symbol
> WARNING: "iwl_param_disable_hw_scan" [drivers/net/wireless/iwl3945] is COMMON symbol
> WARNING: "iwl_param_hwcrypto" [drivers/net/wireless/iwl3945] is COMMON symbol
> WARNING: "iwl_param_antenna" [drivers/net/wireless/iwl3945] is COMMON symbol
> WARNING: "iwl_param_disable" [drivers/net/wireless/iwl3945] is COMMON symbol
> WARNING: "iwl_param_debug" [drivers/net/wireless/iwl4965] is COMMON symbol
> WARNING: "iwl_param_disable_hw_scan" [drivers/net/wireless/iwl4965] is COMMON symbol
> WARNING: "iwl_param_hwcrypto" [drivers/net/wireless/iwl4965] is COMMON symbol
> WARNING: "iwl_param_antenna" [drivers/net/wireless/iwl4965] is COMMON symbol
> WARNING: "iwl_param_disable" [drivers/net/wireless/iwl4965] is COMMON symbol
> WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw-mac80211/zd1211rw-mac80211] is COMMON symbol
> WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw/zd1211rw] is COMMON symbol
> 
> any idea what that means?

Yes.  It means a variable is declared in multiple places and the linker
merges it for you.  The fix is to make sure these are declared extern in
all places but one.
