Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57107 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3LBFTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 00:19:18 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so18199219pbb.9
        for <linux-wireless@vger.kernel.org>; Sun, 01 Dec 2013 21:19:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385890375.4171.0.camel@jlt4.sipsolutions.net>
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	<1385890375.4171.0.camel@jlt4.sipsolutions.net>
Date: Mon, 2 Dec 2013 10:49:17 +0530
Message-ID: <CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com> (sfid-20131202_061922_092077_2005B0D9)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired BSS
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, can you please tell me what type of bugs or what bugs the cfg80211
going to catch? As I see cfg80211 allows re-assoc command and the
driver is able to get a BSS using the function cfg80211_get_bss(). So,
the driver is going to re-associate and the result is a Kernel warning.
At this point driver's internal association is successful though.

On Sun, Dec 1, 2013 at 3:02 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2013-12-01 at 13:01 +0530, Ujjal Roy wrote:
>> cfg80211 allows re-association in managed mode and if a user
>> wants to re-associate to the same AP network after the time
>> period of IEEE80211_SCAN_RESULT_EXPIRE, cfg80211 warns with
>> the following message on receiving the connect result event.
>
> This behaviour is intentional to point out driver bugs. I'm not applying
> this.
>
> johannes
>
