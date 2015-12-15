Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35948 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbLOMTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:19:34 -0500
Received: by mail-qk0-f182.google.com with SMTP id t125so9011344qkh.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2015 04:19:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450181385.3356.6.camel@sipsolutions.net>
References: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com>
	<1450181385.3356.6.camel@sipsolutions.net>
Date: Tue, 15 Dec 2015 13:19:33 +0100
Message-ID: <CABAco3CgkoCYdHZV6nBfV+CUpD379XR69EiznXvu42p5UC96gw@mail.gmail.com> (sfid-20151215_131945_518214_5DAF935E)
Subject: Re: [PATCH] nl80211: Potential memory leaks in reg.c
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to learn how the code works so I'm reading through it line
by line. I have seen so many memory leaks in my days so I know where
to look ;)
They are indeed obscure since we need an error to actually trigger
them but I thought I might as well share the info when I found them.

On Tue, Dec 15, 2015 at 1:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-12-13 at 19:12 +0100, Ola Olsson wrote:
>> The first leak occurs when entering the default case
>> in the switch for the initiator in set_regdom.
>> The second leaks a platform_device struct if the
>> platform registration in regulatory_init succeeds but
>> the sub sequent regulatory hint fails due to no memory.
>
> Applied, thanks. How are you finding these?? They seems so obscure :)
>
> johannes
