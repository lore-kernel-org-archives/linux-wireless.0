Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:57876 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2JQQ17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 12:27:59 -0400
Message-ID: <507EDAD7.2030807@neratec.com> (sfid-20121017_182803_086761_5541BF8A)
Date: Wed, 17 Oct 2012 18:20:39 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>  <1350226137-13704-2-git-send-email-victorg@ti.com> <1350414099.10177.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350414099.10177.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2012 09:01 PM, Johannes Berg wrote:
> [...]
> 
> It also raises a question: can you do radar detection properly while
> doing channel TDM (multi-channel)? I guess not?
> 
> johannes
> 
At least ETSI differentiates between CAC and Off-Channel CAC, with
dedicated requirements for times and detection probability for
continuously monitoring the operating channel vs. accumulated periods
listening for radars on a different one.

OC-CAC is considered as an optional optimization to enable switching to
a new channel without the need to perform a CAC there. Weighting the
potential gain vs. the required effort to support that feature, I'd
assume OC-CAC is not a hot topic (maybe even not feasible in the long run).


