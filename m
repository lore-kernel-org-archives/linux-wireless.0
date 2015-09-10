Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7727 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbIJFrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 01:47:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
	<87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
	<87fv2o9cvl.fsf@kamboji.qca.qualcomm.com>
	<20150909164945.GA4062@localhost>
Date: Thu, 10 Sep 2015 08:46:54 +0300
In-Reply-To: <20150909164945.GA4062@localhost> (Bob Copeland's message of
	"Wed, 9 Sep 2015 12:49:45 -0400")
Message-ID: <87oaha4yi9.fsf@kamboji.qca.qualcomm.com> (sfid-20150910_074724_704476_995CA5A4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Wed, Sep 09, 2015 at 12:10:38PM +0300, Kalle Valo wrote:
>> > I did a quick smoke test and saw the splat below. It's this warning from
>> > cfg80211:
>> >
>> > 			/*
>> > 			 * Don't advertise an unsupported type
>> > 			 * in a combination.
>> > 			 */
>> > 			if (WARN_ON((wiphy->interface_modes & types) != types))
>> > 				return -EINVAL;
>
> OK, this happens when mesh is configured out (we mask off the mesh
> interface_modes internally but not the types).  Sent an updated version
> with appropriate ifdefs added.

Indeed, when I enabled CONFIG_MAC80211_MESH I didn't see the WARN_ON()
anymore. (I haven't tested your latest version yet, will do it soon)

-- 
Kalle Valo
