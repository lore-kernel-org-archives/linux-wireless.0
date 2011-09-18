Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36475 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1IRLSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 07:18:18 -0400
Received: by fxe4 with SMTP id 4so3037571fxe.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 04:18:17 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ath9k: use ACCESS_ONCE_RW for write assignments
Date: Sun, 18 Sep 2011 13:18:12 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <201109180457.37146.chunkeey@googlemail.com> <4E75B442.8050806@openwrt.org>
In-Reply-To: <4E75B442.8050806@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109181318.13286.chunkeey@googlemail.com> (sfid-20110918_131827_476051_32171B48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 September 2011 11:05:06 Felix Fietkau wrote:
> On 2011-09-18 4:57 AM, Christian Lamparter wrote:
> > This patch fixes a compiler error which was introduced by
> > "ath9k_hw: add a new API for setting tx descriptors" [2b63a4].
> >
> > ar9002_mac.c:185:2: error: assignment of read-only location
> > ...
> > ar9003_mac.c:37:2: error: assignment of read-only location
> > ...
> >
> > Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> When and where was ACCESS_ONCE_RW added? It's not in wireless-testing 
> and I can only find references to it on the web in grsecurity patches.
Sorry! You are right. ACCESS_ONCE_RW is part of grsecurity, looks
like I have to bother Brad with this one.

Regards,
	Chr
