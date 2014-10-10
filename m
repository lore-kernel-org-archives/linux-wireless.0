Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaJJMuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 08:50:08 -0400
Date: Fri, 10 Oct 2014 15:49:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: re: airo: clean up and clarify interrupt-time task handling
Message-ID: <20141010124946.GA14358@mwanda> (sfid-20141010_145015_561831_0B0DA01E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan Williams,

The patch f55d4517ebdd: "airo: clean up and clarify interrupt-time
task handling" from Jan 24, 2009, leads to the following static
checker warning:

	drivers/net/wireless/airo.c:3373 airo_handle_rx()
	warn: XXX pointer math issue ('buffer' is a 2 byte pointer)

drivers/net/wireless/airo.c
  3282  static void airo_handle_rx(struct airo_info *ai)
  3283  {
  3284          struct sk_buff *skb = NULL;
  3285          __le16 fc, v, *buffer, tmpbuf[4];
  3286          u16 len, hdrlen = 0, gap, fid;
  3287          struct rx_hdr hdr;
  3288          int success = 0;
  3289  

[ snip ]

  3354          } else {
  3355                  MICBuffer micbuf;
  3356  
  3357                  bap_read(ai, buffer, ETH_ALEN * 2, BAP0);
  3358                  if (ai->micstats.enabled) {
  3359                          bap_read(ai, (__le16 *) &micbuf, sizeof (micbuf), BAP0);
  3360                          if (ntohs(micbuf.typelen) > 0x05DC)
  3361                                  bap_setup(ai, fid, 0x44, BAP0);
  3362                          else {
  3363                                  if (len <= sizeof (micbuf)) {
  3364                                          dev_kfree_skb_irq(skb);
  3365                                          goto done;
  3366                                  }
  3367  
  3368                                  len -= sizeof(micbuf);
  3369                                  skb_trim(skb, len + hdrlen);
  3370                          }
  3371                  }
  3372  
  3373                  bap_read(ai, buffer + ETH_ALEN, len, BAP0);
                                     ^^^^^^^^^^^^^^^^^
It's really unusual to use ETH_ALEN to represent 12 bytes.  Normally
it is a bug when people do that.  But looking at the context it be
intentional here...  It's not clear.

  3374                  if (decapsulate(ai, &micbuf, (etherHead*) buffer, len))
  3375                          dev_kfree_skb_irq (skb);
  3376                  else
  3377                          success = 1;
  3378          }

regards,
dan carpenter
