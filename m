Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXLTF4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 00:56:10 -0500
Subject: Re: [PATCH] iwl4965: fix bogus hardware scan configuration caching
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1198024224.4885.188.camel@johannes.berg>
References: <1198024224.4885.188.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 13:56:08 +0800
Message-Id: <1198130168.3065.50.camel@debian.sh.intel.com> (sfid-20071220_055616_664132_EA617E79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-19 at 01:30 +0100, Johannes Berg wrote:
> When iwl4965 is scanning, it needs to cache any configuration
> requests.
> This was implemented but the implementation is buggy: it uses only
> the *first* configuration rather than the *last* that is requested
> during scanning. This patch fixes that and also removes a bogus
> comment related to the issue.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This patch requires porting to iwl3965. For correctness, it
> needs to be applied to 2.6.24 although most likely nobody will
> ask to change channel twice during a single hardware scan. Duh!
> 
> Warning: patch is not even compile tested yet because I currently have
> a broken tree. I don't see why it shouldn't work though.

NACK. We have a better fix that doesn't require to alloc buffer at all
in our tree. Will post it here later.
http://intellinuxwireless.org/repos/?p=iwlwifi.git;a=commitdiff;h=5f967087629a19b0c166101ddd227dee8ab2ec39

Thanks,
-yi

