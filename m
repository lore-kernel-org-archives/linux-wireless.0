Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:12185 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZFHRva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 13:51:30 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1357732wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 10:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244442549.11006.2.camel@johannes.local>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
Date: Mon, 8 Jun 2009 19:51:32 +0200
Message-ID: <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2009 at 8:29 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Sun, 2009-06-07 at 21:49 +0000, gregor kowski wrote:
>> The mac80211 tkip code won't call update_tkip_key, if some rx packets
>> get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
>> first packet because the hardware key stuff is called asynchronously
>> with
>> todo workqueue.
>>
>> This patch workaround that by always calling update_tkip_key if
>> the packet wasn't decrypted by the hardware.
>>
>> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
>> Index: linux-2.6/net/mac80211/tkip.c
>> ===================================================================
>> --- linux-2.6.orig/net/mac80211/tkip.c  2009-06-07 19:32:26.000000000
>> +0000
>> +++ linux-2.6/net/mac80211/tkip.c       2009-06-07 21:31:31.000000000
>> +0000
>> @@ -298,19 +298,19 @@
>>                         printk("\n");
>>                 }
>>  #endif
>> -               if (key->local->ops->update_tkip_key &&
>> -                       key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>> -                       u8 bcast[ETH_ALEN] =
>> -                               {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
>> -                       u8 *sta_addr = key->sta->sta.addr;
>> +       }
>> +       if (key->local->ops->update_tkip_key &&
>> +               key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>> +               u8 bcast[ETH_ALEN] =
>> +                       {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
>> +               u8 *sta_addr = key->sta->sta.addr;
>
> There's a quite obvious disconnect between what your patch does and what
> your description says, please fix one of them. As it is, the patch only
> skips the IV rollover which is *completely* wrong because it will call
> the function for *every* packet.
I don't understand what you mean : the callback will be called for
every packet the hardware doesn't decrypted. If the hardware decrypt
the packet, only_iv is set and we don't go here.


Gregor
