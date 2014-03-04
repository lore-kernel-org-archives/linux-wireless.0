Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63199 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbaCDHPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 02:15:00 -0500
Received: by mail-bk0-f42.google.com with SMTP id mx12so86556bkb.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 23:14:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5314FD54.7070202@candelatech.com>
References: <1393550452-1302-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQnCjkgr3V4bzXW8GHJDmGRHqg6x8An__vFW5bxdub=uyw@mail.gmail.com>
	<5314FD54.7070202@candelatech.com>
Date: Tue, 4 Mar 2014 08:14:59 +0100
Message-ID: <CA+BoTQk1QJfOPORL54kUR+gxBO97BZhHnm_+KV4KgpAruKW0JQ@mail.gmail.com> (sfid-20140304_081527_732077_81237B78)
Subject: Re: [PATCH v2] ath10k: support msdu chaining.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 March 2014 23:08, Ben Greear <greearb@candelatech.com> wrote:
> On 02/27/2014 11:51 PM, Michal Kazior wrote:
>> On 28 February 2014 02:20,  <greearb@candelatech.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Consolidate the list of msdu skbs into the msdu-head skb, delete the
>>> rest of the skbs, pass the msdu-head skb on up the stack as normal.
>>>
>>> Tested with high-speed TCP and UDP traffic on modified firmware that
>>> supports raw-rx.
>>
>> As for an umodified firmware I expect ath10k will just re-assemble
>> corrupted frames just to have them dropped by mac80211. It might be
>> worth checking:
>>
>>  if (chaining && fcs_error)
>>     drop();
>
> As far as I can tell, packets with bad FCS are dropped earlier in that
> rx method?

Ah, good point. We're dropping some frames based on `status` value already.


Michał
