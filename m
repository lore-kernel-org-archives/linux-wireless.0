Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34577 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab0ASVTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 16:19:33 -0500
Message-ID: <4B5621DF.60703@openwrt.org>
Date: Tue, 19 Jan 2010 22:19:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix beacon slot/buffer leak
References: <4B560D44.4080500@openwrt.org> <43e72e891001191306m36984dc4o7f302612a071982c@mail.gmail.com>
In-Reply-To: <43e72e891001191306m36984dc4o7f302612a071982c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-19 10:06 PM, Luis R. Rodriguez wrote:
> On Tue, Jan 19, 2010 at 11:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> When cleaning up beacon buffers and slots, ath9k currently checks if
>> sc->ah->opmode is set to a beacon related mode before cleaning up
>> buffers.
>> An unfortunate ordering of interface up/down commands can lead to
>> sc->ah->opmode being set to monitor mode, while there are AP interfaces
>> present on the same wiphy.
>> Always cleaning up beacon buffers if present fixes this issue.
>>
> 
> CC stable?
Yeah, forgot about that. Should I send it again with Cc?

- Felix
