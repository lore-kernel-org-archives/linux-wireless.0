Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61490 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab0KVSaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:30:16 -0500
Received: by iwn38 with SMTP id 38so284075iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:30:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTiktEvmbf6aowk+ZX+SFh0AOE6nsFrtxDLQErV4z@mail.gmail.com>
References: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
 <1290389406-29852-1-git-send-email-lacombar@gmail.com> <AANLkTimGO=HH4nxgmCidXfGcLdwnkYQxr+i10eNzefgH@mail.gmail.com>
 <AANLkTiktEvmbf6aowk+ZX+SFh0AOE6nsFrtxDLQErV4z@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 22 Nov 2010 10:29:54 -0800
Message-ID: <AANLkTimcTMKrp3DRfWcXNsC7hA0yfKp9sK-n8e5Kh7dP@mail.gmail.com>
Subject: Re: [PATCH] compat/2.6.22: limit namespace pollution
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 10:14 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Mon, Nov 22, 2010 at 1:01 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Sun, Nov 21, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>>
>> Was this test compiled on all supported kernels?
>>
> I am using this internally for all kernels (.15 -> .36). Beside that,
> I should still test-build the full compat module. Fixes might be
> needed.

Yeah.. then the patch cannot be applied.

> What is the "official" range of supported kernels ?

You'd know better, we use compat down to 2.6.22 in compat-wireless but
last I tried I believe I was able to compile compat even on older
kernels.

> AFAIR, at some
> point, very old kernel are not included by <linux/compat.h>. Do you
> know a module I can use to test regressions, other than my use-case ?

Sure, you can try building compat-wireless as an example but
compat-wireless only goes down to 2.6.22 (IIRC) and compat goes down
to older kernels. Either way, if you take compat down to older than
2.6.22 we'll be good. So you can test anything you care about older
than 2.6.22 and anything above for sure.

  Luis
