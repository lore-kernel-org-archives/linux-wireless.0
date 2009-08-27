Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZH0OGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 10:06:03 -0400
Subject: Re: libertas wext.c: IW_ENCODE_NOKEY for WEP keys [resend as plain
 text]
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F704306D2369E90@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F704306D2369E90@SC-VEXCH1.marvell.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 09:06:15 -0500
Message-Id: <1251381975.11788.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-26 at 12:11 -0700, Bing Zhao wrote:
> Hi all,
>  
> There was a commit to unset the IW_ENCODE_NOKEY flag for WEP keys.
>  
> "libertas: Don't set IW_ENCODE_NOKEY when returning WEP keys."
>   
>  
> Without this change, the IW_ENCODE_NOKEY flag is set for WEP keys and then iwconfig command would display "****-****-**" as "Encryption key".
>   
> After this change, the IW_ENCODE_NOKEY flag is NOT set for WEP keys and then iwconfig command will display plain text of the WEP key ("1234-5678-90" in my case, below).

mac82011 doesn't set NOKEY in cfg80211_wext_giwencode().  I guess we
should ask if *all* drivers should set NOKEY and then be consistent.

Dan

> eth1      IEEE 802.11b/g  ESSID:"Cisco1-G"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:1D:45:CE:20:D0
>           Bit Rate:54 Mb/s   Tx-Power=15 dBm
>           Retry short limit:8   RTS thr=2347 B   Fragment thr=2346 B
>  
>           Encryption key:1234-5678-90   Security mode:open
>  
>           Power Management:off
>           Link Quality=92/100  Signal level=-66 dBm  Noise level=-94 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>  
>  
>  
> Was there any reason to not set IW_ENCODE_NOKEY for WEP keys?
> Is it feasible to set IW_ENCODE_NOKEY for WEP switch case?
>  
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1165,6 +1165,7 @@ static int lbs_get_encode(struct net_device *dev,
>                 dwrq->flags |= (index + 1);
>                 /* Return WEP enabled */
>                 dwrq->flags &= ~IW_ENCODE_DISABLED;
> +               dwrq->flags |= IW_ENCODE_NOKEY;
>         } else if ((priv->secinfo.WPAenabled)
>                    || (priv->secinfo.WPA2enabled)) {
>                 /* return WPA enabled */
>  
> 
> Thanks for your help,
>  
> Bing
> 

