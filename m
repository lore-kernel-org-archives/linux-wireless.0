Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:57691 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab1JEGAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 02:00:10 -0400
Date: Wed, 5 Oct 2011 08:59:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: re: ath6kl: pass only unicast frames for aggregation
Message-ID: <20111005055958.GA32513@elgon.mountain> (sfid-20111005_080014_141134_437A5F20)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Smatch complains that 5694f962964 "ath6kl: pass only unicast frames
for aggregation"

drivers/net/wireless/ath/ath6kl/txrx.c
  1241                          if (conn && ar->intra_bss) {
  1242                                  skb1 = skb;
  1243                                  skb = NULL;
                                        ^^^^^^^^^^^
  1244                          } else if (conn && !ar->intra_bss) {
  1245                                  dev_kfree_skb(skb);
  1246                                  skb = NULL;
                                        ^^^^^^^^^^^
  1247                          }
  1248                  }
  1249                  if (skb1)
  1250                          ath6kl_data_tx(skb1, ar->net_dev);
  1251          }
  1252  
  1253          datap = (struct ethhdr *) skb->data;
                                          ^^^^^^^^^
skb can be NULL.

  1254  

regards,
dan carpenter
