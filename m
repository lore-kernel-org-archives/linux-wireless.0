Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58079 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823Ab0DHXxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 19:53:38 -0400
Received: by gyg13 with SMTP id 13so1469397gyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 16:53:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004090032.53842.IvDoorn@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
	<1270763437-29526-5-git-send-email-gwingerde@gmail.com> <201004090032.53842.IvDoorn@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 9 Apr 2010 09:53:17 +1000
Message-ID: <j2p646765f41004081653vcb4e0178k374a203da36a9f1@mail.gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Remove rt2800 version constants.
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 9, 2010 at 08:32, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>> The rt2800 version constants are inconsistent, and the version number don't
>> mean a lot of things anyway. Use the literal values in the code instead of
>> some sort of fabricated version name macro.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>
> Perhaps a more elegant way of using and defining needs to be found.
> But at least the defined show what the purpose for the values is
> rather then having magical values spread around the code.

Maybe something like:

#define RTDEV_IS_RT2883_R1(dev) (rt2x00_rt(dev, RT2883) && \
                                                   rt2x00_rev(dev) < 0x0300)

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
