Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39409 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0BDKHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 05:07:35 -0500
Received: by ewy28 with SMTP id 28so2633683ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 02:07:34 -0800 (PST)
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix PAE frame handling
References: <4B65F735.1020509@openwrt.org>
	<19302.24837.154697.822430@gargle.gargle.HOWL>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 04 Feb 2010 12:07:31 +0200
In-Reply-To: <19302.24837.154697.822430@gargle.gargle.HOWL> (Sujith's message of "Mon\, 1 Feb 2010 10\:35\:09 +0530")
Message-ID: <87d40ljov0.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

>> ath9k's tx handling code contains a special case for PAE frames, which
>> looks like it was intended to be improving reliability by excluding
>> them from aggregates.
>> What it actually did is the opposite: By assigning a faulty sequence
>> number, yet still keeping it as a qos-frame, it caused bogus packet
>> reordering, which broke WPA rekeying.
>> The special case handling is completely unnecessary, so this patch
>> removes it.
>
> Sending PAE frames as part of an aggregate broke crypto with several APs.

Any more information about the problem? For example, what APs are
broken?

I'm just wondering if we should see this with other hardware also.

-- 
Kalle Valo
