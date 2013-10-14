Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55109 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3JNRPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:15:17 -0400
Received: by mail-oa0-f44.google.com with SMTP id l20so3855794oag.31
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 10:15:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381760191.13092.13.camel@jlt4.sipsolutions.net>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	<1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com>
	<1381760191.13092.13.camel@jlt4.sipsolutions.net>
Date: Tue, 15 Oct 2013 01:15:16 +0800
Message-ID: <CAHS2MGMONy37xZedzRhx10Mes9MCUMfiEjmWjprVOEQY_brw9Q@mail.gmail.com> (sfid-20131014_191522_455584_CD76B5BB)
Subject: Re: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh beaconing
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 14, 2013 at 10:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-10-11 at 11:29 -0700, Chun-Yeow Yeoh wrote:
>
>>       /* Channel Switching Support */
>> +     struct cfg80211_csa_settings *csa_settings;
>
> That should have an __rcu annotation now, I believe?
>
>> +     if (ifmsh->csa_settings) {
>
> In which case this will result in a sparse warning.
>
> Does this even make sense here - it can't ever be non-NULL in this
> patch?
Actually, the NULL and non-NULL situation should occur here. Whenever
the node triggers the channel switching period, it will append CSA and
MCSP elements in the beacon. So in this case, ifmsh->csa_settings
should be non-NULL. Once the channel switching count based on TBTT is
expired, ifmsh->csa_setting should be NULL, and both elements no
longer append to the beacon. Does it make sense?

---
Chun-Yeow
