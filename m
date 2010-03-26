Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:38494 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0CZSOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 14:14:52 -0400
Received: by pzk32 with SMTP id 32so2856065pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 11:14:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <445f43ac1003241816p2d00b79br224a155b605ce7ac@mail.gmail.com>
References: <20100324120645.5b43757c.nledovskih@mail.ru>
	 <445f43ac1003241816p2d00b79br224a155b605ce7ac@mail.gmail.com>
Date: Fri, 26 Mar 2010 11:14:52 -0700
Message-ID: <445f43ac1003261114h55918152rd76be84c97716c99@mail.gmail.com>
Subject: Re: Mesh mode broken since 2.6.34-rc1
From: Javier Cardona <javier@cozybit.com>
To: =?KOI8-R?B?7MXEz9fTy8nIIO7Jy8/Mwcog98HMxdLYxdfJ3g==?=
	<nledovskih@mail.ru>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org,
	"Porsch, Marco" <marco.porsch@siemens.com>,
	"steve.derosier" <steve.derosier@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

The commit that broke the mesh seems to be:

commit 8404080568613d93ad7cf0a16dfb68459b42a264
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Mon Feb 15 12:46:39 2010 +0200

    mac80211: reject unhandled action frames

    802.11-2007 7.3.1.11 mandates that we need to
    reject action frames we don't handle by setting
    the 0x80 bit in the category and returning them
    to the sender, so do that. In AP mode, hostapd
    is responsible for this.

    Additionally, drop completely malformed action
    frames or ones that should've been encrypted as
    unusable, userspace shouldn't see those.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

After that commit we observe invalid action category codes (0x9e) in
response to valid peer link open action frames (0x1e) and so no peer
links are established.  We don't have a fix at this time.

Cheers,

Javier


2010/3/24 Javier Cardona <javier@cozybit.com>:
> Nick,
>
> 2010/3/24 Ледовских Николай Валерьевич <nledovskih@mail.ru>:
>> Mesh mode does not work any more. I have some x86 MPs with 2.6.33.1, which work fine.
>> But there are establishment problems with 2.6.34-rc1.
>> The peering status changes between LISTEN, OPN_SNT and HOLDING, but does not reach ESTAB.
>
> Yes, confirmed on our testbed that wireless-testing commit
> 60b341b778cc2929df16c0a504c91621b3c6a4ad is good.  We'll investigate.
>
> Thanks,
>
> Javier
>
>
> --
> Javier Cardona
> cozybit Inc.
> http://www.cozybit.com
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
