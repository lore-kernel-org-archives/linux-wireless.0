Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46156 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZHIJTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 05:19:52 -0400
Message-ID: <4A7E9596.4070901@gmail.com>
Date: Sun, 09 Aug 2009 11:23:34 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Daniel Mack <daniel@caiaq.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com> <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com>
In-Reply-To: <4A7D8AB6.9030707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> The change came in after -rc5,
>> and I found 57921c31 ("libertas: Read buffer overflow") to be the
>> culprit. Reverting it brings my libertas device back to life. I copied
>> the author.
>>
>> Thanks,
>> Daniel
> 
> Ah, I think I made an error, I think tmp is too small and should be
> 
> u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];

After some sleep I realized it should be:

u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];


> Sorry and thanks for testing,
> 
> Roel
