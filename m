Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50956 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2HHR4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:56:45 -0400
Received: by qadb17 with SMTP id b17so2712745qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:56:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50229A06.9090106@net.t-labs.tu-berlin.de>
References: <1344195337-27461-1-git-send-email-mickflemm@gmail.com>
	<1344195337-27461-6-git-send-email-mickflemm@gmail.com>
	<50229A06.9090106@net.t-labs.tu-berlin.de>
Date: Wed, 8 Aug 2012 20:56:44 +0300
Message-ID: <CAFtRNNz+G-keFp5c1=Ps_4acQj7uv=ByTpPAAFX3JKTsT1dioQ@mail.gmail.com> (sfid-20120808_195650_364245_AF8B36C1)
Subject: Re: [ath5k-devel] [PATCH v2 5/5] ath5k: Return correct offset when
 reading frequencies
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Felix Fietkau <nbd@openwrt.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/8 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick, hi Felix,
>
> This patch does break the operation of all DCMA82 (AR5413), as this
> chips have only 8 valid piers, but with the "continue" all 10 got read.
> So the former version was correct as it break after 8 piers.
> The patch was initiated by my observation and after revisiting what I
> did, blame Thomas is correct here... The power variation is properly
> working and I miss measured based on an uncleaned patch mess in my env.
>
> Please revert this patch to get proper pier readings back in ath5k.
>
>
> Greetings Thomas
>

ACK so documentation is once again misleading because it says that we
always have 10 frequencies to read and if some are zero we just ignore
the matching data. It doesn't say that if we get a zeroed frequency
the rest are missing from the EEPROM and we should move on to the next
section. I'll keep that in mind ;-)

John please ignore this one and sorry for the mess !


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
