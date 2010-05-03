Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26570 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab0ECVBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 17:01:49 -0400
Subject: Re: [PATCH] iwlagn: Change the TPT calculations sanity-check to
 WARN_ON
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johill@sipsolutions.net,
	reinette.chatre@intel.com, Adel Gadllah <adel.gadllah@gmail.com>
In-Reply-To: <AANLkTimf_aZyUSZInOzUPZ8KRR6oDs3Re4pSGGn541fM@mail.gmail.com>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	 <87k4rkk9tz.fsf@purkki.valot.fi>
	 <AANLkTimf_aZyUSZInOzUPZ8KRR6oDs3Re4pSGGn541fM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 17:01:44 -0400
Message-Id: <1272920504.4907.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 22:48 +0200, Gábor Stefanik wrote:

> One exception I can think of: major misconfiguration can cause a
> wireless device to DMA data into sensitive memory locations. When
> evidence of this is detected, it might make sense to BUG_ON()
> (especially if the bogus DMA operations can be exploited remotely to
> overwrite arbitrary memory addresses). However, in that case, the
> attacker may have already overwritten panic() with malicious code as
> well, so even this case doesn't hold.

And then there is a case when encryption fails and there is a risk of
transmitting data without encryption or accepting data without
verification.

But generally, I agree.

-- 
Regards,
Pavel Roskin
