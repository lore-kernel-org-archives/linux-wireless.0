Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f182.google.com ([209.85.160.182]:47379 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3BRCQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 21:16:43 -0500
Received: by mail-gh0-f182.google.com with SMTP id z15so495141ghb.27
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2013 18:16:42 -0800 (PST)
Message-ID: <51218895.1050602@lwfinger.net> (sfid-20130218_031647_664056_6464F543)
Date: Sun, 17 Feb 2013 19:49:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	Bastian Bittorf <bittorf@bluebottle.com>
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
References: <1342612598.5006a476022c6@mail.bluebottle.com> <20130214203553.GA27934@medion.lan>
In-Reply-To: <20130214203553.GA27934@medion.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 02:35 PM, Bastian Bittorf wrote:
Bastian,

> * Bastian Bittorf <bittorf@bluebottle.com> [18.07.2012 17:43]:
>> hi devs!
>>
>> yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
>> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
>> hanging wifi and bad performance[5], but the workaround is easy: now it's up to
>> you to fix the rootcause.
>
> [...]
>
> another issues was found, see https://dev.openwrt.org/ticket/7552#comment:69
>
> "...under high load and have found that probably some of the silent freezes
> are due to overflow of the RX DMA buffer, seems like b43 does not
> handlre such a situation at all."
>
> https://dev.openwrt.org/attachment/ticket/7552/840-b43-workaround-rx-fifo-overflow.patch
>
> the patch is working so far, but is only a workaround.
> has somebody a better code-idea?

Changing the maximum number of slots is certainly the correct thing to do. 
Making that change on a netbook that would hang on high throughput cured its 
problem. After some heavy usage, I found the following in the dmesg output:

b43-phy0 debug: DMA-64 rx_ring: Used slots 109/128, Failed frames 0/0 = 0.0%,
                                 ===================

Clearly 64 slots is not sufficient. I am currently testing to see how large it 
can be made as I am not sure that 128 gives enough free space.

Larry

