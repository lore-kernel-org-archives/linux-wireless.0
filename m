Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34743 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2EGKTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:19:51 -0400
Received: by yenm10 with SMTP id m10so3490239yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 03:19:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336382462.4325.4.camel@jlt3.sipsolutions.net>
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	<1336376603.4325.3.camel@jlt3.sipsolutions.net>
	<CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com>
	<1336382462.4325.4.camel@jlt3.sipsolutions.net>
Date: Mon, 7 May 2012 18:19:50 +0800
Message-ID: <CAEFj9855PG1Qv5RBWPJJc5tyKRz5LZZaY8qRU7oAwryH5G8L7A@mail.gmail.com> (sfid-20120507_121954_522098_D24AF554)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

>> >> +             if (da != broadcast_addr)
>
> will never be false.

Hmm, but I have a check on this and it works. The previous line will
set the da either as broadcast addr or unicast addr.

da = (mpath && mpath->is_root) ?
			mpath->rann_snd_addr : broadcast_addr;

Chun-Yeow
