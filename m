Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:44896 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbZHQQGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:06:34 -0400
Received: by gxk1 with SMTP id 1so4139757gxk.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:06:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250521206.15103.10.camel@johannes.local>
References: <1250518613.15103.7.camel@johannes.local> <1250521206.15103.10.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 17 Aug 2009 09:06:14 -0700
Message-ID: <43e72e890908170906w5b8c265bkf2c4ab2a92482718@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow configure_filter callback to sleep
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 8:00 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-08-17 at 16:16 +0200, Johannes Berg wrote:
>> Over time, a whole bunch of drivers have come up
>> with their own scheme to delay the configure_filter
>> operation to a workqueue. To be able to simplify
>> things, allow configure_filter to sleep, and add
>> a new prepare_multicast callback that drivers that
>> need the multicast address list implement. This new
>> callback must be atomic, but most drivers either
>> don't care or just calculate a hash which can be
>> done atomically and then uploaded to the hardware
>> non-atomically.
>
> Oh I should probably mention that
>  1) I only tested with hwsim, but
>  2) I don't think it will break much since it doesn't really change most
>    drivers.

A pm-suspend->resume test might be nice as well.

  Luis
