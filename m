Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59375 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036Ab0GOS1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 14:27:48 -0400
Received: by vws5 with SMTP id 5so1485659vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jul 2010 11:27:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimc0k8SmNnyRpa05luw6nKR-qy0rLBe09TBi4qS@mail.gmail.com>
References: <1279152521-10805-1-git-send-email-lrodriguez@atheros.com>
	<003201cb23cd$527f3f90$aa01a8c0@satya> <AANLkTimc0k8SmNnyRpa05luw6nKR-qy0rLBe09TBi4qS@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 15 Jul 2010 11:27:26 -0700
Message-ID: <AANLkTilzdXd1uUHwvY5TIm1kFylk4zRwfPKyujOz0_nZ@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: Fix AR9003 MPDU delimeter CRC check for middle
	subframes
To: Satya <satya.rao@redpinesignals.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tushit Jain <tushit.jain@atheros.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 9:21 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Jul 14, 2010 at 8:24 PM, Satya <satya.rao@redpinesignals.com> wrote:
>>
>> I just wonder if the delimiter length CRC is wrong, where from we
>> get the length of the data packet to get to a state where we say
>> we have received the data packet with correct CRC ?
>>
>> I am not sure about this. I appreciate if someone could clarify this.
>> Thanks.
>
> Great question  :), Kyungwan?

---- Kyungwan wrote:
Actually, the scenario we are addressing here is, delimiter "after" good
crc subframe has crc error such that AR9003 keeps searching next
delimiter but in a meanwhile, restart PHY error occurs and receiving stops.
In this case, by design, AR9003 reports these PHY error and delimiter crc
error by using Rx descriptor of good crc subframe and S/W used to discard
this good crc subframe because of PHY error. But after more investigation,
we found this scenario and we could save this good crc subframe with
the attached patch.

Please note that this happens only if AR9003 advanced feature
(restart PHY error) is enabled.excemption
----

So it seems that by design the delimiter CRC error status is just
borrowed for this exception by our MAC hardware folks to annotate this
specific situation.

  Luis
