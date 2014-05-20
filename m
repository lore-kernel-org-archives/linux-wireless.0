Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:56638 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaETMA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 08:00:56 -0400
Received: by mail-qg0-f52.google.com with SMTP id a108so493017qge.25
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 05:00:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U2Uy8qjEzZu2ZZqP393=wGNk7wUPOe=VwhHBB6+x56Hg@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-4-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6Wwv0y1cOZrpLe+yjZqHLmZpdJ3dYaLhLro==x4-t9UzA@mail.gmail.com>
 <CA+XVXfdFZAFih=YStSofJCaNgLQYDPxBsEPbovWufWt7O0vbPQ@mail.gmail.com> <CAB=NE6U2Uy8qjEzZu2ZZqP393=wGNk7wUPOe=VwhHBB6+x56Hg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 May 2014 15:00:40 +0300
Message-ID: <CA+XVXfezx4VpycJybyQ3NgvTXSPTdXn5eAg8jj+yjy+HxZ-EKA@mail.gmail.com> (sfid-20140520_140100_037782_61472D83)
Subject: Re: [PATCH 3/7] cfg80211: allow drivers to provide regulatory settings
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> The wiphy_apply_custom_regulatory() option is to be used before
>> registering the wiphy. We want to be able to accept country code
>> changes at runtime, with the driver supplying the regdomain.
>
> For which cases exactly at run time? This is already being handled on
> other drivers without changing APIs, so its unclear why you need this
> and to expose this to cfg80211. To be clear, a few drivers other than
> Intel already had this strategy and they managed to just use the
> reg_notifier() and do what it needs by using the flag that ignores
> country IEs, and doing everything else on the driver side. Please
> explore this avenue.

The problem is not propagating the country setting the FW. I agree
this can be done via the notifier. The problem is propagating the
regulatory data from FW to userspace.
For instance we want P2P to be able to use 5Ghz channels in the US.
For this, wpa_s must have up to date information from the regulatory
DB for country=US. For Intel, the regulatory DB is in FW.

>
>> As for why this was chosen - I think you're barking up the wrong tree :)
>> The regulatory folks at Intel decided to store the data in FW,
>
> This has been done for a long time but the main reason why this was
> done that way was that Intel had no need to have tons of regulatory
> domains, and instead had only 4 world regulatory domains, that's all,
> if things have changed it'd be good to understand this and also the
> reasons why things are being done.

This is no longer true. Some variants will now contain settings per county.

>
>> I don't  have any say here. I think this is more legal than technology reasons.
>
> Asking these questions, understanding them, and addressing concerns
> are the questions that need to be asked to help advance wireless on
> Linux, it was not asking these questions that got us into trouble in
> the first place, we don't want to go back to that. So even if it is
> non technical and purely regulatory we obviously should ask why.
>

I'm actually an advocate of the CRDA/regdb approach. Less work for us. :)
We presented it but ultimately the decision was theirs, not mine.

I believe the main motivations were security and uniformity across
different OSes. For instance, one might replace the regdb and break
regulatory. So the FW has a regulatory checker that verifies correct
settings. Which in turn means it will hold the regulatory DB anyway.
The practical thing to do is use the same settings as the actual
regdb.

Regards,
Arik
