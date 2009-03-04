Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:45750 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZCDOaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 09:30:09 -0500
Received: by ti-out-0910.google.com with SMTP id d10so3480320tib.23
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 06:30:06 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18862.36931.112561.497768@gargle.gargle.HOWL> (sfid-20090304_153014_025858_A59021B7)
Date: Wed, 4 Mar 2009 19:59:23 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
	devices
In-Reply-To: <49AE851B.2070709@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
	<18862.1025.217829.656599@gargle.gargle.HOWL>
	<49AE851B.2070709@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> >> +#define AR_SREV_5416(_ah) \
> >> +       (((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) || \
> >> +       ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI))
> >> +#define AR_SREV_5416_V20_OR_LATER(_ah) \
> >> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) || \
> >> +       ((AR_SREV_5416(_ah)) && \
> >> +       ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)))
> >> +#define AR_SREV_5416_V22_OR_LATER(_ah) \
> >> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) || \
> >> +       ((AR_SREV_5416(_ah)) && \
> >> +       ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)))
> >> +
> > 
> > Hm, the 5416_V1, 5416_V2 macros have to check 3 different HW (5416, 9100, 9160).
> 
> I don't see any 5416_V1 macro here. The AR_SREV_5416 should check the silicon
> revision of the AR5416 cards only. But if we would be consistent, we should have
> a _V10_OR_LATER although i don't see where it would be useful. The _V20_OR_LATER
> and the _V22_OR_LATER macro I proposed above will cover the 9100 and 9160 chips.
> 

I meant the AR_SREV_5416_V20_OR_LATER and AR_SREV_5416_V22_OR_LATER macros.
Yes, the naming implies that they are meant for AR5416 chipsets only, but they
do handle AR9100 and AR9160 chipsets.

The proposed macros don't have the AR9100 and AR9160 macVersion checks, no ?

Sujith
