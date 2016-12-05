Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40368 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbcLEPBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:01:17 -0500
Message-ID: <5845813C.8070904@candelatech.com> (sfid-20161205_160126_752392_50FF4B38)
Date: Mon, 05 Dec 2016 07:01:16 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Return avg sig, rx, tx values in ethtool stats.
References: <1480442872-7358-1-git-send-email-greearb@candelatech.com>           (sfid-20161129_190824_045626_457405E8) <1480946891.31788.10.camel@sipsolutions.net>     <58457D63.2010605@candelatech.com> <1480949600.31788.29.camel@sipsolutions.net>
In-Reply-To: <1480949600.31788.29.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/05/2016 06:53 AM, Johannes Berg wrote:
>
>> Unless I screwed up, this patch also returns an average.
>
> Oops, sorry. I missed the whole mac_div() indirection thing.
>
> I'm not super convinced anyway though - all of this data already is
> available in a much more reliable fashion, even trackable when stations
> are removed (all data gets sent in the DEL_STATION notification), so
> adding a crippled way to get the same data seems a bit strange?

Ethtool stats are easy to program against, and I am already making the
get-stats call to get other things, so it was a quick tweak to return
these additional values.  I agree the stats are of somewhat limited worth,
but the cost to get them is also pretty small code wise :)

> In any case I'd want you to resend with the /* pr_..*/ stuff removed.

I can respin with the comment removed.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
