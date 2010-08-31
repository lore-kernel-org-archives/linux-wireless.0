Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62308 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0HaKuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 06:50:08 -0400
Received: by iwn5 with SMTP id 5so5771302iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 03:50:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283237929.3733.2.camel@jlt3.sipsolutions.net>
References: <AANLkTi=R88jHqCkajD4kW=BGStCskBGMLvL1rNErC_71@mail.gmail.com>
	<1283237929.3733.2.camel@jlt3.sipsolutions.net>
Date: Tue, 31 Aug 2010 12:50:08 +0200
Message-ID: <AANLkTik21BWcv2w4d+kvCXAPPpExy1dFnW3M=FJ2q-ZT@mail.gmail.com>
Subject: Re: What extra functionality does a driver need to support for access
 point functionality?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 31, 2010 at 8:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-08-30 at 16:40 -0400, Charles Gordon wrote:
>
>> I'm trying to understand what additional features are needed in
>> drivers to support AP mode.  I took a look at the mac80211
>> documentation on the web site and all it says is that:
>
> [...]
>
>> This makes it seem like the driver doesn't have to do that much more
>> than it does normally.  Somehow, I don't believe that's it can be that
>> easy.  What else does the driver need to do to support something like
>> hostapd?
>
> That really is all it needs to do, assuming it is a mac80211 based
> driver. There are some minor details like not filtering the frames,
> obviously, but those aren't usually a problem. The most common issue is
> not being able to implement multicast-after-DTIM correctly.

The driver also needs to be capable of reliably reporting the tx status of
at least some frames (for example injected frames).

Helmut
