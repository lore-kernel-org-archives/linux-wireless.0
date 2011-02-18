Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:42364 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1BRVBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:01:21 -0500
Message-ID: <4D5EDE0E.9060004@davizone.at>
Date: Fri, 18 Feb 2011 22:01:02 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary
 for packet injection
References: <4D45A79A.1030102@davizone.at> <4D45B7DC.3060303@davizone.at>	<8762t5dptt.fsf@purkki.adurom.net> <4D473F16.4010102@davizone.at> <87bp2vbcem.fsf@purkki.adurom.net>
In-Reply-To: <87bp2vbcem.fsf@purkki.adurom.net>
Content-Type: multipart/mixed;
 boundary="------------050401010909040305030007"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050401010909040305030007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 2011-02-01 23:47, schrieb Kalle Valo:
> What frames are we talking about exactly? (I can't test this right now.)

They look to me like CTS-to-Self frames. I have attached a sample of them. There
is no other RTS/CTS traffic on the same channel.
I have done further testing for channel switching in monitor mode and there are
some promising results. It looks like the CTS-to-self frames are not sent if
JOIN is used as usual but DISABLE_TX is issued first. Moreover the TX path
remains enabled with this combination.

I thought it would be best to implement it in the following way:
Start with disabled TX path. I found that enabling TX path at least once is
necessary, so it will be ENABLE_TX followed by DISABLE_TX.
It looks to me like managed mode also works after DISABLE_TX, but just to be
sure I will add a ENABLE_TX in wl1251_op_add_interface and a DISABLE_TX in
wl1251_op_remove_interface.

You can find the complete results here: http://wiki.maemo.org/Wl1251/Development

--------------050401010909040305030007
Content-Type: application/cap;
 name="wl1251_join_cts_frames.cap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="wl1251_join_cts_frames.cap"

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAAt0VPTUqeAQAuAAAALgAAAAAAIAAvSAAAJDxJTgAA
AAAQApkJoAD4AQAAAAAAAAAAxABkAAAf3x+15KFZV3O3RU9NBqABAC4AAAAuAAAAAAAgAC9I
AAD9PUlOAAAAABACmQmgAPcBAAAAAAAAAADEAKQ4AB/fH7Xko/V9kg==
--------------050401010909040305030007--
