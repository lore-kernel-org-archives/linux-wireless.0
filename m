Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:11187 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBSHv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 02:51:59 -0500
Received: by yw-out-2324.google.com with SMTP id 5so114041ywh.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 23:51:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <878wo2j4vo.fsf@litku.valot.fi>
References: <1235002285-14812-1-git-send-email-lrodriguez@atheros.com>
	 <878wo2j4vo.fsf@litku.valot.fi>
Date: Wed, 18 Feb 2009 23:51:57 -0800
Message-ID: <43e72e890902182351jae378d5m4515a23a3ae28a91@mail.gmail.com> (sfid-20090219_085245_264815_8DC699F2)
Subject: Re: [PATCH] cfg80211: default OLD_REG to n
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 10:51 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
>
>> Since we are not following the schedule to remove OLD_REG by 2.6.29
>> lets simply set it to default to n for 2.6.30 and schedule its
>> removal for 2.6.31
>
> [...]
>
>>  config WIRELESS_OLD_REGULATORY
>>       bool "Old wireless static regulatory definitions"
>> -     default y
>> +     default n
>>       ---help---
>>         This option enables the old static regulatory information
>>         and uses it within the new framework. This is available
>
> What does this mean in practise? If a user compiles the kernel with
> the default settings, the wireless will work only if crda is
> installed?

No, it means you get the static world regdomain by default instead of
the static US world regdomain by default.

> If that's the case, this is way too early. All lazy people, like me,
> will get very frustrated because of this. They don't want to make all
> those hoops to install crda, they just want their wireless to work.
>
> For example, I still can't find crda from debian unstable. In my
> opinion we need to wait _at least_ a year after it's available in all
> distros, and only then we can make crda the default.

Keep in mind OLD_REG still alows usage of CRDA, OLD_REG just means "3
static regdomains, ieee80211_regdom module parameter, and make the US
static regdom the default". That's all.

> Let's not make the same mistake the udev people did. That was a
> disaster few years back, I suffered from it multiple times.
> Fortunately things have calmed down now and I can safely update the
> kernel.

Whatever works.

  Luis
