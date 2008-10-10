Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:33267 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbYJJSje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:39:34 -0400
Received: by mu-out-0910.google.com with SMTP id g7so546519muf.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 11:39:32 -0700 (PDT)
Message-ID: <45e8e6c40810101139r3fd97443n7171e8a29862098@mail.gmail.com> (sfid-20081010_203937_155040_C4B1E3FA)
Date: Fri, 10 Oct 2008 11:39:31 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/8] mac80211: remove aggregation status write support from debugfs
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100438.773792000@sipsolutions.net>
	 <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com>
	 <1223452772.3618.20.camel@johannes.berg>
	 <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, this adds two nl80211 commands (NEW_BA and DEL_BA)
https://cozybit1.dnsalias.org/~andrey/patches/001-add-ba-session-command-nl80211.patch
and this adds corresponding "station addba" and "station delba"
options for them to iw:
https://cozybit1.dnsalias.org/~andrey/patches/002-iw-add-nl80211-ba-commands.patch

With the current code, I am not sure if it's ever intended that user
space has the ability to initiate and tear down BA sessions, so this
may or may not be useful to others.  Right now I am using them to test
BA initiation and teardown and I suspect that they may be useful to,
for example, hostapd in the future.

Please let me know what you think.  Thanks,

  -Andrey

On Fri, Oct 10, 2008 at 11:22 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Oct 8, 2008 at 12:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2008-10-07 at 23:24 +0200, Tomas Winkler wrote:
>>> On Tue, Oct 7, 2008 at 12:04 PM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>> > This code uses static variables and thus cannot be kept.
>>> NACK
>>> Need something to debug this stuff
>>
>> Tough luck. Go write proper support in nl80211 then.
>
> Someone has some patch to use nl80211 for this BTW. *cough*
>
>  Luis
>
