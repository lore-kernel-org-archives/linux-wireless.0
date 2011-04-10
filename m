Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1DJIPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 04:15:09 -0400
Subject: Re: [PATCH 03/16] iwlagn: fix radar frame rejection
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Garen Tamrazian <garenx.tamrazian@intel.com>
In-Reply-To: <1302276636-12802-4-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-4-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 10:15:05 +0200
Message-ID: <1302423305.3519.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> From: Garen Tamrazian <garenx.tamrazian@intel.com>
> 
> The microcode may sometimes reject TX frames when
> on a radar channel even after we associated as it
> clears information during association and needs to
> receive a new beacon before allowing that channel
> again. This manifests itself as a TX status value
> of TX_STATUS_FAIL_PASSIVE_NO_RX. So in this case,
> stop the corresponding queue and give the frame
> back to mac80211 for retransmission. We start the
> queue again when a beacon from the AP is received
> which will make the regulatory enforcement in the
> device allow transmitting again.

It'd be nice to have this in .39 as well.

johannes

