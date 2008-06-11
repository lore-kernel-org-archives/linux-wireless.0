Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:64578 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYFKKNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 06:13:19 -0400
Received: by an-out-0708.google.com with SMTP id d40so717895and.103
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 03:13:18 -0700 (PDT)
Message-ID: <43e72e890806110313s3c53d1b7n314c659493b941bf@mail.gmail.com> (sfid-20080611_121322_737964_98C3E14B)
Date: Wed, 11 Jun 2008 03:13:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pommnitz@yahoo.com
Subject: Re: [RFC] First CRDA integration work
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890806110309l2600637p82866531cf2f7e6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <951547.47167.qm@web51403.mail.re2.yahoo.com>
	 <43e72e890806110309l2600637p82866531cf2f7e6c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 3:09 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Jun 11, 2008 at 1:28 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>> Hello Luis,
>> I did not read the complete patch but closely looked at the CRDA design picture. I have a comment:
>> The company I work for has special regulatory approval to use amplified WLAN on certain channels (up to 4W). The nodes additionally have non-amplified WLAN adapters that fall under the normal regulatory requirements. It would be nice if your work allowed to specify such cases, e.g. have different regulatory restrictions for differen cards in the same machine. In our case we would like to restrict the amplified interface to the channels it is allowed to run on.
>
> Hm, interesting. Well you can simply use a custom db.txt with a custom
> PGP private key to sign it and also provide your customers with a
> custom CRDA which uses this. All you'd have to do is modify the keys
> and db.txt. This of course doesn't work to help comply if you have

I meant to say if you don't have.

> extra regulatory efforts on the drivers using the EEPROM of firmware
> so the next best thing would be to add a struct ieee80211_regdomain to
> each struct wiphy. I considered this too but this starts to move away
> from the centralized scheme. Its good you mention this case though.
> Can you elaborate a bit more on it. Why do you need two separate WLAN
> devices on one node where each one of them is using very different
> regulatory rules? Do they both use the same frequency ranges?

  Luis
