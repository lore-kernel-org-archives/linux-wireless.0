Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:49155 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab1C2PMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 11:12:10 -0400
Message-ID: <20110329180323.211160fwqua2l4ow@naisho.dyndns.info>
Date: Tue, 29 Mar 2011 18:03:23 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] zd1211rw: use async urb for write command
References: <795206.47027.qm@web161610.mail.bf1.yahoo.com>
In-Reply-To: <795206.47027.qm@web161610.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Walter Goldens <goldenstranger@yahoo.com>:

> Hi Jussi,
>
> After your latest work to enable AP onzd1211rw and generally  
> optimize the code some warnings appear during zd1211rw compilation:
>
>
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_mac.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_mac.c:31:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_al2230.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_al2230.c:25:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_rf2959.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c:25:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_al7230b.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c:25:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_uw2453.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c:26:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_mac.h:27,
>                 from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_rf.c:26:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
> include/asm-generic/termbits.h:94: note: this is the location of the  
> previous definition
>  CC [M]   
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_usb.o
> In file included from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_mac.h:27,
>                 from  
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_usb.c:35:
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:64:  
> warning: "CR0" redefined
> include/asm-generic/termbits.h:91: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:65:  
> warning: "CR1" redefined
> include/asm-generic/termbits.h:92: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:66:  
> warning: "CR2" redefined
> include/asm-generic/termbits.h:93: note: this is the location of the  
> previous definition
> /root/compat-wireless-2011-03-28/drivers/net/wireless/zd1211rw/zd_chip.h:67:  
> warning: "CR3" redefined
>

Hm.. Seems like some other change in 2.6.38-git* has exposed this  
problem (as compiling AP-mode zd1211rw on 2.6.38 doesn't cause these  
warnings).

I'll send patches to rename all zd1211rw CR* to ZD_CR* later.

-Jussi

>
>
> Walter
>
>
>
>
>




