Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:40099 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbZHKQuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 12:50:04 -0400
Message-ID: <20090811195003.12164r4rj49km328@hayate.sektori.org>
Date: Tue, 11 Aug 2009 19:50:03 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"David Brownell" <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 2/2] usbnet: add rx queue pausing
References: <20090811145203.20888.83008.stgit@fate.lan>
	<20090811145208.20888.70513.stgit@fate.lan>
	<1250002657.13529.63.camel@johannes.local>
In-Reply-To: <1250002657.13529.63.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Johannes Berg" <johannes@sipsolutions.net>:

> On Tue, 2009-08-11 at 17:52 +0300, Jussi Kivilinna wrote:
>
>> +	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
>> +		struct sk_buff *skb2;
>> +
>> +		skb2 = skb_clone(skb, GFP_ATOMIC);
>> +		if (unlikely(!skb2))
>> +			return;
>> +
>> +		skb_queue_tail(&dev->rxq_pause, skb2);
>> +		kfree_skb(skb);
>
> Why clone and then free the original?
>

Ah, I had some problems and let this in. No reason, works fine without  
cloning. I'll post v2 soon.

-Jussi

