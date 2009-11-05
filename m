Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36609 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbZKECeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 21:34:11 -0500
Received: by yxe17 with SMTP id 17so6938299yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 18:34:16 -0800 (PST)
Message-ID: <4AF239A6.5050406@lwfinger.net>
Date: Wed, 04 Nov 2009 20:34:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <200911041630.20122.chunkeey@googlemail.com> <20091104164938.GG12965@tuxdriver.com> <200911042214.54230.herton@mandriva.com.br>
In-Reply-To: <200911042214.54230.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 06:14 PM, Herton Ronaldo Krzesinski wrote:
> 
> Hi, I checked here and the code above in led_classdev_unregister is the same in
> 2.6.31, so I think the patch from Larry should also be applied/sent to 2.6.31.x
> stable, as the bug could happen there too.

Herton,

Technically you are correct; however, I did extensive testing of
2.6.31 and _NEVER_ got the failure. The sequencing is a bug waiting to
happen, but something in the post 2.6.31 merge actually enabled the
bug to happen. I tried bisection to determine which change actully did
that, but was not successful.

My feeling is that stable can be left alone. Of course, if bug reports
of kernel panics on unload of rtl8187 start occurring, we will know
how to fix it.

Larry
