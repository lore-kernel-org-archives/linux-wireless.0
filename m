Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43322 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1HRGqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 02:46:09 -0400
Received: by gwaa12 with SMTP id a12so710199gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 23:46:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313617419.3990.134.camel@shinybook.infradead.org>
References: <4E3420E9.6080603@lwfinger.net>
	<CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com>
	<1313617419.3990.134.camel@shinybook.infradead.org>
Date: Thu, 18 Aug 2011 08:46:08 +0200
Message-ID: <CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com> (sfid-20110818_084613_194083_E1F59C05)
Subject: Re: [PATCH] Add uevent to bcma bus, to autoload drivers.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 sierpnia 2011 23:43 użytkownik David Woodhouse
<dwmw2@infradead.org> napisał:
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> --
> On Wed, 2011-08-17 at 20:27 +0200, Rafał Miłecki wrote:
>> > A minor annoyance is that the driver does not autoload on boot and had to be
>> > manually modprobed. AFAIK, I don't have any blacklisting or other
>> > configuration parameters that would cause this. Furthermore, I don't see
>> > anything in the driver code that would cause this. Does autoload work on
>> > your system?
>>
>> I've everything blacklisted (ssb, bcma, b43, wl, brcmsmac), so I
>> didn't even notice that. However I got some reports (2 of them) that
>> b43 doesn't auto load. I've to take a look at it, however I've no idea
>> yet on what may be causing it.
>
> The lack of uevent causes it. While looking, I note that suspend/resume
> methods are also lacking from bcma.

Tested on my BCM43224, thanks a lot! :)

Acked-by: Rafał Miłecki <zajec5@gmail.com>

You didn't send this directly to John, not sure if he will pick it up.

Do you think this should go for 3.1? With this patch ppl will directly
see interface is present and will just use it or see error about
firmware in dmesg. Without the patch, person just have to know b43 is
supposed to support his card.


Maybe you just could use "bcma: " prefix :)

-- 
Rafał
