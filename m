Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:63917 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZIHQKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 12:10:16 -0400
Received: by iwn39 with SMTP id 39so36940iwn.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 09:10:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4aa3f838.ef04Hi2n3Fg54rE9%Larry.Finger@lwfinger.net>
References: <4aa3f838.ef04Hi2n3Fg54rE9%Larry.Finger@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 09:09:53 -0700
Message-ID: <43e72e890909080909n557e9d97o8582d60c78ed381a@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix build error on i386 for net/wireless/scan.o
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 6, 2009 at 10:58 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> With i386 architecture, building the kernel v2.6.31-rc8-34797-g4910edb
> fails with the following error:
>
>  CC [M]  net/wireless/scan.o
> net/wireless/scan.c: In function ‘cfg80211_inform_bss’:
> net/wireless/scan.c:499: error: implicit declaration of function ‘kmemleak_ignore’
> make[2]: *** [net/wireless/scan.o] Error 1
>
> On x86_64, the build succeeds. Fix by including the appropriate header.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

I've asked John to revert the use of kmemleak_ignore() here for
several reasons so this patch will not be needed.

  Luis
