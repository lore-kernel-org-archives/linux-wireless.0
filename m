Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:8018 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0CFOrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 09:47:13 -0500
Received: by qw-out-2122.google.com with SMTP id 5so742192qwd.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Mar 2010 06:47:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267592564.4725.11.camel@mj>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
	 <4B89520D.1000209@lwfinger.net>
	 <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
	 <4B89E0D7.9020103@lwfinger.net> <20100301231329.64e3dd3b@tom-lei>
	 <1267592564.4725.11.camel@mj>
Date: Sat, 6 Mar 2010 22:47:11 +0800
Message-ID: <d82e647a1003060647y45090d41oe9508d915ab21225@mail.gmail.com>
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
From: Ming Lei <tom.leiming@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/3 Pavel Roskin <proski@gnu.org>:
> On Mon, 2010-03-01 at 23:13 +0800, Ming Lei wrote:
>> -             int valid;
>> -             int valid_single_stream;
>> +             u8 valid;
>> +             u8 valid_single_stream;
>
> You can use bool instead, and that would give the same size saving while
> being even more descriptive.  I think using bool could be safer, as the
> compiler would be able to detect some misuses and the values.
>
> But I could get even more saving by using bool with the field width:
>
> bool valid:1;
> bool valid_single_stream:1;
>
> That would place both variables into one byte.  It may be ineffective
> for speed, but it's more effective for storage.
>
> In my configuration, I get following sizes:
>
> original (int):    2792138
> your patch (u8):   2790186
> bool:              2790186
> bool (1 bit):      2789218

1bit is not enough, at least 3bit is required for each one.

We does not save more using bit field since size of the least type
is 1 byte.

-- 
Lei Ming
