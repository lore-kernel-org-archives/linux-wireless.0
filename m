Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KRT6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:58:12 -0500
Received: by bke11 with SMTP id 11so3848428bke.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 11:58:11 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Re: [PATCH] mac80211: Fix endian bug in radiotap header generation
Date: Fri, 18 Nov 2011 21:56:20 +0100
Message-ID: <1654464.RY7RQ6RAa1@helmutmobil.site> (sfid-20111118_205815_926622_B74E3F75)
In-Reply-To: <1321632520.10266.66.camel@jlt3.sipsolutions.net>
References: <1321626702.10266.59.camel@jlt3.sipsolutions.net> <1321632136-9398-1-git-send-email-helmut.schaa@googlemail.com> <1321632520.10266.66.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 18. November 2011, 17:08:40 schrieb Johannes Berg:
> Heh I would've fixed it by just using put_unaligned(txflags, pos) here,
> but either is fine with me :-)

Hmm, right, but using this approach we even save some cpu_to_le16 calls on
BE archs and maybe some day I'll learn to always build with "make C=1" to
catch endian bugs before sending a patch :)

Thanks,
Helmut
