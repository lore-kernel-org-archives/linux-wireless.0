Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:58750 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDHKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 02:10:22 -0500
Received: by mail-yk0-f175.google.com with SMTP id q200so45425062ykb.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 23:10:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21232.24855.201543.400943@gargle.gargle.HOWL>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	<1391483274-20331-2-git-send-email-sujith@msujith.org>
	<1391484878.2538.11.camel@joe-AO722>
	<21232.24855.201543.400943@gargle.gargle.HOWL>
Date: Tue, 4 Feb 2014 08:03:45 +0100
Message-ID: <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com> (sfid-20140204_081038_868616_9398A8DD)
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Fix build error on ARM
From: Holger Schurig <holgerschurig@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Joe Perches <joe@perches.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe, look in linux/arch/arm/include/asm/delay.h. The macro udelay
cannot handle large values because of lost-of-precision.

IMHO udelay on ARM is broken, because it also cannot work with fast
ARM processors (where bogomips >= 3355, which is in sight now). It's
just not broken enought that someone did something against it ...   so
the current kludge is good enought.
