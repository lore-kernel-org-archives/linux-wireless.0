Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108]:41090 "EHLO
	smtp1.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYDURM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:12:59 -0400
Message-ID: <20080421200409.vvow4d67okcw84kg@hayate.ip6> (sfid-20080421_191349_962923_52075D46)
Date: Mon, 21 Apr 2008 20:04:09 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Subject: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just checked how rndis_wlan was included in  
compat-wireless-2008-04-01 and noticed small problem. Patchset that  
was required for rndis_wlan to work modified 'struct usbnet' in  
usbnet.h, added 'void *driver_priv' at almost head:
  http://marc.info/?l=linux-wireless&m=120130189428293&w=2

Compat-wireless includes new modified usbnet.h but doesn't include not  
usbnet.c and cdc_ether.c on which rndis_host/rndis_wlan depend on to.  
Also cdc_ether.c had another update:
  http://marc.info/?l=linux-wireless&m=120130189928350&w=2

So to have rndis_wlan working, you should include cdc_ether.c and  
usbnet.c. But this would broke all the rest drivers in  
'drivers/net/usb' that depend on usbnet.c. To fix this is ofcourse to  
move 'void *driver_info' at end of 'struct usbnet'.

Ok, I haven't tested this myself, but this is how it seems to me. If  
you add usbnet.c you might want to add this patch too and change flag  
in rndis_wlan for 'wlanX' device names:
  http://marc.info/?l=linux-wireless&m=120130189728322&w=2

Also rndis_host should include this patch:
  http://marc.info/?l=linux-netdev&m=120626915222918&w=2

  - Jussi Kivilinna



