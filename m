Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45395 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0ASVgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 16:36:05 -0500
Received: by pwj9 with SMTP id 9so2690620pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 13:36:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5621DF.60703@openwrt.org>
References: <4B560D44.4080500@openwrt.org> <43e72e891001191306m36984dc4o7f302612a071982c@mail.gmail.com>
	<4B5621DF.60703@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 13:35:44 -0800
Message-ID: <43e72e891001191335v62a0d304ma019d9db15d90b96@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix beacon slot/buffer leak
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 1:19 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-01-19 10:06 PM, Luis R. Rodriguez wrote:
>> On Tue, Jan 19, 2010 at 11:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> When cleaning up beacon buffers and slots, ath9k currently checks if
>>> sc->ah->opmode is set to a beacon related mode before cleaning up
>>> buffers.
>>> An unfortunate ordering of interface up/down commands can lead to
>>> sc->ah->opmode being set to monitor mode, while there are AP interfaces
>>> present on the same wiphy.
>>> Always cleaning up beacon buffers if present fixes this issue.
>>>
>>
>> CC stable?
> Yeah, forgot about that. Should I send it again with Cc?

If John hasn't picked it up yet, sure.

 Luis
