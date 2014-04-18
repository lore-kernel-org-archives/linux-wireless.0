Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44144 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRHtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 03:49:12 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so1221305pdj.3
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 00:49:11 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH 1/6] p54: replace wiphy_debug() with wiphy_dbg()
In-Reply-To: <1397754900.3104.5.camel@joe-AO725> (Joe Perches's message of
	"Thu, 17 Apr 2014 10:15:00 -0700")
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
	<1397754900.3104.5.camel@joe-AO725>
Date: Fri, 18 Apr 2014 15:48:57 +0800
Message-ID: <87ppkf5b86.fsf@gmail.com> (sfid-20140418_094916_122179_A48951D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-17 at 10:15:00 -0700, Joe Perches wrote:
> On Thu, 2014-04-17 at 21:27 +0800, Zhao, Gang wrote:
>> Dynamic debug function wiphy_dbg() is more convenient for debugging,
>> and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
>> normal static debug, just as what wiphy_debug() does.
>
> Hi.
>
> Your premise is not correct.
>
> wiphy_debug will always emit a message.
>
> wiphy_dbg will only emit a message when #DEBUG
> is #defined or CONFIG_DYNAMIC_DEBUG is enabled
> and the message is specifically enabled by the
> dynamic_debug control file.
>
Yes, you are right. wiphy_debug() will always print a debug level
message. It's not true to wiphy_dbg().

I still prefer to use wiphy_dbg() to print debug messages, since it's
"dynamic", and debug messages may not be needed in normal use. 

>> When all the users of wiphy_debug() are gone, wiphy_debug() can be
>> removed.
>
> Not really.
>
Surely wiphy_debug() will be reserved, since wiphy_dbg() can't replace
it.

> Please use git format-patch --cover-letter when
> sending a patch series so that these sorts of
> replies can be done to the cover letter of the
> series instead of individually.
>
> Using a cover-letter "[PATCH 0/N]" also makes it
> easier for maintainers to send acknowledgements
> if applying the entire series.

I will resend the patch set with cover letter(excluding the last
patch). Thanks for your comments.
