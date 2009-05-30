Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([204.127.217.103]:53887 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZE3VAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 17:00:41 -0400
Message-ID: <4A219E78.5070009@lwfinger.net>
Date: Sat, 30 May 2009 16:00:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks wireless
 on my system
References: <1243716437.26585.4.camel@maxim-laptop>
In-Reply-To: <1243716437.26585.4.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> I use nl80211 wpa_suppicant driver.
> With this commit (have just bisected) I can't connect to same AP twice,
> and usually only a module reload, or somtimes restart of supplicant
> help.
> Actually usually I can't connect again after first successful connection
> at all.
> 
> 
> With wext supplicant works, but still sometimes hangs in same way.
> 
> commit 1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue May 19 22:16:25 2009 +0200
> 
>     mac80211: don't try to do anything on unchanged genIE
>     
>     When the genIE hasn't changed there's no reason to kick
>     the state machine since it won't be able to do anything
>     new -- doing this decreases the useless work we do for
>     reassociating because if we do kick the state machine
>     it will try to find a usable BSS but there might not be
>     one because wpa_supplicant will only change the BSSID
>     a little later.
>     
>     In a sense this is a workaround for userspace behaviour,
>     but on the other hand userspace cannot really keep track
>     of what the kernel currently has for genIE since any
>     process could have changed that while wpa_supplicant
>     wasn't looking.
>     
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

>From the above patch, this hunk looks a little strange:

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index c143947..a01154e 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -37,12 +37,13 @@ static int ieee80211_ioctl_siwgenie(struct
net_device *dev,

        if (sdata->vif.type == NL80211_IFTYPE_STATION) {
                int ret = ieee80211_sta_set_extra_ie(sdata, extra,
data->length);
-               if (ret)
+               if (ret && ret != -EALREADY)
                        return ret;
                sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
                sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
                sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-               ieee80211_sta_req_auth(sdata);
+               if (ret != -EALREADY)
+                       ieee80211_sta_req_auth(sdata);
                return 0;
        }

Why is there a check before the call to ieee80211_sta_req_auth()? If
ret != -EALREADY, would we not have already exited?

Larry

