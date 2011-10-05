Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45560 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1JEKL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 06:11:58 -0400
Message-ID: <4E8C2CF1.7000206@qca.qualcomm.com> (sfid-20111005_121202_954190_C0AF7F6C)
Date: Wed, 5 Oct 2011 13:09:53 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>
Subject: Re: ath6kl: pass only unicast frames for aggregation
References: <20111005055958.GA32513@elgon.mountain>
In-Reply-To: <20111005055958.GA32513@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On 10/05/2011 08:59 AM, Dan Carpenter wrote:
> Smatch complains that 5694f962964 "ath6kl: pass only unicast frames
> for aggregation"
> 
> drivers/net/wireless/ath/ath6kl/txrx.c
>   1241                          if (conn && ar->intra_bss) {
>   1242                                  skb1 = skb;
>   1243                                  skb = NULL;
>                                         ^^^^^^^^^^^
>   1244                          } else if (conn && !ar->intra_bss) {
>   1245                                  dev_kfree_skb(skb);
>   1246                                  skb = NULL;
>                                         ^^^^^^^^^^^
>   1247                          }
>   1248                  }
>   1249                  if (skb1)
>   1250                          ath6kl_data_tx(skb1, ar->net_dev);
>   1251          }
>   1252  
>   1253          datap = (struct ethhdr *) skb->data;
>                                           ^^^^^^^^^
> skb can be NULL.

Good catch, thanks! I should run smatch more, it's a really nice tool.

I think a fix like this would be appropriate. Jouni, what do you think?

(I have just copypasted the patch to thunderbird, I'm sure it's white
space damaged. Sorry about that.)

Kalle

--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1247,6 +1247,10 @@ void ath6kl_rx(struct htc_target *target, struct
htc_packet *packet)
                }
                if (skb1)
                        ath6kl_data_tx(skb1, ar->net_dev);
+
+               if (skb == NULL)
+                       /* nothing to deliver up the stack */
+                       return;
        }

        datap = (struct ethhdr *) skb->data;
