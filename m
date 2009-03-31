Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:56699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbZCaGWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 02:22:17 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2853792rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 23:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8763hqnccb.fsf@litku.valot.fi>
References: <18896.38867.997551.983464@gargle.gargle.HOWL>
	 <8763hqnccb.fsf@litku.valot.fi>
Date: Tue, 31 Mar 2009 11:52:15 +0530
Message-ID: <8e92b4100903302322t531f5badt84fab14eeab943ff@mail.gmail.com> (sfid-20090331_082220_967898_F6EC58D7)
Subject: Re: [PATCH 11/17] ath9k: Remove TIM from the interrupt mask
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Jouni.Malinen@atheros.com,
	Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 11:05 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Sujith <Sujith.Manoharan@atheros.com> writes:
>
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* Some hardware processes the TIM IE and fires an
>> - =A0 =A0 =A0* interrupt when the TIM bit is set. =A0For hardware
>> - =A0 =A0 =A0* that does, if not overridden by configuration,
>> - =A0 =A0 =A0* enable the TIM interrupt when operating as station.
>> - =A0 =A0 =A0*/
>
> This might be useful for beacon filtering. Does the hardware know to
> parse the beacons in more detail, for example ERP protection or WMM
> settings?

After a quick glance into the datasheet, I understand that the current =
version
of hardware supports  reading TIM, TSF  and some more bits related to D=
TIM
from a beacon.

As far as this patch is concerned, since ath9k can use mac80211 for sen=
ding
a null data frame, it is quite redundant to enable the TIM interrupt
as it can be
parsed in mac80211 itself.

Vivek.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
