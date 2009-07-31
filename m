Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47425 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZGaXWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 19:22:39 -0400
Received: by gxk9 with SMTP id 9so4223001gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 16:22:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A737AFC.40301@gmx.de>
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>
	<4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj> <4A737AFC.40301@gmx.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 16:22:19 -0700
Message-ID: <43e72e890907311622u1059be72y7c833f888b11cf56@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: Makefile: fixed test expressions for target
	install
To: Joerg Albert <jal2@gmx.de>
Cc: Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 4:15 PM, Joerg Albert<jal2@gmx.de> wrote:
> On 07/31/2009 08:56 PM, Pavel Roskin wrote:
>
>> No, I didn't mean that.  I meant:
>>
>> if [ -z "" ] && [ -z "" ]; then echo "both empty"; fi
>> ...
>> We should not rely on any bash features as /bin/sh may not be bash at
>> all.
>
> Agreed. Will repost the patch.

Actually please do keep relying on /bin/bash, all the scripts on
compat-wireless do depend on /bin/bash, I don't expect users of
dash/etc to use compat-wireless.

If we want to make compat-wireless be shell agnostic we'd need to
address all the other scripts. I rather not deal with that now unless
we really think that is also a good idea and someone is up for the
task.

  Luis
