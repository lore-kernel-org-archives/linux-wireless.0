Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:43721 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab0LMSdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 13:33:32 -0500
Received: by ewy10 with SMTP id 10so4149810ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:33:31 -0800 (PST)
Message-ID: <4D06670B.90200@lwfinger.net>
Date: Mon, 13 Dec 2010 12:33:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sean Paul <seanpaul@google.com>
CC: Brett Rudley <brudley@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 locking up
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>	<7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com> <AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
In-Reply-To: <AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2010 12:22 PM, Sean Paul wrote:
> Hey Brett,
> I've checked the switch, it's enabled. I've also tried the code on a
> different machine (same model) with the same result.
> 
> Sean
> 
> On Mon, Dec 13, 2010 at 10:21 AM, Brett Rudley <brudley@broadcom.com> wrote:
>> Check the RF disable switch on your laptop (also known as airline switch, wireless disable switch, etc).
>> It probably got bumped to the 'disabled' position.

I have noticed some instances where a new kernel will come up with rfkill hard
blocked even when the switch is in the on position, and in one case where the
box does not even have a switch. These have been with b43, thus no hang.
Unloading/reloading the driver fixes the issue, which I think is caused by an
uninitialized variable in rfkill. Thus far, I have not found a cause, and have
not previously reported it.

In any case, booting the computer with the rf switch off should not cause an
infinite loop.

Larry

