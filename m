Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:15647 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYHFWFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 18:05:54 -0400
Received: by rv-out-0506.google.com with SMTP id k40so133461rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 15:05:54 -0700 (PDT)
Message-ID: <1ba2fa240808061505u37d4f300n48d0d45918b34a35@mail.gmail.com> (sfid-20080807_000601_987230_310CF7C9)
Date: Thu, 7 Aug 2008 01:05:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1218059104.23048.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
	 <1218059104.23048.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 7, 2008 at 12:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> When that is not the case, however, we disagree. I think that because
>> aggregation isn't a QoS mechanism, it should behave the same way as in
>> the case where no stations have aggregation enabled, and stall the whole
>> queue. On the other hand, you think it is a QoS mechanism, and let
>> streams for the fast stations be interleaved with the slow station,
>> leaving only frames for the slow station piling up.
>
> I just found IEEE 802.11-2007 subclause 9.10 which actually explains all
> the block-ack business without aggregation, but I assume that
> aggregation now just means that instead of sending
>        mpdu + sifs + (mpdu + sifs)* + blockackreq
> you send simply
>        a-mpdu
>
> I see nothing in 9.10 that supports the view that aggregation/block-ack
> should create a new traffic stream.

It doesn't have to be spelled, it's clear from the fact that traffic
is defined by <TID,RA>  pair.
A-MPDU stuff is simplified version of what you've read there.
Tomas
