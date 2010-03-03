Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13180 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0CCFCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 00:02:54 -0500
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
From: Pavel Roskin <proski@gnu.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
In-Reply-To: <20100301231329.64e3dd3b@tom-lei>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
	 <4B89520D.1000209@lwfinger.net>
	 <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
	 <4B89E0D7.9020103@lwfinger.net>  <20100301231329.64e3dd3b@tom-lei>
Content-Type: text/plain
Date: Wed, 03 Mar 2010 00:02:44 -0500
Message-Id: <1267592564.4725.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-01 at 23:13 +0800, Ming Lei wrote:
> -		int valid;
> -		int valid_single_stream;
> +		u8 valid;
> +		u8 valid_single_stream;

You can use bool instead, and that would give the same size saving while
being even more descriptive.  I think using bool could be safer, as the
compiler would be able to detect some misuses and the values.

But I could get even more saving by using bool with the field width:

bool valid:1;
bool valid_single_stream:1;

That would place both variables into one byte.  It may be ineffective
for speed, but it's more effective for storage.

In my configuration, I get following sizes:

original (int):    2792138
your patch (u8):   2790186
bool:              2790186
bool (1 bit):      2789218

-- 
Regards,
Pavel Roskin
