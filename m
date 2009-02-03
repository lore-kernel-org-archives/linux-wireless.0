Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1641 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZBCJUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 04:20:44 -0500
Subject: Re: potential null dereference in ipw_wx_set_scan()
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0902012132350.2949@bikeee>
References: <alpine.DEB.2.00.0902012132350.2949@bikeee>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 17:18:59 +0800
Message-Id: <1233652739.5990.238.camel@debian> (sfid-20090203_102050_434437_18F76762)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-03 at 16:21 +0800, Dan Carpenter wrote:
> I'm testing out my code checker (http://repo.or.cz/w/smatch.git/).
> 
> It complains about ipw_wx_set_scan() from 
> drivers/net/wireless/ipw2x00/ipw2200.c
> 
> Can the "if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { " from line 9522 
> ever be false?  If the conditions on lines 9516 and 9522 were both false 
> then 'work' would still be NULL.  That causes a null dereference in 
> queue_delayed_work() on line 9534.

Yes. I guess we never hit this because no one is using iw_scan_req other
than IW_SCAN_THIS_ESSID. Patch is welcome.

Thanks,
-yi

>    9515          if (wrqu->data.length == sizeof(struct iw_scan_req)) {
>    9516                  if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
>    9517                          int len = min((int)req->essid_len,
>    9518                                        (int)sizeof(priv->direct_scan_ssid));
>    9519                          memcpy(priv->direct_scan_ssid, req->essid, len);
>    9520                          priv->direct_scan_ssid_len = len;
>    9521                          work = &priv->request_direct_scan;
>    9522                  } else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {
>    9523                          work = &priv->request_passive_scan;
>    9524                  }
>    9525          } else {
>    9526                  /* Normal active broadcast scan */
>    9527                  work = &priv->request_scan;
>    9528          }



