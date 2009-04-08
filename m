Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:41186 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZDHLGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 07:06:08 -0400
Received: by yw-out-2324.google.com with SMTP id 5so49857ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 04:06:07 -0700 (PDT)
Date: Wed, 8 Apr 2009 14:02:41 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: unreachable code in airo_set_auth()
Message-ID: <alpine.DEB.2.00.0904072049540.8684@bicker> (sfid-20090408_130613_532396_5CD8BF29)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch (http://repo.or.cz/w/smatch.git) complains about unreachable code 
in airo_set_auth() from drivers/net/wireless/airo.c

We don't actually commit the changes, but instead break on line 6577.  I 
didn't know what was intended there.  Or who the maintainer was.

regards,
dan carpenter

  6567          case IW_AUTH_80211_AUTH_ALG: {
  6568                          /* FIXME: What about AUTH_OPEN?  This API seems to
  6569                           * disallow setting our auth to AUTH_OPEN.
  6570                           */
  6571                          if (param->value & IW_AUTH_ALG_SHARED_KEY) {
  6572                                  local->config.authType = AUTH_SHAREDKEY;
  6573                          } else if (param->value & IW_AUTH_ALG_OPEN_SYSTEM) {
  6574                                  local->config.authType = AUTH_ENCRYPT;
  6575                          } else
  6576                                  return -EINVAL;
  6577                          break;
  6578  
  6579                          /* Commit the changes to flags if needed */
  6580                          if (local->config.authType != currentAuthType)
  6581                                  set_bit (FLAG_COMMIT, &local->flags);
  6582                  }

