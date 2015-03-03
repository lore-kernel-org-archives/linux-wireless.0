Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54803 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbbCCJhA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:37:00 -0500
Message-ID: <1425375418.2450.27.camel@sipsolutions.net> (sfid-20150303_103705_801558_6A0CD887)
Subject: Re: [PATCH] mac80211: disable u-APSD queues by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Mar 2015 10:36:58 +0100
In-Reply-To: <CABPxzY+hcmAHCzn+JvYRurDYO3yZ=_bRkDFODrbRMJ0L75yZ9A@mail.gmail.com> (sfid-20150303_103352_166684_105D9687)
References: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com>
	 <1425374168.2450.17.camel@sipsolutions.net>
	 <CABPxzY+hcmAHCzn+JvYRurDYO3yZ=_bRkDFODrbRMJ0L75yZ9A@mail.gmail.com>
	 (sfid-20150303_103352_166684_105D9687)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >> Cisco 4410N originally forced us to enable VO by
> >> default only because it treated non-VO ACs as
> >> legacy.

> Mixed mode (uapsd + legacy) is not really the optimal
> configuration, where we expect STA to send trigger frames periodically
> to retrieve the DL packets (especially very first packet).
> 
> But still if we want power save, i suggest going for
> All u-apsd (0xF), so that AP will inform us by setting the TIM bit
> and we can retrieve the first frame.
> (We have this patch internally and it works well).

Except where it doesn't work, like on the Cisco 4410N - see above.

johannes

