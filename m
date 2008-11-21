Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:36150 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKUSzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 13:55:13 -0500
Received: by rn-out-0910.google.com with SMTP id k40so930092rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 10:55:12 -0800 (PST)
Message-ID: <43e72e890811211055x19882fa1l5ced86b6a031a203@mail.gmail.com> (sfid-20081121_195525_109247_7A6F2BE2)
Date: Fri, 21 Nov 2008 10:55:12 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: What should wireless drivers do under -ENOMEM
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under heavy stress you can sometimes run into -ENOMEM and you inform
the callers. Now ath5k/ath9k both require dev_alloc_skb()'ing some
buffers when RXing. Right now we simply move on, but I think it'd be
nicer to inform mac80211 and let mac80211 decide. If the system is
under complete load I don't expect my drivers to bail out but to
somehow gracefully wait a while and then try again. But after a while
data starts to become pretty useless if you keep running into -ENOMEM.
What should we do then? Thoughts?

  Luis
