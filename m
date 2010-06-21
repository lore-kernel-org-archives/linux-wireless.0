Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36375 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0FUTSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:18:40 -0400
Received: by fxm10 with SMTP id 10so2031822fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 12:18:38 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: allow selection of minstrel_ht as default rc algo
Date: Mon, 21 Jun 2010 21:18:06 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
References: <201006211059.58879.helmut.schaa@googlemail.com> <AANLkTinj36oA6QpEiYywGGkRqCmNRHSeR643HpiUsXC-@mail.gmail.com>
In-Reply-To: <AANLkTinj36oA6QpEiYywGGkRqCmNRHSeR643HpiUsXC-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006212118.06767.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 21 Juni 2010 schrieb Luis R. Rodriguez:
> On Mon, Jun 21, 2010 at 1:59 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Allow selection of minstrel_ht as default rate control algorithm. At the
> > moment minstrel_ht can only be requested by the driver code but not selected
> > as default in make menuconfig.
> >
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> Shouldn't this just be enabled when you enable minstrel? I don't get
> why we would split up the two.

Would be fine for me as well. But I'm not sure if we want minstrel_ht already
as default and we want definitely keep the possibility to only select minstrel
(if compiling on an embedded system with just bg wifi for example).

Felix, any objections against selecting minstrel_ht as default if minstrel
was selected as default rc algo and minstrel_ht is compiled in?

In case of an embedded system without minstrel_ht minstrel would stay as default.

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 83eec7a..4d6f865 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,6 +69,7 @@ endchoice
 
 config MAC80211_RC_DEFAULT
 	string
+	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
 	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
 	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""

Thanks,
Helmut
