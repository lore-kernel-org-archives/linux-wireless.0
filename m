Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55406 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0LIOpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:45:08 -0500
Date: Thu, 9 Dec 2010 09:42:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath: fix build break with ATH_DBG_WARN_ON_ONCE
Message-ID: <20101209144254.GA2339@tuxdriver.com>
References: <4D00DDEA.7040907@hauke-m.de>
 <1291903927-5406-1-git-send-email-linville@tuxdriver.com>
 <1291904272.3540.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1291904272.3540.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 09, 2010 at 03:17:52PM +0100, Johannes Berg wrote:
> On Thu, 2010-12-09 at 09:12 -0500, John W. Linville wrote:
> 
> > diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> > index 3eb95e2..45d4d91 100644
> > --- a/drivers/net/wireless/ath/ath.h
> > +++ b/drivers/net/wireless/ath/ath.h
> > @@ -272,7 +272,7 @@ ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
> >  	return 0;
> >  }
> >  #define ATH_DBG_WARN(foo, arg...) do {} while (0)
> > -#define ATH_DBG_WARN_ON_ONCE(foo) do {} while (0)
> > +#define ATH_DBG_WARN_ON_ONCE(foo) ({ 0; })
> 
> That'll fix the build error, but wouldn't you need (foo) for correctness
> instead?

Well, true -- that was too simple.  Unfortunately (foo) gives warnings
when the return code is not checked.

John

---

>From b7613370db5ba66ad81e41cd3a5417fde4d5e03c Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Thu, 9 Dec 2010 09:08:47 -0500
Subject: [PATCH] ath: fix build break with ATH_DBG_WARN_ON_ONCE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Description by Hauke:

"If CONFIG_ATH_DEBUG=y is set ATH_DBG_WARN_ON_ONCE uses WARN_ON_ONCE and
returns something, but if CONFIG_ATH_DEBUG is not set it does not return
anything. Now ATH_DBG_WARN_ON_ONCE is used in the boolean expression in
an if case and is not returning anything and causes a compile error.

  CC [M]  /drivers/net/wireless/ath/ath9k/main.o
/drivers/net/wireless/ath/ath9k/main.c: In function ‘ath_isr’:
/drivers/net/wireless/ath/ath9k/main.c:769: error: expected expression
before ‘do’
make[5]: *** [/drivers/net/wireless/ath/ath9k/main.o] Error 1
make[4]: *** [/drivers/net/wireless/ath/ath9k] Error 2"

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 3eb95e2..e43210c 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -272,7 +272,10 @@ ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
 	return 0;
 }
 #define ATH_DBG_WARN(foo, arg...) do {} while (0)
-#define ATH_DBG_WARN_ON_ONCE(foo) do {} while (0)
+#define ATH_DBG_WARN_ON_ONCE(foo) ({				\
+	int __ret_warn_once = !!(foo);				\
+	unlikely(__ret_warn_once);				\
+})
 
 #endif /* CONFIG_ATH_DEBUG */
 
-- 
1.7.3.2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
