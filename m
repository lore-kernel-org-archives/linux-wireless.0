Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46118 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZHUDyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 23:54:07 -0400
Received: by ewy3 with SMTP id 3so373487ewy.18
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 20:54:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8DF356.8000501@lwfinger.net>
References: <200908202116.17847.herton@mandriva.com.br>
	 <4A8DF356.8000501@lwfinger.net>
Date: Fri, 21 Aug 2009 04:54:06 +0100
Message-ID: <3ace41890908202054j62fda37ei64262890c6959f95@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 2:07 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Herton Ronaldo Krzesinski wrote:
>> RTL8187B always needs MSR_LINK_ENEDCA flag to be set even when it is in
>> no link mode, otherwise it'll not be able to associate when this flag is
>> not set after the change "mac80211: fix managed mode BSSID handling"
>> (commit 9cef8737).
>>
>> By accident, setting BSSID of AP before association makes 8187B to
>> successfuly associate even when ENEDCA flag isn't set, which was the
>> case before the mac80211 change. But now the BSSID of AP we are trying
>> to associate is only available after association is successful, and
>> any attempt to associate without the needed flag doesn't work.
>>
>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>> ---
>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

>
> I had just finished bisecting the problem reported in Bug #13960 when
> this patch from Herton appeared in my mailbox, and it fixed the problem.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This seems to be related to a problem I reported a while back - see
the "compat-wireless won't associate on 2nd load" thread, I wrote on
May 31. Supposedly I had that problem about a week before that, the
date on the patch from Johannes is May 14, but I just went back to
look at the mailing list archive and it looks like there were some
problem with applying and John did some fix on 20th. So it seems that
it might be the source of my not being able to load compat-wireless a
2nd time; and the description of the problem sounds like it too.

Sorry I haven't been doing much with compat-wireless lately, so I have
no firm data whether I have the same problem or not since May - that
problem only happens if I switch from one compat-wireless to another
compat-wireless, without rebooting - while I have tried
compat-wireless in the last two months, I don't think I have followed
compat-wireless as closely as I should to have two successive
compat-wireless. I probably should go and have a try now.

Thanks for hunting this down!

Hin-Tak
