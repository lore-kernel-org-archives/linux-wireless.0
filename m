Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx33.mail.ru ([94.100.176.47]:63182 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZIPAzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 20:55:17 -0400
Date: Wed, 16 Sep 2009 05:02:13 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <90263558.20090916050213@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re[4]: cfg80211 and rfkill_backport question.
In-reply-To: <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
References: <174470396.20090916030952@mail.ru>
 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
 <792649359.20090916034611@mail.ru>
 <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wednesday, September 16, 2009, 2:49:04 AM, Luis R. Rodriguez wrote:
> Check if the symbols you had issues with were indeed exported via
> EXPORT_SYMBOL() on the compat code (compat/*.c) or if whether they
> were defined via a header as an inline (compat/*.h).
As far as I can see, the symbols in question are not defined as inline:

compat/compat-2.6.26.c:
  EXPORT_SYMBOL_GPL(dev_set_name);
  
compat/compat-2.6.26.h:
  extern int dev_set_name(struct device *dev, const char *name, ...)
                        __attribute__((format(printf, 2, 3)));
net/rfkill/core.c:
  EXPORT_SYMBOL(rfkill_blocked);

include/linux/rfkill-backport.h:
  #if defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_MODULE_BACKPORT)
  .......
  bool rfkill_blocked(struct rfkill *rfkill);
  #else /* !RFKILL */
  .......
  static inline bool rfkill_blocked(struct rfkill *rfkill)
  {
        return false;
  }
  #endif /* RFKILL || RFKILL_MODULE */
  
config.mk:  
  ifdef CONFIG_COMPAT_WIRELESS_31
  CONFIG_RFKILL_BACKPORT=m
  ......

Maybe module loader is supposed to do some magic with symbols, which openwrt 
is missing? However, other modules work just as usual, there are no problems
with lib80211* for instance.

 Nikolai


