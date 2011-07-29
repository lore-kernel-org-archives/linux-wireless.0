Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42488 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1G2SAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 14:00:10 -0400
Received: by gxk21 with SMTP id 21so2698847gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 11:00:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9hNajZ0C=aVrA9Qf=aRAfZGR6ChVR36yrTqWrLEyP2+A@mail.gmail.com>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
	<1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
	<4E32F338.8040901@openwrt.org>
	<CAGXE3d9hNajZ0C=aVrA9Qf=aRAfZGR6ChVR36yrTqWrLEyP2+A@mail.gmail.com>
Date: Fri, 29 Jul 2011 20:00:09 +0200
Message-ID: <CAGXE3d-k37U5g7Leq135SzwxgXjdqsJ7-h9kLyoUc1QtbT0w-w@mail.gmail.com> (sfid-20110729_200014_428419_E3A2F637)
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 7:56 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Fri, Jul 29, 2011 at 7:51 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2011-07-29 7:22 PM, Helmut Schaa wrote:
>>>
>>> Since EAPOL frames are normal data frames they are treated by the rate
>>> control algorithm as such. Thus it can happen that the rate control
>>> algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
>>> example) for the 4-way handshake and under low signal conditions the
>>> handshake may time out.
>>>
>>> To fix this issue always treat EAPOL frames the same as management
>>> frames and send them with the lowest available rate.
>>
>> Have you tried preventing minstrel_ht from using EAPOL frames for probing
>> different rates instead of forcing it to use the lowest rate?
>
> Nope. I'll give it a try soon.

Felix, what rate is used by minstrel_ht if there are no statistics yet? MCS0?
