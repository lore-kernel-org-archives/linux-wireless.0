Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3KATlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 15:41:45 -0400
Message-ID: <1383334899.14379.2.camel@jlt4.sipsolutions.net> (sfid-20131101_204148_347266_CF6C739C)
Subject: Re: [PATCH 6/8] wireless-regdb: optimize two of DE's rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wireless-regdb@lists.infradead.org
Date: Fri, 01 Nov 2013 20:41:39 +0100
In-Reply-To: <1383314131-20774-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145552_151746_60973670)
References: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383314131-20774-7-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131101_145552_151746_60973670)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-01 at 14:55 +0100, Luis R. Rodriguez wrote:

> -	# entry 303005
> -	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
> -	# entries 304002 and 305002
> -	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
> +	# entry 303005, 304002 and 305002

should probably say entries :)

Btw, according to the formal definition that the kernel uses, having two
versus one rule actually *is* different. Having two stops you from using
a channel that crosses the boundary. In practice, this kind of
interpretation is actually cumbersome and error-prone, which I've
pointed out long ago together with my suggestion to actually change it,
but I wanted to point it out anyway.

johannes

