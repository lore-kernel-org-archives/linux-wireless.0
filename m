Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:64540 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZKGTml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 14:42:41 -0500
Received: by pxi10 with SMTP id 10so1466730pxi.33
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 11:42:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0911071102l3b7710fndb84fb738133dcb3@mail.gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
	<43e72e890911060821r2703c186lbb75c40b449b2c55@mail.gmail.com>
	<fd145f7d0911071102l3b7710fndb84fb738133dcb3@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 7 Nov 2009 11:42:27 -0800
Message-ID: <43e72e890911071142o6b0d0e9ap299e7f9b2bc21f15@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2009 at 11:02 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 8:21 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Nov 6, 2009 at 12:04 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
>> So one way or another user intervention is required to alter current
>> regulatory solutions. For Linux though the best solution *as an end
>> user* to enable AP mode is not to alter wireless-regdb but instead to
>> report your issue. In your case you have a non-trivial regression
>> which does indeed need to be addressed.
>
> Thanks, your email(s) explained a great number of issues.  I don't
> have the expertise to contribute here, so I leave it in your capable
> hands.  I would say, however, that from the _user's_ perspective, the
> best thing is if a wifi card bought in the USA from a USA retailer
> automagically conformed to USA regulations, even if that's an issue to
> be taken up with the card manufacturer and not with the driver
> authors.

Agreed, however how devices get programmed is a little complex than
just a country code. So one option is to use a direct country code and
that's it, another option is to use a world regulatory domain when you
want to target a few countries and want to have passive scanning
enabled -- typically business laptop SKUs. Then you have the region
codes as your card has which is targetted for a few set of countries
on a region, for example a european region code.

What we have learned from implementing a solution on Linux is this
wasn't easy to manage but that we can make it simpler. At Atheros at
least we might stop using the region codes and just stick to the world
roaming options and direct country codes. The Linux implementation we
have done has helped to re-evaluate current implementations and has
helped us adapt to better more reasonable solutions.

These things just take time to change.

  Luis
