Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:56699 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab2FYNyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 09:54:40 -0400
Received: by yhnn12 with SMTP id n12so3326350yhn.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 06:54:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87395j4j3y.fsf@purkki.adurom.net>
References: <1340610505-7713-1-git-send-email-eliad@wizery.com>
	<87395j4j3y.fsf@purkki.adurom.net>
Date: Mon, 25 Jun 2012 16:54:39 +0300
Message-ID: <CAB3XZEcUoo0g7ZjGCkZViAs+B=nsYgfsZGvN1vE+WN8bFuE8Sw@mail.gmail.com> (sfid-20120625_155443_992173_83726872)
Subject: Re: [PATCH] mac80211: don't require associated->beacon_ies for ps
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 25, 2012 at 4:27 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> beacon_ies is needed only in order to extract the dtim
>> period. However, even if it's missing we can still enter
>> ps with dtim=1 (which also happens if the TIM ie is invalid).
>>
>> Most drivers don't use conf.max_sleep_period/ps_dtim_period
>> anyway, and this check prevents them from entering ps if
>> they don't have beacon (but only probe response), even though
>> the beacon is not needed at all.
>
> Does this increase the chances of accidentally using dtim 1 even though
> AP has dtim > 1? I'm just worried that it's difficult to detect cases
> when we are forcing dtim to 1 and nobody might not notice it. How often
> will this happen?
>
doesn't dtim=1 is still better than not entering ps at all?
i think the only bad effect of using dtim=1 (instead of greater value)
is wrt power saving. but entering psm with dtim=1 is still better than
not entering psm at all.

> Should we add a warning message for that case? Or few years ago we
> talked about waiting for a beacon before enabling ps mode, should we
> reconsider that? (Or maybe it's implemented already?)
the current behavior is not entering ps if there is no beacon.
however, as i've just explained, i think we can drop this requirement.
i don't think we should add a warning, as this might be a legitimate
behavior (as probe response might be enough in order to connect).

Eliad.
