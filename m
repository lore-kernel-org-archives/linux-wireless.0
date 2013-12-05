Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53904 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LEKgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:36:02 -0500
Received: by mail-wi0-f182.google.com with SMTP id en1so9580167wid.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 02:36:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21152.21739.555819.395470@gargle.gargle.HOWL>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
 <1386092034-13442-2-git-send-email-mcgrof@do-not-panic.com> <21152.21739.555819.395470@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 5 Dec 2013 11:35:40 +0100
Message-ID: <CAB=NE6XHsSdWcVf30kxj-zP-SFo+d+pv3EuyoR0f5Rjzd=Z5dQ@mail.gmail.com> (sfid-20131205_113605_750277_6EF1D8C1)
Subject: Re: [RFT 1/2] ath: fix warning on usage of REGULATORY_CUSTOM_REG
To: Sujith Manoharan <sujith@msujith.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 5, 2013 at 11:26 AM, Sujith Manoharan <sujith@msujith.org> wrote:
> Luis R. Rodriguez wrote:
>>       wiphy_apply_custom_regulatory(wiphy, regd);
>> +     if (!ath_is_world_regd(reg))
>> +             wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
>
> The warning is gone, but why is this cleared here ?

It should be CUSTOM that gets cleared, sorry.

  Luis
