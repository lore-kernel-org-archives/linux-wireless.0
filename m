Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61746 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1HKQVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 12:21:32 -0400
Received: by pzk37 with SMTP id 37so3913430pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 09:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110811160424.GC2566@tuxdriver.com>
References: <1313001339-11211-1-git-send-email-zajec5@gmail.com>
	<1313001339-11211-2-git-send-email-zajec5@gmail.com>
	<CACna6rynj+OXL1R6jwgnCzReuO+=piOX3LTC9UujDTg4DNBVUw@mail.gmail.com>
	<4E435D0E.80702@lwfinger.net>
	<CACna6rxtkq7QGm52aunVZnqY48uO4+FL18S4kpuvYax55TePZQ@mail.gmail.com>
	<20110811160424.GC2566@tuxdriver.com>
Date: Thu, 11 Aug 2011 18:21:31 +0200
Message-ID: <CACna6rzwyEZU2GiwgOPBPxZ_B+tfOX-4to214EDiOxe8Hmo-iw@mail.gmail.com> (sfid-20110811_182135_283408_C103F52A)
Subject: Re: [RFC][RFT][PATCH V2 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 sierpnia 2011 18:04 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Thu, Aug 11, 2011 at 10:05:19AM +0200, Rafał Miłecki wrote:
>> W dniu 11 sierpnia 2011 06:39 użytkownik Larry Finger
>> <Larry.Finger@lwfinger.net> napisał:
>> > On 08/10/2011 07:14 PM, Rafał Miłecki wrote:
>> >>
>> >> W dniu 10 sierpnia 2011 20:35 użytkownik Rafał Miłecki
>> >> <zajec5@gmail.com>  napisał:
>> >>>
>> >>> Some hardware with 64-bit DMA uses lower address word for setting
>> >>> routing (translation) bit. Add workaround for such boards.
>> >>>
>> >>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> >>> ---
>> >>> This requires testing on at least 1 normal 64-bit DMA card and 1 32-bit
>> >>> DMA card. So far it was tested only on my 14e4:4329 where it fixed DMA.
>> >>
>> >> 14e4:4353 (BCM43224), 64-bit DMA, still works :)
>> >>
>> >> The rest will follow tomorrow.
>> >
>> > Tested with 14e4:4311 (64-bit) and 14e4:4318 (32-bit). The ssb changes were
>> > also tested with b43legacy.
>>
>> Thanks Larry.
>>
>> I've additionally tested this on 14e4:4312 (BCM4311), 32-bit DMA. Works OK.
>>
>> John: please take this patchset.
>
> Are these fixes intended for 3.1?

The bug in DMA support is in the driver since the first moment we
enabled support for N-PHY. It's not any kind of regression. However,
it's still a bug fix.

If it's OK to take that for 3.1, then go on. I believe it received
required testing. On the other hand, if it's going to make Dave or
Linus angry, leave it for 3.2. We have this bug since  2.6.39, we can
have it for one more release.

-- 
Rafał
