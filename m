Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43009 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaATMC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 07:02:28 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so4844380lbj.17
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 04:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390215337.4335.11.camel@jlt4.sipsolutions.net>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
	<1389947524-6102-5-git-send-email-janusz.dziedzic@tieto.com>
	<1390215337.4335.11.camel@jlt4.sipsolutions.net>
Date: Mon, 20 Jan 2014 13:02:27 +0100
Message-ID: <CALhHN=q9ZwMEo2xzPtAqkk0oGri+oQ=G4w2KRAvATaB=hc31yw@mail.gmail.com> (sfid-20140120_130231_357434_7337EFF2)
Subject: Re: [PATCH 4/5] cfg80211: introduce strict bandwidth regulatory flag
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2014 11:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-01-17 at 09:32 +0100, Janusz Dziedzic wrote:
>> Introduce NL80211_RRF_STRICT_BW regulatory rule flag.
>> This mean we will check only banwidth defined in
>> regulatory database and not check contiguous rules.
>
> If you meant for this to alleviate my concerns about crda/db.txt
> compatibility, you didn't do it right. This has no value whatsoever
> since it still breaks things.
>

So, maybe better introduce opposite logic here. By default always
calculate BW as STRICT_BW - be backwards compatible with current
crda/db.txt implementation/calculation.
And introduce WIDE(LOOSE)_BW flag for the rules we would like
calculate maximum bandwidth using contiguous rules?

BR
Janusz
