Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f179.google.com ([209.85.210.179]:37120 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946552Ab3BHQih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 11:38:37 -0500
Received: by mail-ia0-f179.google.com with SMTP id x24so4415834iak.10
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 08:38:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511508A6.8020104@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
Date: Fri, 8 Feb 2013 08:38:36 -0800
Message-ID: <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> (sfid-20130208_174021_214033_A6DED38B)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Paul Stewart <pstew@google.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could you share some of the test results?  I know with ChromeOS when
we switched to 3.4, the first thing that tipped us off to the fact
that we had inadvertently switch to minstrel was that our RvR
throughput values had dropped significantly.  Has anyone done an RvR
comparison between minstrel and the ath9k internal rate control
lately?

--
Paul

On Fri, Feb 8, 2013 at 6:16 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2013-02-08 3:08 PM, Sujith Manoharan wrote:
>> Felix Fietkau wrote:
>>> In many tests throughput with ath9k_rate_control has been shown to be
>>> worse than with minstrel_ht (the mac8021 default RC).
>>>
>>> This module also has some other problems, like starting to use the
>>> highest possible rate early in the connection, causing problems with
>>> reliability of connection/authentication attempts.
>>>
>>> It also has a much more limited search space, ignoring many potentially
>>> useful rates, caused by the design decision to operate on a sorted rate
>>> set with the assumption that higher rates are always more unreliable
>>> than lower rates. In some scenarios this assumption is not true, and
>>> this can cause it to fall back to a really bad rate.
>>>
>>> minstrel_ht has been tested extensively in AP and client mode by lots of
>>> users (mostly in the OpenWrt project, where it has been the default for
>>> years).
>>
>> I don't think managed mode would have received much testing in OpenWRT.
> I know quite a few people that use directional links with 4-addr
> AP/Station. I also know a few people that put up some devices that roam
> between multiple APs. Obviously it doesn't receive as much testing as AP
> mode, but there are some active users stress testing it.
>
> - Felix
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
