Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35984 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1HNRcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 13:32:14 -0400
Received: by pzk37 with SMTP id 37so1895522pzk.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 10:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110814191037.043b0839@milhouse>
References: <1313343581-4395-1-git-send-email-zajec5@gmail.com>
	<1313343581-4395-2-git-send-email-zajec5@gmail.com>
	<20110814191037.043b0839@milhouse>
Date: Sun, 14 Aug 2011 19:32:13 +0200
Message-ID: <CACna6rwN43gM=b=gniqbQBwWa3S233hfgKbKVsVYENc_ZOR0rA@mail.gmail.com> (sfid-20110814_193219_311271_A36C39FC)
Subject: Re: [PATCH V2 3.2 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 sierpnia 2011 19:10 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sun, 14 Aug 2011 19:39:41 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> Some hardware with 64-bit DMA uses lower address word for setting
>> routing (translation) bit. Add workaround for such boards.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: use (u64) to fix compilation on 32-bit systems
>
> Note that there are the upper_32_bits() and lower_32_bits()
> macros in kernel.h to address this problem.

I should have guess there is already sth for that.

Worth noting compiler trick in upper_32_bits.
((n) >> 16) >> 16
I didn't think of that :)

-- 
Rafał
