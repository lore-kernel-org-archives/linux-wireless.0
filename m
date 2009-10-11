Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53411 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbZJKLyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 07:54:31 -0400
Received: by ewy4 with SMTP id 4so1780221ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 04:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091011.033907.35699436.davem@davemloft.net>
References: <1255256361.4095.56.camel@johannes.local>
	 <20091011.033907.35699436.davem@davemloft.net>
Date: Sun, 11 Oct 2009 19:53:54 +0800
Message-ID: <a8e1da0910110453t144973cfmd0fb61120a9e497b@mail.gmail.com>
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: Dave Young <hidave.darkstar@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	kalle.valo@iki.fi, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 6:39 PM, David Miller <davem@davemloft.net> wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 11 Oct 2009 12:19:21 +0200
>
>> Due to the way it interacts with the networking
>> stack and other parts of mac80211, ieee80211_rx()
>> must be called with disabled softirqs.
>>
>> Michael, the former maintainer of this driver,
>> has refused to fix the problem this way instead
>> proposing a much more invasive patch that could
>> not even be proved correct wrt. locking inside
>> mac80211. Regardless of that, he believes this
>> to be a bug in mac80211, and has also publicly
>> stated [1] that he does not care about this even
>> though it is a regression introduced by his own
>> patches.
>>
>> Since nobody else seems to be wanting to fix the
>> problem, I'll just fix it for the benefit of the
>> many users of this driver.
>>
>> [1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440/focus=40266
>>
>> Reported-by: Dave Young <hidave.darkstar@gmail.com>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> Acked-by: David S. Miller <davem@davemloft.net>
>

Tested-by: Dave Young <hidave.darkstar@gmail.com>

-- 
Regards
dave
