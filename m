Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34317 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbbFIUaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:30:35 -0400
Received: by igdh15 with SMTP id h15so3672465igd.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 13:30:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433880629.1892.24.camel@sipsolutions.net>
References: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com>
 <1433190967.3505.17.camel@sipsolutions.net> <CABPxzYLMiX1chbNxUd4gfK2HeKkXxHEw1rjf+5on4mskxce1Gg@mail.gmail.com>
 <1433880629.1892.24.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 10 Jun 2015 02:00:14 +0530
Message-ID: <CABPxzYKJJ1OQ8NNfbG+Y2v5DrLUPGO0CX3Cgn53AX23H2gzDmQ@mail.gmail.com> (sfid-20150609_223055_921429_3762B20F)
Subject: Re: [PATCH V2] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 1:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-06-02 at 03:02 +0530, Krishna Chaitanya wrote:
>
>> > This isn't what your patch is actually doing though. You need to mention
>> > WoWLAN at the very least in your commit log;
>
>> Yes, WoWLAN is enabled in our testing. Without wowlan the connection
>> will not be intact. So i assumed the check "is_associated" would
>> imply wowlan.
>
> I meant the commit log.
>
> If I read your commit log without the patch, it doesn't make sense at
> all since regular suspend/resume will turn off the device anyway. You
> really need to mention
>  a) the fact that wowlan is used, and
>  b) the fact that you care about powersave state *while in wowlan*
Hmm...ok, i will rephrase the commit log and re-submit V3, Thanks.
