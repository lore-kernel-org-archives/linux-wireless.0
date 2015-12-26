Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbbLZKGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2015 05:06:07 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] enable setting MAC address for r8723au
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
	<1450664916-25205-2-git-send-email-dlenski@gmail.com>
	<56783C98.1080700@lwfinger.net>
	<CAOw_LSF6cPVCxqOS1eQ+iqESZGRdG46048M15r5s0huVJVHwjg@mail.gmail.com>
	<wrfjpoxxxvjq.fsf@redhat.com>
	<CAOw_LSHr-gcrOCrGe8+K6=ndQx21O_HzrxLXJDXnZV5EBJeeyQ@mail.gmail.com>
Date: Sat, 26 Dec 2015 05:06:03 -0500
In-Reply-To: <CAOw_LSHr-gcrOCrGe8+K6=ndQx21O_HzrxLXJDXnZV5EBJeeyQ@mail.gmail.com>
	(Daniel Lenski's message of "Thu, 24 Dec 2015 14:37:24 -0800")
Message-ID: <wrfjlh8hwmlw.fsf@redhat.com> (sfid-20151226_110641_580692_37E142A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> On Wed, Dec 23, 2015 at 3:18 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Daniel Lenski <dlenski@gmail.com> writes:
>> In addition, do *not* overwrite the eeprompriv.mac_addr - that struct is
>> a clean copy of the eeprom's data and should not be modified.
>>
>> Please changed the dev entry and make sure they driver updates from
>> there instead.
>
> I left that part alone (overwriting the eeprompriv.mac_addr) because
> the existing code relies on it containing the correct *current* MAC
> address in numerous places. But, fair enough.
>
> This will require a much more complex patch, because there are
> numerous functions which assume that eeprompriv.mac_addr is the
> current address. (And some of these functions only receive the struct
> rtw_adapter as an argument, rather than the complete netdev.)
>
>> Second, please CC me directly as the driver maintainer.
>>
>> For longer term, please try out rtl8xxxu, hopefully we can
>> rm -rf drivers/staging/rtl8723au soon.
>
> Woah, I didn't know that driver existed. I will take a look.

It's pretty new and should be available in 4.4. I'm still working on
it, so there may be a few rough edges.

Cheers,
Jes
