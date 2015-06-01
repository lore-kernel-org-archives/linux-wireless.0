Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34885 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbbFAVcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 17:32:25 -0400
Received: by iesa3 with SMTP id a3so119379580ies.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 14:32:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433190967.3505.17.camel@sipsolutions.net>
References: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com> <1433190967.3505.17.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 2 Jun 2015 03:02:04 +0530
Message-ID: <CABPxzYLMiX1chbNxUd4gfK2HeKkXxHEw1rjf+5on4mskxce1Gg@mail.gmail.com> (sfid-20150601_233233_352249_DE5816D7)
Subject: Re: [PATCH V2] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2015 at 2:06 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-06-01 at 22:44 +0530, Chaitanya T K wrote:
>> From: Chaitanya T K <chaitanya.mgit@gmail.com>
>>
>> If suspended during TX in progress, there can be
>> race where the driver is put of of power-save due
>> to TX and during suspend dynamic_ps_time is cancelled
>> and TX packet is flushed, leaving the driver in ACTIVE
>> even after resuming until dynamic_ps_time puts
>> driver back in DOZE. (Which only happens if there
>> is another TX).
>>
>> This can lead high power consumption of chipset during (or)
>> after resuming also.
>
> This isn't what your patch is actually doing though. You need to mention
> WoWLAN at the very least in your commit log;
Yes, WoWLAN is enabled in our testing. Without wowlan the connection
will not be intact. So i assumed the check "is_associated" would
imply wowlan.

> or are you just randomly
> changing the code until it fixes your bug? :)
I am not that lucky to find a proper fix that way :-).
