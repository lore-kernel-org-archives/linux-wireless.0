Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:48564 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3DIJrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:47:10 -0400
Date: Tue, 9 Apr 2013 11:47:02 +0200
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130409094542.GA26503@Fea.lerya.net> (sfid-20130409_114715_108609_A501E453)
References: <513A960B.2020304@lwfinger.net>
 <20130309113222.GA3009@Fea.lerya.net>
 <513B7E58.9000505@lwfinger.net>
 <20130311183825.GG3009@Fea.lerya.net>
 <20130313080048.GB3484@Fea.lerya.net>
 <20130317141201.GA2557@Fea.lerya.net>
 <20130325182910.GA10274@Fea.lerya.net>
 <5150A15F.20600@lwfinger.net>
 <20130325195104.GA11212@Fea.lerya.net>
 <5150AE0F.2040306@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="R+My9LyyhiUvIEro"
In-Reply-To: <5150AE0F.2040306@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi again :)

On Mon 25.Mar'13 at 15:05:35 -0500, Larry Finger wrote:
> I will let you change that G to a B and test some more. If all goes well, then I 
> will not need to set up that test bed, but at least I have the necessary details 
> if ever required.

I changed it from G to B. Now the rate (in iwconfig) is fixed to 11
Mb/s, but that's not a problem as you said it's not the real rate. I
didn't see any warning on module loading since that modification :)

I still have the deconnection/reconnection issue. After looking on the
reason, I think I have found a bug. Please look at the patched included
in this mail: I think the rtlpriv->link_info.num_rx_inperiod is set to 0
too early, as the '/* <4> roaming */' part uses it to see if the AP is
still alive. What do you think ?

Best,
Vincent

--R+My9LyyhiUvIEro
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="rtlwifi-watchdog-rx_inperiod.patch"

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index cac1fa9..d540938 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1411,7 +1411,6 @@ void rtl_watchdog_wq_callback(void *data)
 		schedule_work(&rtlpriv->works.lps_change_work);
 	}
 
-	rtlpriv->link_info.num_rx_inperiod = 0;
 	rtlpriv->link_info.num_tx_inperiod = 0;
 	for (tid = 0; tid <= 7; tid++)
 		rtlpriv->link_info.tidtx_inperiod[tid] = 0;
@@ -1448,6 +1447,7 @@ void rtl_watchdog_wq_callback(void *data)
 			rtlpriv->link_info.roam_times = 0;
 		}
 	}
+	rtlpriv->link_info.num_rx_inperiod = 0;
 	rtlpriv->link_info.bcn_rx_inperiod = 0;
 }
 

--R+My9LyyhiUvIEro--
