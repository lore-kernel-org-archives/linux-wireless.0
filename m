Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYGJMHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 08:07:15 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: sparse warnings on iwlwifi
References: <1215681008.3932.5.camel@johannes.berg>
	<1ba2fa240807100345n15c5ff84mb47267fe547a545@mail.gmail.com>
Date: Thu, 10 Jul 2008 14:07:13 +0200
In-Reply-To: <1ba2fa240807100345n15c5ff84mb47267fe547a545@mail.gmail.com>
	(Tomas Winkler's message of "Thu, 10 Jul 2008 13:45:23 +0300")
Message-ID: <jek5fuhrim.fsf@sykes.suse.de> (sfid-20080710_140719_050389_3571E920)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Tomas Winkler" <tomasw@gmail.com> writes:

> On Thu, Jul 10, 2008 at 12:10 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Was just running sparse for something unrelated and noticed these:
>>
>> drivers/net/wireless/iwlwifi/iwl-rx.c:832:2: warning: cast truncates=
 bits from constant value (1c00 becomes 0)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates=
 bits from constant value (6f080000 becomes 0)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates=
 bits from constant value (6f080000 becomes 0)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:856:3: warning: cast truncates=
 bits from constant value (4001 becomes 1)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:860:3: warning: cast truncates=
 bits from constant value (a000 becomes 0)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:864:3: warning: cast truncates=
 bits from constant value (c000 becomes 0)
>
> Yeah I've actually wanted to ask someone how to solve. This comes fro=
m
> radio tap code, frankly currently very low priority on my list.
> Not sure why but only calling directly to put_unalinged_le32 fixes
> this warning. In general put_unaligned should be expanded to this
> macro.

Only after constant folding.  The put_unaligned macro itself contains
calls to all put_unaligned_be?? variants with corresponding casts, and
sparse does no constant folding here, apparently.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
