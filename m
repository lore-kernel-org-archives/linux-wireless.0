Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:60104 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaEGHk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:40:29 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so567193wes.18
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:40:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399387552.4218.47.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-6-git-send-email-michal.kazior@tieto.com>
	<1399387552.4218.47.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 09:40:28 +0200
Message-ID: <CA+BoTQnWVFOZt7WNfMMQE9+PMuyaeeYpCHZ9=+gvhJT93eXtCQ@mail.gmail.com> (sfid-20140507_094032_795339_A917C57A)
Subject: Re: [PATCH v4 5/5] cfg80211: remove channel_switch combination check
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 16:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
>> Make the driver responsible for making sure it is
>> capable of performing the switch. It might as well
>> accept a request but then disconnect an interface
>> if some requirements are not met.
>>
>> In that case userspace should be prepared for an
>> appropriate event (AP/IBSS/mesh being stopped/left).
>
> Also makes sense, but I'm not sure if this relies on any previous
> patches, so I won't apply it for now.
>
> The other three I don't think will apply anyway though.

Chanctx reservations provide implicit combination verification so it
doesn't make sense to apply this patch until reservations are used for
AP CSA.


Michał
