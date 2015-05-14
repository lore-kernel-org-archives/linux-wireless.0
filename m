Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21169 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbENIac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 04:30:32 -0400
Date: Thu, 14 May 2015 11:30:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gaston Gonzalez <gascoar@gmail.com>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com, julian.calaby@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
Message-ID: <20150514083012.GG8431@mwanda> (sfid-20150514_103039_590241_9A8A1B2E)
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>
 <20150420082441.GU10964@mwanda>
 <553C18B6.807@gmail.com>
 <20150427101242.GR14154@mwanda>
 <554AD76E.7060605@gmail.com>
 <20150508110328.GT14154@mwanda>
 <55527D6E.7090207@gmail.com>
 <20150513083615.GS14154@mwanda>
 <5553F48E.3050008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5553F48E.3050008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2015 at 10:04:14PM -0300, Gaston Gonzalez wrote:
> @@ -327,7 +280,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff
> *skb, int hdr_len, void *priv)
>                      tkey->tx_iv32);
>              tkey->tx_phase1_done = 1;
>          }
> -        tkip_mixing_phase2(rc4key, tkey->key, tkey->tx_ttak,
> tkey->tx_iv16);
> +        tkip_mixing_phase2(tkey->key, tkey->tx_ttak, tkey->tx_iv16,
> rc4key);
>      }
>      else
>      tkey->tx_phase1_done = 1;
> @@ -447,4 +400,4 @@ static int ieee80211_tkip_decrypt(struct sk_buff
> *skb, int hdr_len, void *priv)
>              tkip_mixing_phase1(tkey->rx_ttak, tkey->key, hdr->addr2, iv32);
>              tkey->rx_phase1_done = 1;
>          }
> -        tkip_mixing_phase2(rc4key, tkey->key, tkey->rx_ttak, iv16);
> +        tkip_mixing_phase2(tkey->key, tkey->rx_ttak, iv16, rc4key);
> 
>         plen = skb->len - hdr_len - 12;
> 

This patch got corrupted over email, so I can't review it inline, but it
looks much more reasonable.

regards,
dan carpenter

