Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.ugent.be ([157.193.71.182]:58689 "EHLO smtp1.ugent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab3GaK2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 06:28:21 -0400
Received: from localhost (mcheck2.ugent.be [157.193.49.249])
	by smtp1.ugent.be (Postfix) with ESMTP id ABF788152
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 12:28:20 +0200 (CEST)
Received: from smtp1.ugent.be ([157.193.71.182])
	by localhost (mcheck2.UGent.be [157.193.43.11]) (amavisd-new, port 10024)
	with ESMTP id 9BxSZ-Rr1QbR for <linux-wireless@vger.kernel.org>;
	Wed, 31 Jul 2013 12:28:20 +0200 (CEST)
Received: from mail-la0-f47.google.com (mail-la0-f47.google.com [209.85.215.47])
	(Authenticated sender: mathieu.devos@ugent.be)
	by smtp1.ugent.be (Postfix) with ESMTPSA id F0702808C
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 12:28:19 +0200 (CEST)
Received: by mail-la0-f47.google.com with SMTP id eo20so366836lab.34
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 03:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F8E228.9080600@broadcom.com>
References: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
	<51F8E228.9080600@broadcom.com>
Date: Wed, 31 Jul 2013 12:28:19 +0200
Message-ID: <CAE_+Soyxz-RfyVeg-Z4Fv5tmUtH=9wutxgM0CGjHEne9zJq+Kg@mail.gmail.com> (sfid-20130731_122825_229057_09BB9378)
Subject: Re: Skb and ieee80211 headers
From: Mathieu Devos <mathieu.devos@ugent.be>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It's an android smartphone (I 9100 - Samsung galaxy S2) so it does not
have a normal ethernet 802.3 input even. I check before selecting the
device that it's wireless (through ieee80211_ptr) and this properly
returns the wlan0 device which should be on the 80211 standard.

My goal is to get the ieee80211_header properly on the skb with this
device, but some of the pointers and original data in the skb seem
totally off. This leaves me clueless as to where to put this
ieee80211_header.
I've tried putting it right on skb->head (wrong I know, but I was
getting desperate), on skb->mac_header (also wrong, no idea why
though), I went back from skb->tail with len and even added ETH_HLEN
to that as well because you can see that before my hook gets
activated: skb_pull_inline(skb, ETH_HLEN);
In the end I'm left with a header that is forced onto data but with a
wrong origin pointer thus basically leaving me with all wrong data in
the header.

Kind regards,
Mathieu Devos

On Wed, Jul 31, 2013 at 12:08 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/31/2013 11:39 AM, Mathieu Devos wrote:
>>
>> Hi,
>>
>> I hope this is the right place to ask for a little bit of help as I'm
>> currently beyond stuck on a challenge I'm trying to accomplish. I'm
>> trying to write a "simple" LKM that properly uses a ieee80211 header
>> to print information about the mac addresses (addr1->addr4) and later
>> down the road try to send my own data.
>>
>> I only need to get L2 working, no need for TCP/IP, just a proper
>> ieee80211 based on input from skb would be huge for me.
>>
>> So my issue: when placing the ieee80211 on my mac_header after I hook
>> my skb from my wireless device (wlan0 on android - I9100)
>
>
> Not sure what you goal is, but what wireless device is that? You may just
> get 802.3 packets from the device.
>
> Gr. AvS
>
>
>> I get a huge
>> amount of zero's and random(?) numbers when trying to print the
>> addresses. This leads me to the first conclusion that mac_header is
>> placed wrong when using 80211. After that I saw a lot of people just
>> using the skb->data pointer. Now this gives even weirder issues for me
>> and actually totally crashes my kernel.
>
>
>
>
