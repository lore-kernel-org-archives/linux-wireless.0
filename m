Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:58188 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LEKf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:35:28 -0500
Received: by mail-ve0-f182.google.com with SMTP id jy13so13789684veb.27
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 02:35:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386234180.3878.8.camel@porter.coelho.fi>
References: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
	<1386078502-19845-6-git-send-email-luciano.coelho@intel.com>
	<CAEFj9850NcEhzBFTDkOhCKzpQNtBooSCj3CqsJHuncunUxXw9Q@mail.gmail.com>
	<CAEFj984YzCvRtqKtvvng_9EUFk3J2wFRcrn-1xNmQ85OZ1BxfQ@mail.gmail.com>
	<1386234180.3878.8.camel@porter.coelho.fi>
Date: Thu, 5 Dec 2013 18:35:27 +0800
Message-ID: <CAEFj986VzE9ybX0_gomnRv3_kt5t7HyqQEZxvzCwjBXFrNdaLA@mail.gmail.com> (sfid-20131205_113530_920498_18A1D226)
Subject: Re: [PATCH v6 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Actually, I just looked at the specs again and the count value for mesh
> is completely different.  Instead of specifying the number of TBTTs
> until the switch happens, it specifies the time in TUs until the switch
> happens and 0 means at any time after the frame was sent (the same as
> with nonmesh).  In our implementation, we just decrease the count on
> every beacon, which is wrong in the mesh case.

Yes, you are absolutely correct.

>
> The count implementation for mesh is bogus.  We need to fix that.
>
> What if, for now, I just fix the oops because of the rcu_derefence when
> the rcu is not initialized

Sure

> and we fix the count implementation later?

Hmm, even with unit of 100TU, we can't use the current count approach
since the default TBTT for mesh is 1000 TU.

----
Chun-Yeow
