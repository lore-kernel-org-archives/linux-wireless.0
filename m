Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:41006 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaQSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 11:18:49 -0500
Received: by mail-lb0-f175.google.com with SMTP id p9so3535728lbv.6
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jan 2014 08:18:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391177274.4141.21.camel@jlt4.sipsolutions.net>
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	<1391177274.4141.21.camel@jlt4.sipsolutions.net>
Date: Fri, 31 Jan 2014 17:18:47 +0100
Message-ID: <CALhHN=pWfrsY5HEuXRoAvr=k0VDNAfm=yrk3jF2-qiC-j6gB8A@mail.gmail.com> (sfid-20140131_171852_707432_8F8D8F3B)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2014 15:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-01-30 at 09:52 +0100, Janusz Dziedzic wrote:
>
> I'll apply this, but I think we should think about this:
>
>> @@ -950,11 +1027,18 @@ static void handle_channel(struct wiphy *wiphy,
>
>> +     max_bandwidth_khz = freq_range->max_bandwidth_khz;
>> +     /* Check if auto calculation requested */
>> +     if (!max_bandwidth_khz) {
>> +             regd = reg_get_regdomain(wiphy);
>> +             max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
>> +     }
>
> It seems rather odd to have to look up the regdomain here, when we
> actually came from a regdomain update originally. Or didn't we?
>
In the handle_channel() function we don't know regd.

reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));

from handle_channel() also look up the regdomain.
So, I did the same.

BR
Janusz
