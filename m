Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64446 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0IJDen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 23:34:43 -0400
Received: by qyk36 with SMTP id 36so6826740qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Sep 2010 20:34:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c9d7238e26d9e276d9c9ef9792f7c7f8@localhost>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
	<1283988329-44549-6-git-send-email-steve@cozybit.com>
	<e23a1b600a18f179fa72d2cadf724d17@localhost>
	<AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
	<c9d7238e26d9e276d9c9ef9792f7c7f8@localhost>
Date: Thu, 9 Sep 2010 20:34:41 -0700
Message-ID: <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order
 to fetch MAC address
From: Steve deRosier <steve@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 1:58 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 9 Sep 2010 12:13:52 -0700, Steve deRosier <steve@cozybit.com>
>> In the short term, can we limit libertas_tf to build as module only
>> via Kconfig, and I can add the request_firmware_nowait() as a new
>> feature later with a new patch?
>
> Certainly. I just wanted to point it out. This wasn't meant as
> a comment that should stop merging of these patches.
>
>> Looking at the examples, it looks
>> like the changes for this would be fairly involved and I would prefer
>> to break such a change out separately.
>
> Yeah, I tried to do it in libertas_tf at some point last year and
> failed miserably :-)
>
>> I'd like to get
>> libertas_tf_sdio accepted as a base so I can then do smaller change
>> sets going forward. Is that a reasonable plan or just plain silly?
>
> Makes sense to me.
>

In light of the above, and Julian's comments, I'm going to rework the
libertas_tf patch set a little.  I'll make the following two changes:
1. Restrict building to module-only for now.  This avoids building it
into the kernel which we know will break.  Latter when I have time
I'll happily do what's necessary to make the fix Johannes wants, but
as it's not trivial I want to get a base down.
2. I'll change a few things around as Julian's advised so the patch
set makes a bit more sense. I'll be also killing some inadvertent
white-space changes that were mistakes.

I think my mac80211 patch "mac80211: Fix dangling pointer in
ieee80211_xmit" stands 100% alone and fixes a clear bug.  I don't see
any need to delay that one.

It might be a few days before I get these in.

Thanks,
- Steve
