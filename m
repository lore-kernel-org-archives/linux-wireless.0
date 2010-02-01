Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59876 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0BAUPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 15:15:37 -0500
Date: Mon, 1 Feb 2010 15:12:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: shanyu.zhao@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1 v3] cfg80211: wext: fix cfg80211's SIOCSIWAP
	function
Message-ID: <20100201201246.GD4952@tuxdriver.com>
References: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com> <1264840545.3546.179.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264840545.3546.179.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 30, 2010 at 09:35:45AM +0100, Johannes Berg wrote:
> 
> > @@ -779,10 +779,15 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
> >  			wdev->conn->auto_auth = false;
> >  		}
> >  
> > -		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
> > +		/* make sure it can connect if only bssid is provided */
> >  		wdev->ssid_len = connect->ssid_len;
> > -		wdev->conn->params.ssid = wdev->ssid;
> >  		wdev->conn->params.ssid_len = connect->ssid_len;
> > +		if (connect->ssid_len) {
> > +			memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
> > +			wdev->conn->params.ssid = wdev->ssid;
> > +		}
> > +		else
> > +			wdev->conn->params.ssid = NULL;
> 
> I don't think I understand this. The wdev->conn->params are initialised
> from "connect", and now you're copying the data back again? That's not
> making sense to me.
> 
> Also, please say what exactly are you trying to fix.
> 
> Also, cfg80211_mgd_wext_siwap() certainly is _not_ expected to clear the
> SSID, since we want to connect to the previously set SSID. Same with
> cfg80211_mgd_wext_siwessid(), it should _not_ clear the BSSID.
> 
> Right now, it looks to me that your patch makes it impossible to specify
> both the SSID and the BSSID to connect to, which is definitely wrong.
> 
> John, you mentioned you had applied this, can you revert this patch for
> now?

Yeah, it's coming out...  Clearly I didn't understand what it was doing.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
