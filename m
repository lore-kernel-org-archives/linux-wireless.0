Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43014 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3JBJEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:04:52 -0400
Received: by mail-ie0-f182.google.com with SMTP id aq17so1134325iec.41
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 02:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380703470.13329.1.camel@jlt4.sipsolutions.net>
References: <1380699789-3765-1-git-send-email-helmut.schaa@googlemail.com>
	<1380703470.13329.1.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 11:04:51 +0200
Message-ID: <CAGXE3d8B=9dZ9xnramK3vLaNY8uDrpEp1itQh6WVp_4o+Qk3+g@mail.gmail.com> (sfid-20131002_110455_565610_6298BD01)
Subject: Re: [PATCH] nl80211: Provide per channel maximum regulatory transmit power
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 2, 2013 at 10:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-10-02 at 09:43 +0200, Helmut Schaa wrote:
>> In some cases its not only required to know the maximum transmit power
>> the hw is capable of. Instead, userspace (hostapd) might want to know
>> the maximum transmit power as defined in the current regulatory domain
>> (for example for 802.11d country IEs).
>
> Why wouldn't it use (the equivalent of) "iw reg get" for that?

Might be the more sane approach.

I noticed that hostapd generates 11d IEs based on the channel list it
reads from the kernel.
Thus restricting STAs to the max tx power the hw is capable of. Just
adding the max regulatory
tx power looked like an easy solution :)

Jouni, would you be ok with using the kernels regulatory domain for
11d IEs in hostapd?

Thanks,
Helmut
