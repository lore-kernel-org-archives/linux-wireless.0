Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54180 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2JUQlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 12:41:07 -0400
Message-ID: <5084256F.2030502@ti.com> (sfid-20121021_184111_107957_553365B4)
Date: Sun, 21 Oct 2012 18:40:15 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
References: <1350226137-13704-1-git-send-email-victorg@ti.com>  <1350226137-13704-6-git-send-email-victorg@ti.com> <1350414390.10177.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350414390.10177.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/10/2012 21:06, Johannes Berg wrote:
> Hmm, does that really work? I mean, it can do the update when the event
> comes in, but is that fast enough, or should it give us the new beacon
> already when programming the switching?
>

Yes it works with our 12xx, in the 12xx the FW (upon channel switch 
command) is responsible to decrement the channel switch count in the 
beacon CSA IE and to remove the CSA IE from the beacon once device moves 
to the new channel (+ to updates the DS).

-- 
Thanks,
Victor.
