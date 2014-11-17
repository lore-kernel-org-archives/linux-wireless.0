Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49517 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaKQNHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 08:07:23 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so24703703wgg.8
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 05:07:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416227346.2031.3.camel@sipsolutions.net>
References: <1416223626-10980-1-git-send-email-michal.kazior@tieto.com>
	<1416227346.2031.3.camel@sipsolutions.net>
Date: Mon, 17 Nov 2014 14:07:19 +0100
Message-ID: <CA+BoTQ=JAVb+ROVu2cVz=Rtvgtcb=16pK6fLOvCJNzn_L5v7og@mail.gmail.com> (sfid-20141117_140727_130897_8A9FF0D8)
Subject: Re: [PATCH] mac80211: fix 11b fragmentation rx
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2014 13:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-11-17 at 12:27 +0100, Michal Kazior wrote:
>> After fragmentation reassembly was complete code
>> tried to dereference hdr pointer which pointed to
>> data of an sk_buff that has been freed.
>
> Curious. This bug has been around forever (since the introduction of
> mac80211). I wonder what changed that you *also* found it now - because
> we also found it recently!

I was puzzled at this as well. I hadn't tested fragmentation in a
while and when I did I hit this bug.

[..2 kernel compiles later..]

My hunch was right. Apparently this happens when I use my kernel
.config with some debug stuff enabled. In case you're interested:

 * http://pastebin.com/7shTYtFy -- good
 * http://pastebin.com/pxwdJ5hS -- panic


>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1854,6 +1854,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
>>       /* Complete frame has been reassembled - process it now */
>>       status = IEEE80211_SKB_RXCB(rx->skb);
>>       status->rx_flags |= IEEE80211_RX_FRAGMENTED;
>> +     hdr = (struct ieee80211_hdr *)rx->skb->data;
>
> This is technically correct, but useless. I already have this patch in
> my tree instead:
>
> https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=b8fff407a180286aa683d543d878d98d9fc57b13

Oh. I've missed this. Thanks for pointing out :-)


Michał
