Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:44287 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZDQHBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 03:01:47 -0400
Received: by fk-out-0910.google.com with SMTP id 18so335964fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 00:01:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E7F3E6.2010809@gmail.com>
References: <200904012118.12391.IvDoorn@gmail.com>
	 <20090417001807.GA5020@hera.kernel.org> <49E7F3E6.2010809@gmail.com>
Date: Fri, 17 Apr 2009 08:56:23 +0200
Message-ID: <a32f33a40904162356r5dddeed8u60f63e5c0acfc506@mail.gmail.com> (sfid-20090417_090151_327089_A30E7C7F)
Subject: Re: [stable] [PATCH] rt2x00: Fix SLAB corruption during rmmod
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: stable@kernel.org, Arnaud Patard <apatard@mandriva.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On 04/17/09 02:18, Chris Wright wrote:
>> * Ivo van Doorn (ivdoorn@gmail.com) wrote:
>>> At rmmod stage, the code path is the following one :
>>>
>>> rt2x00lib_remove_dev
>>> =A0 -> =A0rt2x00lib_uninitialize()
>>> =A0 =A0 =A0 =A0 -> rt2x00rfkill_unregister()
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_unregister()
>>> =A0 =A0 =A0 =A0 -> rt2x00rfkill_free()
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_free()
>>>
>>> The problem is that rfkill_free should not be called after rfkill_r=
egister
>>> otherwise put_device(&rfkill->dev) will be called 2 times. This pat=
ch
>>> fixes this by only calling rt2x00rfkill_free() when rt2x00rfkill_re=
gister()
>>> hasn't been called or has failed.
>>>
>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>> Tested-by: Arnaud Patard <apatard@mandriva.com>
>>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>>
>> Who is the Author of this patch? =A0The Signed-off-by order suggests=
 is
>> Gertjan.
>>
>
>
> Indeed, I have been the author of the patch.

Yeah, Gertjan is indeed the author, I forgot to add
the Fom: line at the top of the patch to make that more clear.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
