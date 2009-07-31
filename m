Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57148 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZGaSSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:18:07 -0400
Received: by ewy10 with SMTP id 10so1706027ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907311111k10cce08et84510866c68e0297@mail.gmail.com>
References: <20090731180238.GA7963@makis>
	 <43e72e890907311111k10cce08et84510866c68e0297@mail.gmail.com>
Date: Fri, 31 Jul 2009 21:18:05 +0300
Message-ID: <40f31dec0907311118o5460952xd3462b14375eeb72@mail.gmail.com>
Subject: Re: [PATCH 1/4]: Check EEPROM before tweaking SERDES
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
>
> Can the changes for the code be done before the move, or after so that
> way the actual code changes to the section can be easily readable?
>

Since we use EEPROM infos we must move this after eeprom initialization.

>
> This is just comment-picky mind using this style for comments for > 1 lines?
>
> /*
>  * foo bleh buh
>  * bar
>  * qwerty
>  */
>
>  Luis

I use it mostly on large functions (such as attach/reset) to mark sections, we
don't execute a single command here but a bunch of reg writes. I find it easier
to read this way.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
