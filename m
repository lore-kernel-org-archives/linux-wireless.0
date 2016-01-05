Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51664 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbcAEWIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 17:08:18 -0500
Date: Wed, 6 Jan 2016 00:08:15 +0200
From: Jouni Malinen <j@w1.fi>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add use_minrate param to
 ieee80211_tx_prepare_skb()
Message-ID: <20160105220815.GB19972@w1.fi> (sfid-20160105_230836_377293_FE697CA1)
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
 <20160105094504.GA3015@w1.fi>
 <CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com>
 <20160105100659.GA3864@w1.fi>
 <CALhHN=q1kFn7tTQNhj=WH+7RUz+KT+fn9ovBaYJ_wzE5TtXu8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=q1kFn7tTQNhj=WH+7RUz+KT+fn9ovBaYJ_wzE5TtXu8Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2016 at 11:16:52AM +0100, Janusz Dziedzic wrote:
> I did it because most of devices I saw send probe_req using lowest rates?
> Anyway I can skip this for probe_res() frames in next patch if this is
> better idea.

Taken into account that there is strong desire to move towards the
opposite direction, yes, it would be good not to try to force Probe
Request frames use the minimal rate. We already force no-CCK policy for
P2P use cases and in the not too distant future, we'll probably need to
provide means for forcing at least 1 and 2 Mbps rates not being used for
any Probe Request frame..

-- 
Jouni Malinen                                            PGP id EFC895FA
