Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:26968 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761072AbZJPPms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:42:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: andrey@cozybit.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: BUG: endianness issues with libertas if_spi.c
Date: Fri, 16 Oct 2009 17:41:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910161741.19731.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey, can you fix this?  I don't have SPI hardware and wouldn't
be able to check the functionality after the fixes. However, some
things are obvious, e.g.


u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);

should either be

  reg_out = reg | IF_SPI_WRITE_OPERATION_MASK;

or

  __le16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);


Here's a run with sparse:

$ make -C /usr/src/linux-wl/ modules SUBDIRS=drivers/net/wireless/libertas C=2 CF=-D__CHECK_ENDIAN__    
drivers/net/wireless/libertas/if_spi.c:137:16: warning: incorrect type in initializer (different base types)
drivers/net/wireless/libertas/if_spi.c:137:16:    expected unsigned short [unsigned] [usertype] reg_out
drivers/net/wireless/libertas/if_spi.c:137:16:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:191:16: warning: incorrect type in initializer (different base types)
drivers/net/wireless/libertas/if_spi.c:191:16:    expected unsigned short [unsigned] [usertype] reg_out
drivers/net/wireless/libertas/if_spi.c:191:16:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:256:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:256:24:    expected restricted __le32 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:256:24:    got unsigned int *<noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
-- 
http://www.holgerschurig.de
