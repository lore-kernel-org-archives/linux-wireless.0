Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967817AbaLLOCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 09:02:55 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless: mac80211: Avoid using uninitialized stack data
References: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com>
	<1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com>
	<1418382219.2470.10.camel@sipsolutions.net>
Date: Fri, 12 Dec 2014 09:02:49 -0500
In-Reply-To: <1418382219.2470.10.camel@sipsolutions.net> (Johannes Berg's
	message of "Fri, 12 Dec 2014 12:03:39 +0100")
Message-ID: <wrfjoar90xva.fsf@redhat.com> (sfid-20141212_150258_704483_7FDF772D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Wed, 2014-12-10 at 14:14 -0500, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Avoid case where we would access uninitialized stack data if a driver
>> advertises HT support without 40MHz channel support.
>
> I've fixed the commit message (it's actually in the check for the *AP*,
> not the driver!)
>
> Also, this is complicated. We originally had the DISABLE_VHT, but then
> found APs that were doing it wrong - see commit f3000e1b43f1 ("mac80211:
> fix broken use of VHT/20Mhz with some APs"). That fix introduced the bug
> here, going back now to the DISABLE_VHT as I'd suggested would break the
> fix again ... I'm thus taking this version to just put the right data on
> the stack, with the correct Fixes/Cc stable tags.

Either patch works for me, so I'm all good! Thanks for fixing this up!

Cheers,
Jes
