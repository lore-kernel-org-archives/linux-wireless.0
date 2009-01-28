Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:13558 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZA1N0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 08:26:51 -0500
Received: by fk-out-0910.google.com with SMTP id f33so3750141fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 05:26:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233147624.4071.1.camel@johannes.local>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
	 <874ozj964m.fsf@litku.valot.fi>
	 <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com>
	 <1233147624.4071.1.camel@johannes.local>
Date: Wed, 28 Jan 2009 15:26:49 +0200
Message-ID: <1ba2fa240901280526m199cb01dwc5fa62a50edca853@mail.gmail.com> (sfid-20090128_142656_631201_0AB571A0)
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save
	mode is disabled
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@iki.fi>, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 3:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Just for the record, and I was still planning to reply to your other
> mail, not trying to hijack this thread at all.
>
>> I would suggest to expose to user space non-unit index of power save
>> aggressiveness which can be mapped to different methods such as
>> PS-Poll, dynamic power save or iwlwifi firmware implementation by
>> other more reach configurable interface
>
> I **completely** disagree on this. The non-unit index is a **horrible**
> thing because it says **nothing** of interest to the user. The only
> approach the user can then take is try which value will give him the
> desired behaviour, and it will differ across all hardware combinations.
> Therefore, it's completely _useless_.

What I suggest is to have rich configuration for setting different
parameters so this is more flexible with different HW but in run time
only play with single number to create uniform interface for user
space.
I'm not sure that you want to user jungle with all the numbers, we run
empirical tests for very long time how do you want to user space take
the decision.

> What we really need to do is tie into the pm_qos framework and make
> latency guarantees.

Even pm_qos doesn't talk directly in language of all  PM paramters you
need to configure so this is just equivalent to my proposition and can
be staged after the legacy PM is implemented. Also PM doesn't map only
to traffic requirements.

Tomas
