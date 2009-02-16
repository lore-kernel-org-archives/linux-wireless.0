Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:10496 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZBPISo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:18:44 -0500
Received: by el-out-1112.google.com with SMTP id b25so1176736elf.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 00:18:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234695674.4219.50.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
	 <1234695674.4219.50.camel@johannes.local>
Date: Mon, 16 Feb 2009 00:18:42 -0800
Message-ID: <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com> (sfid-20090216_091847_984323_1682B24F)
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 3:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>> Calling kobject_uevent_env() can fail mainly due to out of
>> memory conditions. We do not want to continue during such
>> conditions so propagate that as well instead of letting
>> cfg80211 load as if everything is peachy.
>>
>> Additionally lets clarify that when CRDA is not called during
>> cfg80211's initialization _and_ if the error is not an -ENOMEM
>> its because kobject_uevent_env() failed to call CRDA, not because
>> CRDA failed. For those who want to find out why we also let you
>> do so by enabling the kernel config CONFIG_CFG80211_REG_DEBUG --
>> you'll get an actual stack trace.
>>
>> So for now we'll treat non -ENOMEM kobject_uevent_env() failures as
>> non fatal during cfg80211's initialization.
>
> I disagree with this patch -- there's so much that can go wrong even if
> allocating the message here is ok that imho it's hardly useful to check
> for errors here.

Huh?? ENOMEM is the only error we are propagating  -- that itself
seems reasonable to propagate.

> crda could fail, not be installed, etc.

This is never propagated to the kernel, that is not what this patch
does. Those failures you mentioned should not prevent cfg80211 from
moving on.

All this patch does is propagate -ENOMEMs.

  Luis
