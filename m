Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36100 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1KTQPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 11:15:22 -0500
Received: by ghbz2 with SMTP id z2so2021908ghb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 08:15:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111120154359.GA4069@hash.lan>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
	<1321775788-12520-14-git-send-email-mickflemm@gmail.com>
	<20111120154359.GA4069@hash.lan>
Date: Sun, 20 Nov 2011 18:15:21 +0200
Message-ID: <CAFtRNNw738sve7mrA2+O7rrg0Pf6=E4zaFcgWgQLyf9q2pt8MA@mail.gmail.com> (sfid-20111120_171525_484309_E9FBA8BC)
Subject: Re: [PATCH 13/13] ath5k: Optimize ath5k_cw_validate
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, nbd@openwrt.org,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/20 Bob Copeland <me@bobcopeland.com>:
> On Sun, Nov 20, 2011 at 09:56:28AM +0200, Nick Kossifidis wrote:
>> +     /* Check if cw_req + 1 a power of 2 */
>> +     if (!((cw_req + 1) & cw_req))
>> +             return cw_req;
>> +
>> +     /* Check if cw_req is a power of 2 */
>> +     if (!(cw_req & (cw_req - 1)))
>> +             return cw_req - 1;
>
> There's is_power_of_two() in log2.h .. but this whole thing could also
> be something like roundup_pow_of_two(cw) maybe?
>

Nice catch ! I didn't knew about log2.h, seems interesting :-)

roundup_pow_of_two(n) - 1 should take away that while loop but in most
cases we 'll get a correct cw value so is_power_of_two(cw_req + 1)
would take care of that faster.

I'll post an update



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
