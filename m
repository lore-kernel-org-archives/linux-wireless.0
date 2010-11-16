Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57598 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab0KPTdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:41 -0500
Received: by qwh6 with SMTP id 6so873780qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 11:33:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289935603.3673.3.camel@jlt3.sipsolutions.net>
References: <201011131911.47346.IvDoorn@gmail.com>
	<201011161742.08503.helmut.schaa@googlemail.com>
	<20101116165302.GA29570@sig21.net>
	<201011161800.40654.helmut.schaa@googlemail.com>
	<AANLkTi=ANfE3s8RUmS5=qyofqHM2geRnatK-eCUjovEc@mail.gmail.com>
	<20101116190654.GA3659@sig21.net>
	<AANLkTi=qM417Cu2m_pb7unQs3wpcUcrTPftiKfAFvF=8@mail.gmail.com>
	<1289935603.3673.3.camel@jlt3.sipsolutions.net>
Date: Tue, 16 Nov 2010 20:33:39 +0100
Message-ID: <AANLkTimieQ+ZotFvaMLgX_9G+tWsz7wuhiL+m4WbV77o@mail.gmail.com>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Johannes Stezenbach <js@sig21.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	jay_hung@ralinktech.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com,
	Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 8:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-16 at 20:23 +0100, Ivo Van Doorn wrote:
>
>> However what I meant, is when skb->priority is 0, must the highest or the lowest
>> priority be assumed? If it is the highest priority, then rt2x00 uses
>> the incorrect
>> naming, and all what is needed is to rename the fields everywhere in rt2x00.
>> However is it is the lowest priority, then the naming is correct, and we must
>> change the meaning, in which case we must rename and meaning.
>
> I'm working on this:
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/012-mac80211-ac-defines.patch
>
> 0 is highest prio (AC_VO)

Excellent. :)
So that makes the bug in rt2x00 fortunately a naming-only thing.
We don't need to map from mac80211 to rt2x00 values, but we simply need to
search & replace the enumeration names to match the meaning.

Ivo
