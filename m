Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51801 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZDHNpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 09:45:49 -0400
Date: Wed, 8 Apr 2009 09:45:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: unreachable code in airo_set_auth()
Message-ID: <20090408134504.GA24452@tuxdriver.com> (sfid-20090408_154552_443158_587543AA)
References: <alpine.DEB.2.00.0904072049540.8684@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.0904072049540.8684@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 08, 2009 at 02:02:41PM +0300, Dan Carpenter wrote:
> Smatch (http://repo.or.cz/w/smatch.git) complains about unreachable code 
> in airo_set_auth() from drivers/net/wireless/airo.c
> 
> We don't actually commit the changes, but instead break on line 6577.  I 
> didn't know what was intended there.  Or who the maintainer was.
> 
> regards,
> dan carpenter
> 
>   6567          case IW_AUTH_80211_AUTH_ALG: {
>   6568                          /* FIXME: What about AUTH_OPEN?  This API seems to
>   6569                           * disallow setting our auth to AUTH_OPEN.
>   6570                           */
>   6571                          if (param->value & IW_AUTH_ALG_SHARED_KEY) {
>   6572                                  local->config.authType = AUTH_SHAREDKEY;
>   6573                          } else if (param->value & IW_AUTH_ALG_OPEN_SYSTEM) {
>   6574                                  local->config.authType = AUTH_ENCRYPT;
>   6575                          } else
>   6576                                  return -EINVAL;
>   6577                          break;
>   6578  
>   6579                          /* Commit the changes to flags if needed */
>   6580                          if (local->config.authType != currentAuthType)
>   6581                                  set_bit (FLAG_COMMIT, &local->flags);
>   6582                  }

Not sure what tree you're based upon, but the same code is farther
down now.  Anyway:

4be757dd	(Dan Williams	2006-01-30 11:58:00 -0500	6716)		break;
4be757dd	(Dan Williams	2006-01-30 11:58:00 -0500	6717)
4be757dd	(Dan Williams	2006-01-30 11:58:00 -0500	6718)		/* Commit the changes to flags if needed */

Looks like we can blame Dan since he added those lines all in one
patch.  Pay no attention to the person that committed... :-)

Dan, what is the proper fix?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
