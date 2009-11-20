Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54593 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZKTX1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 18:27:07 -0500
Received: by iwn8 with SMTP id 8so2909412iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 15:27:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258756647.2714.17.camel@localhost.localdomain>
References: <1258756647.2714.17.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 Nov 2009 15:26:52 -0800
Message-ID: <43e72e890911201526y5b36328ft3a510e546508df66@mail.gmail.com>
Subject: Re: iwlagn + Ad-Hoc + 5Ghz
To: Jeremy Moles <jeremy@emperorlinux.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2009 at 2:37 PM, Jeremy Moles <jeremy@emperorlinux.com> wrote:
>
> Hello all! I have a group of machine here with an app that needs to set
> up an ad-hoc network in 5Ghz+ range. The machines themselves are all
> different (a Panasonic, a Dell, and a Lenovo) but they are all using
> 5100 cards, a 2.6.31 kernel, and the 2.6.31-rc7 driver from the website.
>
> Using the command "iw list" I can get a lot of helpful info, but I see
> "no IBSS" on any channel over 11, and I'm beginning to think that this
> just isn't supported on these cards yet.

No, this has nothing to do not supporting IBSS but instead you should
read "no IBSS" more as a regulatory rule that implies you cannot use a
mode of operation that can beacon. We should at least rename this on
iw for now to make thins clearer.

What you see should be part of the default rules embedded on the
device's EEPROM. Beaconing is allowed on channel 11 even on the most
restrictive regulatory domain and this is why the world regulatory
domain allows 1-11 to beacon too.

You should enable debugging on the driver upon load to confirm whether
this rule is coming from the EEPROM. Do you have
CONFIG_WIRELESS_OLD_REGULATORY? I think even that (by default it used
the US) enabled beaconing. Drivers can overrule things though if their
EEPROM mandates this.

  Luis
