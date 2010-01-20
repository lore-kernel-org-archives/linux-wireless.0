Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:62053 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0ATSQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:16:41 -0500
Received: by pxi12 with SMTP id 12so5825588pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 10:16:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B56EF1A.4050503@ukr.net>
References: <4B56EF1A.4050503@ukr.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 20 Jan 2010 10:08:16 -0800
Message-ID: <43e72e891001201008w29da1feka88b6859d7feb91a@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Account HT Control field in Data frame hdrlen
	according to 802.11n-2009
To: Andriy Tkachuk <andrit@ukr.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 3:55 AM, Andriy Tkachuk <andrit@ukr.net> wrote:
> ieee80211_hdrlen() should account account new HT Control field in 802.11
> data frame header introduced by IEEE 802.11n standard.
>
> According to 802.11n-2009 HT Control field is present in data frames
> when both of following are met:
>
>   1. It is QoS data frame.
>   2. Order bit is set in Frame Control field.
>
> The change might be totally compatible with legacy non-11n aware frames,
> because 802.11-2007 standard states that "all QoS STAs set this subfield
> to 0".
>
> Signed-off-by: Andriy V. Tkachuk <andrit@ukr.net>
> Acked-by : Benoit Papillault <benoit.papillault@free.fr>

Very nice, thanks for the fuller commit log. Hm, the question I also
wanted to address was whether or not this is a stable fix to go for
2.6.32 and 2.6.33, I suppose we'd have to look at all callers of
ieee80211_hdrlen() but this seems like a stable fix to me.

  Luis
