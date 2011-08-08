Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1HHI32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:29:28 -0400
Subject: Re: [PATCHv2 2/2] mac80211: Don't use a buf_size=0 in ADDBA
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
In-Reply-To: <1312537579-18950-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110805_114652_677728_F18AA5DB)
References: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
	 <1312537579-18950-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110805_114652_677728_F18AA5DB)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:29:23 +0200
Message-ID: <1312792163.4372.5.camel@jlt3.sipsolutions.net> (sfid-20110808_102935_153348_46B5A636)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-05 at 11:46 +0200, Helmut Schaa wrote:
> According to 802.11-2007, 7.3.1.14 it is compliant to use a buf_size of
> 0 in ADDBA requests. But some devices (AVM Fritz Stick N) arn't able to
> handle that correctly and will reply with an ADDBA reponse with a
> buf_size of 0 which in turn will disallow BA sessions for these
> devices.
> 
> To work around this problem, initialize hw.max_tx_aggregation_subframes
> to the maximum AMPDU buffer size 0x40.
> 
> Using 0 as default for the bufsize was introduced in commit
> 5dd36bc933e8be84f8369ac64505a2938f9ce036 (mac80211: allow advertising
> correct maximum aggregate size).

So, are you saying the problem with getting 0 in replies is solved by
not sending 0 in requests?

Patch looks fine to me, but it's not clear to me that it's the only
thing needed?

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

