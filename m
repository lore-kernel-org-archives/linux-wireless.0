Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51808 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdISIPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 04:15:21 -0400
Message-ID: <1505808914.3026.0.camel@sipsolutions.net> (sfid-20170919_101524_366103_790B085A)
Subject: Re: [TDLS PATCH V3 1/5] mac80211: Enable TDLS peer buffer STA
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        yintang@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Sep 2017 10:15:14 +0200
In-Reply-To: <db428527-cb2b-5136-24c2-be2fca9e2407@broadcom.com> (sfid-20170919_095629_313381_9836835D)
References: <TDLS for ath10k patchset v3>
         <1505790913-28377-1-git-send-email-yintang@qti.qualcomm.com>
         <1505790913-28377-2-git-send-email-yintang@qti.qualcomm.com>
         <db428527-cb2b-5136-24c2-be2fca9e2407@broadcom.com>
         (sfid-20170919_095629_313381_9836835D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-19 at 09:56 +0200, Arend van Spriel wrote:
> 
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -3249,6 +3249,8 @@ struct cfg80211_ops {
> >    *	beaconing mode (AP, IBSS, Mesh, ...).
> >    * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key
> > installation
> >    *	before connection.
> > + * @WIPHY_FLAG_SUPPORT_TDLS_BUFFER_STA: Device support buffer STA
> > when TDLS is
> > + *	established.
> 
> If I am not mistaken no new wiphy flags are supposed to be added. 
> Although this might be something not reported to user-space, right?
> Have  a look at struct wiphy::ext_features.

I guess it should just be a HW flag in mac80211? Not sure why userspace
even needs to know.

johannes
