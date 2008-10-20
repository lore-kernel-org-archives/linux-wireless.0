Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38770 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYJTIf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:35:56 -0400
Received: by gxk9 with SMTP id 9so3316468gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 01:35:54 -0700 (PDT)
Message-ID: <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com> (sfid-20081020_103611_126386_FC074E50)
Date: Mon, 20 Oct 2008 01:35:54 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	tomasw@gmail.com
In-Reply-To: <1224491480.18024.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 1:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -244,6 +244,11 @@ typedef unsigned char *sk_buff_data_t;
>>   *   @tc_verd: traffic control verdict
>>   *   @ndisc_nodetype: router type (from link layer)
>>   *   @do_not_encrypt: set to prevent encryption of this frame
>> + *   @requeue: set to indicate that the wireless core should attempt
>> + *           a software retry on this frame if we failed to
>> + *           receive an ACK for it
>
>
>
>> + *   @is_part_ampdu: set to indicate that the wireless core should should
>> + *           treat this frame as part of an AMPDU
>
> I thought we said we could keep the flag instead of moving to the skb
> here?

That was just because the changes required to add this was too much
for 2.6.27 but since we don't care about this fix in 2.6.27 we can do
whatever is needed to fix this properly.

  Luis
