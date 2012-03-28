Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43254 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2C1HXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 03:23:02 -0400
Date: Wed, 28 Mar 2012 10:24:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: linux-wireless@vger.kernel.org
Subject: signedness bug in lbs_auth_to_authtype()
Message-ID: <20120328072456.GC3200@mwanda> (sfid-20120328_092307_525707_5906DFEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a signedness bug in lbs_auth_to_authtype() and it messes
up the error handling.

drivers/net/wireless/libertas/cfg.c
   106  static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
   107  {
   108          int ret = -ENOTSUPP;
   109  

We return -ENOTSUPP but it's casted to u8 making it 244.

   351          auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
   352          auth->header.len = cpu_to_le16(sizeof(*auth)-sizeof(auth->header));
   353          auth->auth = cpu_to_le16(lbs_auth_to_authtype(auth_type));
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We don't check for errors here.

   354          return sizeof(*auth);
   355  }

  1061          /* convert auth_type */
  1062          ret = lbs_auth_to_authtype(sme->auth_type);
  1063          if (ret < 0)
                    ^^^^^^^
This doesn't work because 244 is larger than zero.

  1064                  goto done;

I would just change the u8 to an int, except that I felt that maybe
we should be checking for errors on the first time this function is
called.  I wasn't sure how to handle that error.

regards,
dan carpenter
