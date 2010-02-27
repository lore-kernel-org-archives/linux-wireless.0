Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42421 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250Ab0B0Rr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 12:47:27 -0500
Message-ID: <4B895AAA.6070700@openwrt.org>
Date: Sat, 27 Feb 2010 18:47:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] ath9k: Make AR_SREV_5416() macro evaluate to true for AR9100
References: <133e8d7e1002270926p64cfd2b5uc4017bf0187c53c2@mail.gmail.com>
In-Reply-To: <133e8d7e1002270926p64cfd2b5uc4017bf0187c53c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-02-27 6:26 PM, Björn Smedman wrote:
> The AR_SREV_5416() macro evaluates to false for AR9100 while the
> definitions for AR_SREV_5416_20_OR_LATER() and
> AR_SREV_5416_22_OR_LATER() seem to assume AR9100 based chips fall
> under this category. For example the last line of
> 
> #define AR_SREV_5416_20_OR_LATER(_ah) \
>         (((AR_SREV_5416(_ah)) && \
>          ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
>          ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
> 
> makes no sense if AR_SREV_5416(_ah) is false when
> (_ah)->hw_version.macVersion == AR_SREV_VERSION_9100.
I think this is wrong. The AR_SREV_xxxx macros typically point to a
specific chip generation, whereas the AR_SREV_XXXX_OR_LATER() point to
the chip generation or any later.
AR9100 is related to AR9160, but not AR5416, so AR_SREV_5416() should
return false for 9100 based devices.
If you look at the AR_SREV_5416_20_OR_LATER macros, they do not assume
that AR_SREV_5416() evaluates to true for the
((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100) case, as it's
either (is 5416 && macRev >= 20) or macVersion > 9100

- Felix
