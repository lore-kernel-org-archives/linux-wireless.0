Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:48978 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbaJIK2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:28:05 -0400
Message-ID: <54366332.9060906@msgid.tls.msk.ru> (sfid-20141009_122811_937298_9C8C5B4B)
Date: Thu, 09 Oct 2014 14:28:02 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Maximilian Engelhardt <maxi@daemonizer.de>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313 devices
 with Bluetooth
References: <1412843867-26563-1-git-send-email-zajec5@gmail.com>	<CACna6ry-+hzMJ4n5PG7GJq9fZ+zwU38HGt-xZkUqKEP8yX6avA@mail.gmail.com>	<54365985.1020104@broadcom.com> <CACna6ryTwBQQnbZg+CSvoYakb4DA1+FH7j-XwfuYmoDzJORenA@mail.gmail.com> <543661E1.3050606@broadcom.com>
In-Reply-To: <543661E1.3050606@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

09.10.2014 14:22, Arend van Spriel wrote:
> I know where the function should be called according our driver and guess what:
> 
>   if (bfl&  BFL_FEM&&  chip == 4313) {

Can you fix whitespace there too, and add parens around the & operation, while at it?

>       if (!(boardrev>= 0x1250 && bfl&  BFL_FEM_BT))

The same here.

>               ai_epa_4313war(wlc_hw->sih);
> +    else
> +        ai_btcombo_p250_4313_war(wlc_hw->sih);
>   }

I'll try the patch with my 4313 in a few days, hopefully (I'll have to disassemble
my notebook again).

/mjt

