Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63559 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaKMPz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 10:55:29 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so1465532wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 07:55:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WNtZOm-u0HxdCziuV7rZvQG=X=HN6r=FytVDKaaOmUnA@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <1414046257-22184-6-git-send-email-arik@wizery.com> <CAB=NE6WLnVcBtC5_HyVuDXJnrCUfhUKsPN_rAHL6VYEfek1TMA@mail.gmail.com>
 <CA+XVXfcMhrHUhg4yj_dOf97XWu_HyvdQ-LqF4KbjXL4ewGn5PQ@mail.gmail.com> <CAB=NE6WNtZOm-u0HxdCziuV7rZvQG=X=HN6r=FytVDKaaOmUnA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 13 Nov 2014 17:55:13 +0200
Message-ID: <CA+XVXfd-Z-mv7iL-Og=_Spr053HgW8pZXMR3jmbaQc-jX7v3-g@mail.gmail.com> (sfid-20141113_165534_251264_E031F53D)
Subject: Re: [PATCH 5/5] cfg80211: Allow usermode to query wiphy specific regd info
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>> 2. And then if userspace sends a wiphy idx to the NL80211_CMD_GET_REG,
>> we'll return wiphy->regd for that case as well?
>
> That's right, for now we'd be able to send the regd when either
> NL80211_ATTR_WIPHY_SELF_MANAGED_REG is set or when
> NL80211_ATTR_WIPHY_SELF_MANAGED_REG is not set but regulatory_hint()
> was used. Note that some users may have REGULATORY_CUSTOM_REG. and
> then later use regulatory_hint(), this is done to for example set a
> more restrictive custom world regdomain and then later use the CRDA
> data for a specific alpha2.

Well always sending wiphy->regd whenever it is set is easy, but it
might be problematic I guess:

We intend to add a patch to wpa_s to always add the wiphy_idx to
NL80211_CMD_GET_REG. With the current approach only drivers with
SELF_MANAGED_REG will get wiphy->regd back. This is ok since these are
new drivers, which are familiar with this API.

But if we use your suggestion and always return wiphy->regd, then some
driver like ath9k that uses regulatory_hint() will now get it's
private regd returned to the wpa_s that manages it. I'm not saying
it's necessarily bad, but it's different than what was returned
before. The cfg80211 regdomain is intersected with wiphy->regd, so now
ath9k will start getting more permissive channels in usermode.

So we thought it's best to enable the new behavior only if the driver
explicitly wants it, using a new regulatory flag.

Arik
