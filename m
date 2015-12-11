Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35751 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbbLKXR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 18:17:57 -0500
Received: by qkfb125 with SMTP id b125so61930426qkf.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 15:17:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 11 Dec 2015 15:17:37 -0800
Message-ID: <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com> (sfid-20151212_001801_158339_DCC9E024)
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 11, 2015 at 10:59 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> I could bisect *if this issue
> is not known*, but it may take a while...

So this is interesting..

The opensuse 4.2.4 kernel worked, but I tried my own vanilla 4.2.4
kernel and that didn't work. This lead me to believe this might be a
config issue. I tried the same config on v4.3, v4.2 and v4.2.4 and all
fail with the same issue!

I just tried a base config from opensuse, then localmodconfig, then
'make xenconfig' (which I need) and that worked. I can't debug further
but I think this config might help debug this further:

http://drvbp1.linux-foundation.org/~mcgrof/tmp/config-iwl-fail.txt

So -- my new config works, but I have no idea what fixed it, a config
option obviously. Not sure what though.

 Luis
