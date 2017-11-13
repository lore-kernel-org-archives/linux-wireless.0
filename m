Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47722 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdKMJ1W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:27:22 -0500
Message-ID: <1510565240.30497.7.camel@sipsolutions.net> (sfid-20171113_102852_736605_49C670DD)
Subject: Re: [PATCH] IW: Zero or Uninitialized value of keylen passing
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Nitin Jhanwar <nitin.j@samsung.com>,
        AMIT KUMAR JAISWAL <amit.jaiswal@samsung.com>
Date: Mon, 13 Nov 2017 10:27:20 +0100
In-Reply-To: <20171102112839epcms5p42b2f4fa5e261fb5ec26237a17fe08655@epcms5p4>
References: <CGME20171102112839epcms5p42b2f4fa5e261fb5ec26237a17fe08655@epcms5p4>
         <20171102112839epcms5p42b2f4fa5e261fb5ec26237a17fe08655@epcms5p4>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-11-02 at 11:28 +0000, Amit Khatri wrote:
> From b755c8ee282abbd0008e9e7241c457662c90f2c3 Mon Sep 17 00:00:00 2001
> From: Amit Khatri <amit.khatri@samsung.com>
> Date: Thu, 2 Nov 2017 15:55:16 +0530
> Subject: [PATCH] IW: Zero or Uninitialized value of keylen passing
> 
> In case of hexadeciaml keydata, keylen is not gettig updated
> and passing in NLA_PUT(msg, NL80211_KEY_DATA, keylen, keydata)
> as zero (becasue of local variable).
> 
> This patch initilalize keylen variable in case of hexkey data.

Uh. Please re-read the code. I'll selectively quote for you (without
your changes):

>  		case 10:
>  			keydata = hex2bin(keydata, keybuf);
>  		case 5:
>  			NLA_PUT_U32(msg, NL80211_KEY_CIPHER, 0x000FAC01);
>  			keylen = 5;
>  			break;

johannes
