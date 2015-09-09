Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36407 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbIILJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 07:09:14 -0400
Received: by igcrk20 with SMTP id rk20so96992976igc.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2015 04:09:13 -0700 (PDT)
Date: Wed, 9 Sep 2015 07:08:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
Message-ID: <20150909110855.GA27466@localhost> (sfid-20150909_130917_960264_973276A0)
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
 <1440673024-13696-4-git-send-email-me@bobcopeland.com>
 <87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2015 at 10:57:30AM +0300, Kalle Valo wrote:
> I did a quick smoke test and saw the splat below. It's this warning from
> cfg80211:
> 
> 			/*
> 			 * Don't advertise an unsupported type
> 			 * in a combination.
> 			 */
> 			if (WARN_ON((wiphy->interface_modes & types) != types))
> 				return -EINVAL;
> 
> I didn't immeaditely figure out what's causing this, the interface types
> looked correct to me. Unfortunately I don't have time to investigate
> more at the moment, but will look later.

Doh!  Yeah this warning is exactly why I marked it supported even if you
couldn't use it due to missing rawmode support.   Obviously I missed one
of the cases, I'll take a look.

-- 
Bob Copeland %% http://bobcopeland.com/
