Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0JNPza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 11:55:30 -0400
Subject: Re: [PATCH 2/2] iwlwifi: one less commit_rxon while scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101014084238.GB2286@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
	 <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
	 <20101014084238.GB2286@redhat.com>
Content-Type: text/plain
Date: Thu, 14 Oct 2010 08:54:39 -0700
Message-Id: <1287071679.13051.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2010-10-14 at 01:42 -0700, Stanislaw Gruszka wrote:
> On Wed, Oct 13, 2010 at 03:39:53PM +0200, Stanislaw Gruszka wrote:
> > Almost anywhere in the code we avoid committing rxon while performing
> > scan, and make rxon commit when scan complete. Some current patches do
> > not follow that rule. We have that problem at least in
> > iwlagn_confirue_filter(), iwl_update_chain_flags() and
> > iwl_bg_bt_full_concurrency().
> 
> Any comments about iwl_update_chain_flags, iwl_bg_bt_full_concurrency ?
> I would like to know how to deal with them, should we deffer commit_rxon
> to scan complete, or cancel the scan. Or maybe this is no problem
> at all, because in example committing rxon vs scan was problem of
> older firmware?
> 

iwl_update_chain_flags() is used when PSP mode change,
iwl_bg_bt_full_concurrency() is used only for BT coex and in BT full
concurrency mode. For both case, I do not see any reason we can not
defer to scan complete.

Thanks
Wey

