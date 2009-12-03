Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43432 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZLCVg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 16:36:29 -0500
Message-ID: <4B182F5B.2010806@free.fr>
Date: Thu, 03 Dec 2009 22:36:27 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>	<4B163956.1060709@free.fr>	<14add3d10912030132r251779efq10dc08768aefd8c1@mail.gmail.com> <200912031936.12557.IvDoorn@gmail.com>
In-Reply-To: <200912031936.12557.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn a écrit :
>>> * L2PAD is only present for data frame and an easy way to check for that is
>>> * to compare header_length with 24 bytes.
>>> */
>>> #define L2PAD_SIZE(__header) \
>>>      ((__header)<24 ? 0 : ((4 - ((__header)%4))%4))
>>>
>> That depends on what the purpose of the L2PAD_SIZE macro is going to
>> be. At the moment
>> the intention is to have L2PAD_SIZE compute the number of l2pad bytes
>> necessary, if a
>> payload is present. Detection on whether actually a payload is present
>> and whether the
>> outcome of this macro should be used should be at the call-sites of this macro.
> 
> I personally prefer the current version, I don't see a valid reason for
> L2PAD_SIZE to depend on the header size. The caller should check if
> the payload is present and L2 padding is required.
> 
> Ivo

Let's move forward and fix bugs later, if any. Just for my curiosity,
who is commiting posted patches in wireless-testing?

Regards,
Benoit
