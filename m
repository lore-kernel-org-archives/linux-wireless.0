Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52663 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935581AbZLGVF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 16:05:58 -0500
Received: by ewy19 with SMTP id 19so984213ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 13:06:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258408565.32159.42.camel@johannes.local>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
	 <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
	 <1257621757.29454.48.camel@johannes.local>
	 <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com>
	 <1258408565.32159.42.camel@johannes.local>
Date: Mon, 7 Dec 2009 22:06:00 +0100
Message-ID: <83a869cd0912071306y4a56953fm8248b6d030b311ae@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2009-11-16 at 22:53 +0100, gregor kowski wrote:
>> The mac80211 tkip code won't call update_tkip_key, if rx packets
>> are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
>> first packet because the hardware key stuff is called asynchronously with
>> todo workqueue.
>
>> -	ctx->initialized = 1;
>> +	ctx->initialized = TKIP_STATE_PHASE1_DONE;
>
> Now you just need to rename the variable holding it to "state" too...
Done

Sorry for the delay

Gregor
