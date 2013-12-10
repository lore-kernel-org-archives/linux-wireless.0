Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.abv.bg ([194.153.145.99]:47195 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3LJWXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 17:23:54 -0500
Date: Wed, 11 Dec 2013 00:16:58 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?=
	<freemangordon@abv.bg>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: kvalo@adurom.com, pavel@ucw.cz, luca@coelho.fi, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aaro.koskinen@iki.fi, sre@ring0.de,
        joni.lapilainen@gmail.com, johannes@sipsolutions.net,
        felipe.contreras@gmail.com, david.gnedt@davizone.at
Message-ID: <1209321878.38095.1386713818964.JavaMail.apache@mail82.abv.bg>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  >-------- Оригинално писмо --------
 >От:  Pali Rohár 
 >Относно: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
 >До: Kalle Valo ,
 Pavel Machek 
 >Изпратено на: Вторник, 2013, Декември 10 19:08:44 EET
 >
 >
 >On Tuesday 10 December 2013 16:41:04 Kalle Valo wrote:
 >> Pavel Machek  writes:
 >> > ssids can have &#92;0s in them... and what is worse, they may
 >> > not be 0 terminated AFAICT.
 >> > 
 >> > Potential solution is at
 >> > http://www.spinics.net/lists/linux-wireless/msg98640.html .
 >> 
 >> I just use print_hex_dump_bytes() to print SSIDs.
 >
 >Ok and has kernel printf modifier for size_t?
 >
 >-- 
 >Pali Rohár
 >pali.rohar@gmail.com
 >

If I read lib/vsprintf.c correctly, you can use 'z'

Regards,
Ivo

PS: Please use my gmail address when cc-ing me, LKML really hates my abv dot bg account :)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>From linux-wireless-owner@vger.kernel.org Wed Dec 11 03:45:13 2013
Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	jmaline2.user.openhosting.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
	RCVD_IN_DNSWL_HI,T_RP_MATCHES_RCVD,T_TO_NO_BRKTS_FREEMAIL autolearn=ham
	version=3.3.1
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by jmaline2.user.openhosting.com (8.13.8/8.13.8) with ESMTP id rBB1jDSS010436
	for <j@w1.fi>; Tue, 10 Dec 2013 20:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab3LKBpL (ORCPT <rfc822;j@w1.fi>);
	Tue, 10 Dec 2013 20:45:11 -0500
Received: from plane.gmane.org ([80.91.229.3]:36778 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab3LKBpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 20:45:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VqYrH-0003XA-4x
	for linux-wireless@vger.kernel.org; Wed, 11 Dec 2013 02:45:03 +0100
Received: from ool-182c1fa2.dyn.optonline.net ([24.44.31.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 02:45:03 +0100
Received: from kampowchicken by ool-182c1fa2.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 02:45:03 +0100
X-Injected-Via-Gmane: http://gmane.org/
To: linux-wireless@vger.kernel.org
From: Kam <kampowchicken@gmail.com>
Subject: rtl8723ae owner.
Date: 	Wed, 11 Dec 2013 01:42:07 +0000 (UTC)
Message-ID: <loom.20131211T021101-974@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.44.31.162 (Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Firefox/25.0)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: 	linux-wireless@vger.kernel.org
Content-Length: 1232
Lines: 25

I have the rtl8723ae PCIe wifi card. I've read through the messages on the
forums and experience similar issues to others who have inquired about the
card. I experience sluggish connections and disconnects, I for the most
can't connect to my school wifi at all.  

I switched my router to 'AP' today after reading through the posts here and
initially the connection was faster than I've experienced thus far(since
switching to linux last year), I ended up shutting down the computer
eventually and after turning it back on few hours later, It was back to the
slow sluggish connection. 

I've collected all the output that I could think of and wanted to contribute
it in hopes that it can assist the devs in testing/debugging the issues with
the card. The text file is a little but over 800 lines, so I will post it on
fpaste, if this isn't acceptable please let me know and I will repost the
text in preferred format. I am about ready to smoke the beacons off this
thing :P.

http://www.fpaste.org/60680/38672606/

Thank you!

Kam



