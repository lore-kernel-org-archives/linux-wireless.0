Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web58908.mail.re1.yahoo.com ([66.196.100.237]:47258 "HELO
	web58908.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751462AbZDFWJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 18:09:00 -0400
Message-ID: <697933.8181.qm@web58908.mail.re1.yahoo.com> (sfid-20090407_000906_462008_FC8F4076)
Date: Mon, 6 Apr 2009 15:02:18 -0700 (PDT)
From: Philip Rakity <prakity@yahoo.com>
Subject: [PATCH] libertas: don't leak skb on receive error
To: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



if there is an error then routine lbs_process_rxed_packet in rx.c does not free the skb. 
signed off by: prakity@yahoo.com

--- linux-2.6.29/drivers/net/wireless/libertas/rx.c.old 2009-04-01 13:19:26.000000000 -0700
+++ linux-2.6.29/drivers/net/wireless/libertas/rx.c     2009-04-01 13:19:57.000000000 -0700
@@ -170,6 +170,7 @@
                lbs_deb_rx("rx err: frame received with bad length\n");
                priv->stats.rx_length_errors++;
                ret = 0;
+               dev_kfree_skb(skb);
                goto done;
        }

@@ -181,6 +182,7 @@
                lbs_pr_alert("rxpd not ok\n");
                priv->stats.rx_errors++;
                ret = 0;
+               dev_kfree_skb(skb);
                goto done;
        }


      
