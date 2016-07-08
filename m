Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33052 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbcGHPb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:31:28 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so8443971pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2016 08:31:28 -0700 (PDT)
Subject: Re: [PATCH 0/5] Improve wireless netdev detection
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
 <1467973953.4837.3.camel@sipsolutions.net> <577FC51E.7010901@gmail.com>
 <1467991593.4837.7.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <577FC74E.3080903@gmail.com> (sfid-20160708_173135_150419_A2B98746)
Date: Fri, 8 Jul 2016 10:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <1467991593.4837.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

 >> Are you okay with the general approach?
>
> I see no issues with sending these events out. I'd like them to
> actually be reliable (if present) though, not double as you'd implied -
> but I didn't really understand in which cases you were expecting
> issues, was it only P2P-Device?
>

That seems to be the only special case.  At least I didn't find any 
other situations where a NEW_INTERFACE command can be called without a 
corresponding net_device being created.

>>   Are there any locking issues I
>> might be overlooking?
>
> Not that I'm aware of. All of the netdev/wdev handling should be
> protected by RTNL.
>

That was my understanding as well.  Thanks.

Okay, let me spin up a v2 with patches 2+3 and 4+5 squished together. 
Or do you want one big patch?

Regards,
-Denis
