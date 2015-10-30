Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35735 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030725AbbJ3KLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 06:11:46 -0400
Received: by iofz202 with SMTP id z202so74439487iof.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2015 03:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1446197844.3261.18.camel@sipsolutions.net>
References: <CABPxzYJNCFzCWgbRYxGbkrf1x6BPupC8+O5R7167FDL1rK+4mA@mail.gmail.com>
 <1446197844.3261.18.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 30 Oct 2015 15:41:26 +0530
Message-ID: <CABPxzYK8nW2wsmYWxANOGy39JT7n=ypQwaoJ3n9+JaFqqmfjdA@mail.gmail.com> (sfid-20151030_111149_909996_BE59A4D7)
Subject: Re: Undocumented Sleep Requirements for ieee80211_ops
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 3:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2015-10-29 at 12:16 +0530, Krishna Chaitanya wrote:
>> Hi,
>>
>> From the documentation:(mac80211.h) For the ieee80211_ops
>> (un)assign_vif_chanctx, there is no mention of explicit sleep
>> requirements (allowed/disallwoed) for the callback.
>
> Same goes for drv_switch_vif_chanctx().
Yes.
>
>> From a quick glance at the code calling the OP, looks like we can
>> sleep (mutexes are used). So how should we handle such OPS? is it ok
>> to sleep in the callback?
>>
>
> You can sleep, and I'd appreciate if you sent a patch to add
> might_sleep() to the code and the appropriate documentation.
Sure, will send a patch.
