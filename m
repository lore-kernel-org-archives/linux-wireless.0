Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54975 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF0J43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2009 05:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <1246048132.21314.75.camel@johannes.local>
References: <200906261336.29318.elendil@planet.nl>
	 <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
	 <200906261410.58808.elendil@planet.nl>
	 <1246048132.21314.75.camel@johannes.local>
Date: Sat, 27 Jun 2009 11:49:28 +0200
Message-ID: <8db1092f0906270249k58b3bd48yc4c93113641cc5ac@mail.gmail.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Frans Pop <elendil@planet.nl>, linux-wireless@vger.kernel.org,
	Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/26 Johannes Berg <johannes@sipsolutions.net>:

> Hmm, looks like there might be another polarity error, try this:
> -       int query = BIT(b + 8) | ((!!blocked) << b);
> +       int query = BIT(b + 8) | ((!blocked) << b);
>

This helps. hp-wmi works without any problems.

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
