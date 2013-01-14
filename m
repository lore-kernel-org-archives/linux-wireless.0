Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41781 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3ANKBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 05:01:10 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn14so1117670wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 02:01:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87txqkz0yk.fsf@purkki.adurom.net>
References: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
	<87txqkz0yk.fsf@purkki.adurom.net>
Date: Mon, 14 Jan 2013 12:01:08 +0200
Message-ID: <CAMvjH0BkRS0HpjqHQyFOmnqmQs4AR9HGWh07FSz2yh3TiTBy6w@mail.gmail.com> (sfid-20130114_110115_135180_53A77060)
Subject: Re: Custom commands for cfg80211 based driver (like iwpriv)
From: Eugene <wifi.mailing.list@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/14 Kalle Valo <kvalo@adurom.com>:
> Eugene <wifi.mailing.list@gmail.com> writes:
>
>> How to add custom configuration command for cfg80211 based driver.
>>
>> For WEXT was private IOCtls (iwpriv).
>>
>> What the recommended way for nl80211/cfg80211?
>
> Luckily private commands are now banned, it was such a mess. Now you add
> a new generic command to nl80211/cfg80211 so that all drivers can use
> it. The benefit is that the driver can be changed without any
> modifications to user space.

That's really good benefit.
But as a disadvantage for that approach required changes for kernel,
which cannot be done real-time (insmod for example).

>
> Only exceptions are NL80211_CMD_TESTMODE for low level factory/RF tests
> and debugfs for developer debugging purposes.
>

Hmm...
That's good point for testing, but still unusable for production.

> --
> Kalle Valo

Why kernel do not support custom commands, like TESTMODE?
The reason is to unify all drivers?
But what about new (or proprietary) features, use kernel patches only?
