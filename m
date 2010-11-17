Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60366 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0KQPeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 10:34:46 -0500
Received: by yxf34 with SMTP id 34so1135869yxf.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 07:34:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101117150721.GD2639@tuxdriver.com>
References: <201011131908.15595.IvDoorn@gmail.com>
	<201011170946.04629.helmut.schaa@googlemail.com>
	<B7288B2B5878D747BA031EF4B170D7F6BC5C60@TWHCMBS01.tw.ralinktech.ad>
	<201011171148.04286.helmut.schaa@googlemail.com>
	<20101117150721.GD2639@tuxdriver.com>
Date: Wed, 17 Nov 2010 16:34:45 +0100
Message-ID: <AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make
 skb->data two-byte alignment
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: RA-Jay Hung <Jay_Hung@ralinktech.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 4:07 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Nov 17, 2010 at 11:48:04AM +0100, Helmut Schaa wrote:
>
>> John, should I send a follow-up (with a nice description why it this is needed)
>> or are you simply reverting this one?
>
> Is there no chance for a fix in short order?
>

I may have an idea on how we can fix this, without incurring the
performance penalty.
Basic idea is to no longer work on the original skb that mac80211
supplied us, but to
use a copy of that skb. This would prevent us from having to undo any
changes we did,
as we can simply return the original skb to mac80211 (which wasn't
modified in the first
place).
I'm not sure how this would impact performance, but it would allow us
a lot less copying
around to undo the changes done before uploading to the HW.

However, I won't be able to look into that opportunity before the weekend.

Helmut, can you wait that long and hold off reverting until then?

---
Gertjan
