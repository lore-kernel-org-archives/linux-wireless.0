Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:55704 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbZBMSVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 13:21:53 -0500
Received: by gxk22 with SMTP id 22so977462gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 10:21:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234523055.4219.15.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234523055.4219.15.camel@johannes.local>
Date: Fri, 13 Feb 2009 10:21:52 -0800
Message-ID: <43e72e890902131021j6289a817m67c9ad22ab958a1d@mail.gmail.com> (sfid-20090213_192158_777575_9AB78105)
Subject: Re: [PATCH 5/6] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 3:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>>
>> +       if (wiphy_idx_valid(last_request->wiphy_idx))
>> +               request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
>
> All this seems pointless, wiphy_idx_to_wiphy will just return NULL if
> the index isn't valid. This is in a number of places, and it's not like
> it being invalid will be happening often so we'd have to optimise for
> it.

The check can be removed if the WARNING is removed on
wiphy_idx_to_wiphy(). I left it as I figured it'd be good to leave the
warning, your call.

  Luis
