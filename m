Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCNKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:10:51 -0500
Message-ID: <1393852248.10039.5.camel@jlt4.sipsolutions.net> (sfid-20140303_141053_985643_A216A3DB)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non
 modular
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it
Date: Mon, 03 Mar 2014 14:10:48 +0100
In-Reply-To: <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_021002_731740_5B4B0ECF)
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140226_021002_731740_5B4B0ECF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 17:09 -0800, Luis R. Rodriguez wrote:
> This allows processing of the last regulatory request when
> we determine its still pending. Without this if a regulatory
> request failed to get processed by userspace we wouldn't
> be able to re-process it later. An example situation that can
> lead to an unprocessed last_request is enabling cfg80211 to
> be built-in to the kernel, not enabling CFG80211_INTERNAL_REGDB
> and the CRDA binary not being available at the time the udev
> rule that kicks of CRDA triggers.
> 
> In such a situation we want to let some cfg80211 triggers
> eventually kick CRDA for us again. Without this if the first
> cycle attempt to kick off CRDA failed we'd be stuck without
> the ability to change process any further regulatory domains.
> 
> cfg80211 will trigger re-processing of the regulatory queue
> whenever schedule_work(&reg_work) is called, currently this
> happens when:
> 
>   * suspend / resume
>   * disconnect
>   * a beacon hint gets triggered (non DFS 5 GHz AP found)
>   * a regulatory request gets added to the queue
> 
> We don't have any specific opportunistic late boot triggers
> to address a late mount of where CRDA resides though, adding
> that should be done separately through another patch.
> Without an opportunistic fix then this fix relies at least
> one of the triggeres above to happen.

Ok, applied. (with that typo there fixed)

johannes

