Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39121 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZLDHxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 02:53:48 -0500
Received: by bwz27 with SMTP id 27so1742190bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 23:53:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B182F5B.2010806@free.fr>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
	 <4B163956.1060709@free.fr>
	 <14add3d10912030132r251779efq10dc08768aefd8c1@mail.gmail.com>
	 <200912031936.12557.IvDoorn@gmail.com> <4B182F5B.2010806@free.fr>
Date: Fri, 4 Dec 2009 08:53:53 +0100
Message-ID: <a32f33a40912032353k4ae64e77u83693e41668b4a25@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2009 at 10:36 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Ivo van Doorn a écrit :
>>>> * L2PAD is only present for data frame and an easy way to check for that is
>>>> * to compare header_length with 24 bytes.
>>>> */
>>>> #define L2PAD_SIZE(__header) \
>>>>      ((__header)<24 ? 0 : ((4 - ((__header)%4))%4))
>>>>
>>> That depends on what the purpose of the L2PAD_SIZE macro is going to
>>> be. At the moment
>>> the intention is to have L2PAD_SIZE compute the number of l2pad bytes
>>> necessary, if a
>>> payload is present. Detection on whether actually a payload is present
>>> and whether the
>>> outcome of this macro should be used should be at the call-sites of this macro.
>>
>> I personally prefer the current version, I don't see a valid reason for
>> L2PAD_SIZE to depend on the header size. The caller should check if
>> the payload is present and L2 padding is required.
>>
>> Ivo
>
> Let's move forward and fix bugs later, if any. Just for my curiosity,
> who is commiting posted patches in wireless-testing?

John Linville maintains wireless-testing, he is picking up the patches from
the linux-wireless mailinglist and merges them into his tree (and pushes them
upstream).

Ivo
