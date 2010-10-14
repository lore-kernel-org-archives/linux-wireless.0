Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab0JNIkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 04:40:41 -0400
Date: Thu, 14 Oct 2010 10:42:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] iwlwifi: one less commit_rxon while scan
Message-ID: <20101014084238.GB2286@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
 <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 03:39:53PM +0200, Stanislaw Gruszka wrote:
> Almost anywhere in the code we avoid committing rxon while performing
> scan, and make rxon commit when scan complete. Some current patches do
> not follow that rule. We have that problem at least in
> iwlagn_confirue_filter(), iwl_update_chain_flags() and
> iwl_bg_bt_full_concurrency().

Any comments about iwl_update_chain_flags, iwl_bg_bt_full_concurrency ?
I would like to know how to deal with them, should we deffer commit_rxon
to scan complete, or cancel the scan. Or maybe this is no problem
at all, because in example committing rxon vs scan was problem of
older firmware?

Stanislaw
