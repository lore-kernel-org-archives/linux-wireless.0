Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34749 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbcECQ6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 12:58:49 -0400
Received: by mail-yw0-f175.google.com with SMTP id j74so26121748ywg.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2016 09:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462291262.2251.4.camel@sipsolutions.net>
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
 <1462281243.2251.2.camel@sipsolutions.net> <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com>
 <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com> <1462291262.2251.4.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 May 2016 22:28:28 +0530
Message-ID: <CABPxzY+JXre1SzGyqmwYhTw9BB_-PfR02basW0WS34wZKpxK7g@mail.gmail.com> (sfid-20160503_185852_966207_7B98A818)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 3, 2016 at 9:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-05-03 at 20:02 +0530, Krishna Chaitanya wrote:
>
>> > i don't see any issues in the powersave w.r.t driver. Isn't it a
>> > valid case? you meant implementing dynamic_ps?
>
> No, I really did mean implementing the entire PS logic in the driver,
> instead of having mac80211 do it.
>
>> If it advertise HW_SUPPORTS_DYNAMIC_PS it works fine.
>> so may be we should queue those frames and send it to
>> HW once it is out of powersave?
>
> We could, but I *really* don't want to patch over the messy and broken
> powersave code in mac80211 now.
>
> I really do think that the only way out of this mess is to implement
> powersave entirely outside of mac80211; perhaps mac80211 could provide
> helpers for it, but tying it into the MLME implementation and having
> all the PS-Poll stuff be global etc. is simply wrong today.
Okay, i understand. This again points to our discussion about mac80211
ps a while ago. May be we should document this somewhere so that
device driver developers are aware of this?



-- 
Thanks,
Regards,
Chaitanya T K.
