Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45261 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab3CDUFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:05:43 -0500
Received: by mail-we0-f179.google.com with SMTP id p43so4940888wea.24
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 12:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362409909.21028.17.camel@jlt4.sipsolutions.net>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
 <1362204172-28307-6-git-send-email-thomas@cozybit.com> <1362409909.21028.17.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 4 Mar 2013 12:05:21 -0800
Message-ID: <CAG6hwVMAdR4KCMq0x5NvvLUAegLpuYreEn8wuFkZStg+J9JvoA@mail.gmail.com> (sfid-20130304_210546_307539_9E9C68FC)
Subject: Re: [PATCH 6/6] mac80211: init mesh timer for user authed STAs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 7:11 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:
>> There is a corner case which wasn't being covered:
>> userspace may authenticate and allocate stations,
>> but still leave the peering up to the kernel.
>>
>> Initialize the peering timer if the MPM is not in
>> userspace, in a path which is taken by both the kernel and
>> userspace when allocating stations.
>
> Shouldn't this patch go to 3.9, instead of being based on userspace MPM?

I doubt anyone is even exercising the above scenario, but sure, I can
resubmit for 3.9.

-- 
Thomas
