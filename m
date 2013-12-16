Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38901 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3LPSBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 13:01:14 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so4999620wgg.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 10:01:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387205758.2057.17.camel@jlt4.sipsolutions.net>
References: <1387048146-16380-1-git-send-email-mcgrof@do-not-panic.com>
 <1387048146-16380-2-git-send-email-mcgrof@do-not-panic.com> <1387205758.2057.17.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 16 Dec 2013 19:00:53 +0100
Message-ID: <CAB=NE6WmtHy6f9pYx=pKze7N_OpMP2SrPqdvKNFyDn-Bvy1SeA@mail.gmail.com> (sfid-20131216_190121_399574_7A6818A1)
Subject: Re: [PATCH 2/2] cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 3:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-12-14 at 20:09 +0100, Luis R. Rodriguez wrote:
>> The REGULATORY_CUSTOM_REG can be used during early init with
>> the goal of overriding the wiphy's default regulatory settings
>> in case the alpha2 of the device is not known. In the case that
>> the alpha2 becomes known lets avoid having drivers having to
>> clear the REGULATORY_CUSTOM_REG flag by doing it for them
>> when regulatory_hint() is used.
>
> This change brcmsmac behaviour afaict - are you sure that's correct?

It should be, their implementation was just modeled over the ath module.

  Luis
