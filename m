Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43122 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753631AbcLUWem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 17:34:42 -0500
Message-ID: <1482359625.28171.2.camel@tiscali.nl> (sfid-20161221_233505_579033_316FD8A0)
Subject: Re: [PATCH 2/2] net: wireless: fix to uses struct
From: Paul Bolle <pebolle@tiscali.nl>
To: Ozgur Karatas <okaratas@member.fsf.org>,
        johannes <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2016 23:33:45 +0100
In-Reply-To: <608881482358981@web17g.yandex.ru>
References: <608881482358981@web17g.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-22 at 00:23 +0200, Ozgur Karatas wrote:
> I compiled and didn't to errors.

Really?

$ make net/wireless/reg.o
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CHK     include/generated/bounds.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      net/wireless/reg.o
net/wireless/reg.c: In function ‘regulatory_hint_core’:
net/wireless/reg.c:2294:28: error: ‘regulatory_request’ undeclared (first use in this function)
  request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
                            ^~~~~~~~~~~~~~~~~~
net/wireless/reg.c:2294:28: note: each undeclared identifier is reported only once for each function it appears in
net/wireless/reg.c: In function ‘regulatory_hint_user’:
net/wireless/reg.c:2316:28: error: ‘regulatory_request’ undeclared (first use in this function)
  request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
                            ^~~~~~~~~~~~~~~~~~
net/wireless/reg.c: In function ‘regulatory_hint’:
net/wireless/reg.c:2388:28: error: ‘regulatory_request’ undeclared (first use in this function)
  request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
                            ^~~~~~~~~~~~~~~~~~
scripts/Makefile.build:293: recipe for target 'net/wireless/reg.o' failed
make[1]: *** [net/wireless/reg.o] Error 1
Makefile:1640: recipe for target 'net/wireless/reg.o' failed
make: *** [net/wireless/reg.o] Error 2 

Didn't Thomas Gleixner suggest that you do a basic C course just yesterday?


Paul Bolle
