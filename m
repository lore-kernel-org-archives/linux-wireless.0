Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:13999 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbXINSsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 14:48:06 -0400
Received: by ug-out-1314.google.com with SMTP id z38so555770ugc
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 11:48:04 -0700 (PDT)
Message-ID: <46EAD760.9020102@gmail.com>
Date: Fri, 14 Sep 2007 19:48:00 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/05] orinoco: Agere/Lucent firmware download
References: <46E8557F.2080401@gmail.com> <1189746312.26312.39.camel@dv> <46EACAA5.2050706@gmail.com>
In-Reply-To: <46EACAA5.2050706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave wrote:
> Pavel Roskin wrote:
>> On Wed, 2007-09-12 at 22:09 +0100, Dave wrote:
>>> Implements firmware download to RAM for Lucent-Agere firmware.
>>> Firmware download is a requirement to implement WPA on these cards.
>>
>> Please use sparse to check endianess and other issues.  You can use this
>> command once sparse is in PATH:
>>
>> make C=2 CF="-Wall -D__CHECK_ENDIAN__"

Either that was painless, or I did it wrong. Using sparse 3.0 the only warnings were in orinoco.c, related to the use of ARRAY_SIZE. Errors are false positives.

$ make O=../build C=2 CF="-Wall -D__CHECK_ENDIAN__" > ../sparse.log 2>&1

<snip>
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/irda/sir_dongle.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:1391:27: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:2542:35: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:2771:24: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:2773:18: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3118:19: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3123:29: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3357:18: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3393:2: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3421:20: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:3426:13: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:4007:38: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:4278:18: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:4279:17: error: cannot size expression
/usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c:4280:22: error: cannot size expression
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/hermes.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/hermes_dld.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_cs.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_plx.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_pci.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_tmd.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_nortel.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/spectrum_cs.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/zd1201.c
<snip>

Regards,

Dave.

