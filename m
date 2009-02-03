Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43051 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZBCIWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 03:22:13 -0500
Received: by ewy14 with SMTP id 14so2278542ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 00:22:11 -0800 (PST)
Date: Tue, 3 Feb 2009 11:21:52 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: potential null dereference in ipw_wx_set_scan()
Message-ID: <alpine.DEB.2.00.0902012132350.2949@bikeee> (sfid-20090203_092218_321419_669F7B3C)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm testing out my code checker (http://repo.or.cz/w/smatch.git/).

It complains about ipw_wx_set_scan() from 
drivers/net/wireless/ipw2x00/ipw2200.c

Can the "if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { " from line 9522 
ever be false?  If the conditions on lines 9516 and 9522 were both false 
then 'work' would still be NULL.  That causes a null dereference in 
queue_delayed_work() on line 9534.

   9515          if (wrqu->data.length == sizeof(struct iw_scan_req)) {
   9516                  if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
   9517                          int len = min((int)req->essid_len,
   9518                                        (int)sizeof(priv->direct_scan_ssid));
   9519                          memcpy(priv->direct_scan_ssid, req->essid, len);
   9520                          priv->direct_scan_ssid_len = len;
   9521                          work = &priv->request_direct_scan;
   9522                  } else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {
   9523                          work = &priv->request_passive_scan;
   9524                  }
   9525          } else {
   9526                  /* Normal active broadcast scan */
   9527                  work = &priv->request_scan;
   9528          }

regards,
dan carpenter

