Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:34432 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbFQMPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 08:15:25 -0400
Received: by iebtr6 with SMTP id tr6so2011953ieb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 05:15:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434541047.1884.41.camel@sipsolutions.net>
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
 <1434530870.1884.12.camel@sipsolutions.net> <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
 <1434538909.1884.39.camel@sipsolutions.net> <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com>
 <1434541047.1884.41.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 17 Jun 2015 17:45:04 +0530
Message-ID: <CABPxzYKmsGyhmM_5e11N2sgw8c-ARyJJ_rPkfjwCcZ6+hfqHgg@mail.gmail.com> (sfid-20150617_141529_176015_EC9C03BF)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state stuck
 in ACTIVE caused by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 5:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-17 at 17:05 +0530, Krishna Chaitanya wrote:
>
>> > Then again, you're talking about WoWLAN, but then ...
>> In wowlan, we simply call drv_resume and only if it fails
>> then we will go through full resume. And without wowlan
>> connection will not be there so this code will not be hit.
>
> Right, but then the important part still is that we're enabling
> powersave when going to sleep, no? I mean ... anyway it doesn't matter
> much. I'll come up with some better comment/description I guess.
Yes, we are forcing it to go in to power-save.
>
> I really hate this whole powersave code btw - we really should refactor
> that into its own little library module or so...
Yes, that sounds good.
