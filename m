Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCNKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:10:35 -0500
Message-ID: <1393852231.10039.4.camel@jlt4.sipsolutions.net> (sfid-20140303_141037_812870_218F1196)
Subject: Re: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it
Date: Mon, 03 Mar 2014 14:10:31 +0100
In-Reply-To: <1393376982-28276-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_020956_981992_D01A2AD2)
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	 <1393376982-28276-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140226_020956_981992_D01A2AD2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 17:09 -0800, Luis R. Rodriguez wrote:
> In certain situations we want to trigger reprocessing
> of the last regulatory hint. One situation in which
> this makes sense is the case where the cfg80211 was
> built-in to the kernel, CFG80211_INTERNAL_REGDB was not
> enabled and the CRDA binary is on a partition not availble
> during early boot. In such a case we want to be able to
> re-process the same request at some other point.
> 
> When we are asked to re-process the same request we need
> to be careful to not kfree it, addresses that.

This looks OK, I've applied it, but I've renamed the function since it
no longer has anything to do with the last request.

johannes


