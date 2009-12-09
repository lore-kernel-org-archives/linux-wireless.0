Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:45530 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbZLIWVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 17:21:42 -0500
Received: by ewy1 with SMTP id 1so4924461ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 14:21:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83a869cd0912071306y4a56953fm8248b6d030b311ae@mail.gmail.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
	 <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
	 <1257621757.29454.48.camel@johannes.local>
	 <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com>
	 <1258408565.32159.42.camel@johannes.local>
	 <83a869cd0912071306y4a56953fm8248b6d030b311ae@mail.gmail.com>
Date: Wed, 9 Dec 2009 23:21:45 +0100
Message-ID: <83a869cd0912091421s62b704f6wae023c61cab85e92@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch doesn't seem to apply to new version of kernel.
I am submitting a new one.

On 12/7/09, gregor kowski <gregor.kowski@gmail.com> wrote:
> On 11/16/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Mon, 2009-11-16 at 22:53 +0100, gregor kowski wrote:
>>> The mac80211 tkip code won't call update_tkip_key, if rx packets
>>> are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
>>> first packet because the hardware key stuff is called asynchronously
>>> with
>>> todo workqueue.
>>
>>> -	ctx->initialized = 1;
>>> +	ctx->initialized = TKIP_STATE_PHASE1_DONE;
>>
>> Now you just need to rename the variable holding it to "state" too...
> Done
>
> Sorry for the delay
>
> Gregor
>
