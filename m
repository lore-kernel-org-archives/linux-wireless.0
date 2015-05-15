Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:35439 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030244AbbEOHwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 03:52:55 -0400
Received: by labbd9 with SMTP id bd9so107285510lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 00:52:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431674716.2426.2.camel@sipsolutions.net>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	<1431674716.2426.2.camel@sipsolutions.net>
Date: Fri, 15 May 2015 10:52:53 +0300
Message-ID: <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com> (sfid-20150515_095801_047749_BEB748D0)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I'd be glad if someone could take a look. If not, I'll have someone
>> from our team to look at it, but I don't know how long it will take...
>
> Without looking too much - it seems to me that this is a fundamental
> problem with PTK rekeying, in that it re-uses the key index that is
> intended to avoid this.

In this case, the AP is openWRT. I guess the Key idx is chosen in
software, so maybe the proper fix would be to have openWRT increment
the key index when it rekeys?

>
> The issue at hand here is likely a hardware decryption vs. key replacing
> race, in that hardware decryption happens while the key replacing also
> happens, and then the PN checking after key replace hits the wrong key
> (due to the above-mentioned issue with not being able to change the key
> index in PTK rekeying.)
>
> I don't see how we can fix this, except perhaps heuristically by
> dropping packets that were encrypted with the *old* key and therefore
> not updating the replay counter for them. However, detecting that they
> were encrypted with the old key would only be possible by detecting a
> large jump in PN, which could theoretically also happen in real
> usage ...
>
> johannes
>
