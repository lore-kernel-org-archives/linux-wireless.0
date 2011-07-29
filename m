Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54919 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1G2R4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 13:56:40 -0400
Received: by gwaa12 with SMTP id a12so657496gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 10:56:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E32F338.8040901@openwrt.org>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
	<1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
	<4E32F338.8040901@openwrt.org>
Date: Fri, 29 Jul 2011 19:56:39 +0200
Message-ID: <CAGXE3d9hNajZ0C=aVrA9Qf=aRAfZGR6ChVR36yrTqWrLEyP2+A@mail.gmail.com> (sfid-20110729_195731_389841_D1589CD9)
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 7:51 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-07-29 7:22 PM, Helmut Schaa wrote:
>>
>> Since EAPOL frames are normal data frames they are treated by the rate
>> control algorithm as such. Thus it can happen that the rate control
>> algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
>> example) for the 4-way handshake and under low signal conditions the
>> handshake may time out.
>>
>> To fix this issue always treat EAPOL frames the same as management
>> frames and send them with the lowest available rate.
>
> Have you tried preventing minstrel_ht from using EAPOL frames for probing
> different rates instead of forcing it to use the lowest rate?

Nope. I'll give it a try soon.

Thanks,
Helmut
