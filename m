Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0KXKoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 05:44:17 -0500
Subject: Re: [PATCH] iwlwifi: avoid "Error sending TX power (-5)"
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
References: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 11:44:12 +0100
Message-ID: <1290595452.3790.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 11:37 +0100, Stanislaw Gruszka wrote:
> We can have this error message when loading or unloading module, when
> device is not marked as ready, but we want to set tx power from
> commit_rxon. Perhaps something better should be done like call
> lib->send_tx_power() directly from commit_rxon, but for now just
> do not return error.

I think this actually fixes it, as opposed to hiding it:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=9e2e7422d059f9b98c3a0810df92a1ff660ade2f

johannes


