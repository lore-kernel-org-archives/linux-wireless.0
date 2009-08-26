Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:54089 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZHZTLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 15:11:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Aug 2009 12:11:05 -0700
Subject: libertas wext.c: IW_ENCODE_NOKEY for WEP keys [resend as plain text]
Message-ID: <477F20668A386D41ADCC57781B1F704306D2369E90@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
 
There was a commit to unset the IW_ENCODE_NOKEY flag for WEP keys.
 
"libertas: Don't set IW_ENCODE_NOKEY when returning WEP keys."
  
 
Without this change, the IW_ENCODE_NOKEY flag is set for WEP keys and then iwconfig command would display "****-****-**" as "Encryption key".
  
After this change, the IW_ENCODE_NOKEY flag is NOT set for WEP keys and then iwconfig command will display plain text of the WEP key ("1234-5678-90" in my case, below).
 
eth1      IEEE 802.11b/g  ESSID:"Cisco1-G"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:1D:45:CE:20:D0
          Bit Rate:54 Mb/s   Tx-Power=15 dBm
          Retry short limit:8   RTS thr=2347 B   Fragment thr=2346 B
 
          Encryption key:1234-5678-90   Security mode:open
 
          Power Management:off
          Link Quality=92/100  Signal level=-66 dBm  Noise level=-94 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
 
 
 
Was there any reason to not set IW_ENCODE_NOKEY for WEP keys?
Is it feasible to set IW_ENCODE_NOKEY for WEP switch case?
 
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1165,6 +1165,7 @@ static int lbs_get_encode(struct net_device *dev,
                dwrq->flags |= (index + 1);
                /* Return WEP enabled */
                dwrq->flags &= ~IW_ENCODE_DISABLED;
+               dwrq->flags |= IW_ENCODE_NOKEY;
        } else if ((priv->secinfo.WPAenabled)
                   || (priv->secinfo.WPA2enabled)) {
                /* return WPA enabled */
 

Thanks for your help,
 
Bing

