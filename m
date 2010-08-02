Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41151 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0HBTyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 15:54:38 -0400
Received: by wyb39 with SMTP id 39so3643025wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 12:54:37 -0700 (PDT)
Message-ID: <4C57227A.1050802@gmail.com>
Date: Mon, 02 Aug 2010 21:54:34 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in v2.6.36
References: <4C55D22A.5040302@hauke-m.de>	 <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>	 <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>	 <4C571F0B.3000200@gmail.com> <1280778534.1752.68.camel@Joe-Laptop.home>
In-Reply-To: <1280778534.1752.68.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


As on 2010-08-02 21:48, Joe Perches did write:
> On Mon, 2010-08-02 at 21:39 +0200, Kshitij Kulshreshtha wrote:
>> As on 2010-08-02 20:00, Luis R. Rodriguez did write:
>>> On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
>>>> +struct va_format {
>>>> +       const char *fmt;
>>>> +       va_list *va;
>>>> +};
>>> I'll apply this for now but what caller uses this for example?
> 
> Why is this necessary?
> 

I needed this to compile compat-wireless which is based on linux-next.
Otherwise net/wireless/core.c fails to compile, due to the use of this
struct va_format in the functions defined in lines 910--958. If this
usage is reverted, we won't need it in compat.

-- 
Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.319
