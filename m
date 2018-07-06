Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35198 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbeGFLjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:39:45 -0400
Message-ID: <1530877182.3197.3.camel@sipsolutions.net> (sfid-20180706_133948_279693_C22EDECE)
Subject: Re: [PATCH 4/7] cfg80211: Add support to notify station's rssi
 level crossing
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2018 13:39:42 +0200
In-Reply-To: <b87dc6cea56faee0a3570d90b4e6d42a@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-5-git-send-email-tamizhr@codeaurora.org>
         <1530264922.3481.40.camel@sipsolutions.net>
         <b87dc6cea56faee0a3570d90b4e6d42a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-04 at 11:43 +0530, Tamizh chelvam wrote:

> > > --- a/include/uapi/linux/nl80211.h
> > > +++ b/include/uapi/linux/nl80211.h
> > > @@ -1249,6 +1249,7 @@ enum nl80211_commands {
> > >  	NL80211_CMD_CONTROL_PORT_FRAME,
> > > 
> > >  	NL80211_CMD_SET_STA_MON,
> > > +	NL80211_CMD_NOTIFY_STA_MON,
> > 
> > Missing documentation - but again, why not unify it with the existing
> > event? Or can't we because that might confuse older applications?
> > Perhaps anyway we should unicast these notifications? Not sure though,
> > perhaps one app could set them up and the other might care?
> > 
> 
> This new command introduced as per the previous discussion
> https://patchwork.kernel.org/patch/10168685/
> https://patchwork.kernel.org/patch/10240697/
> 
> Is my understanding correct ?

I guess you're right. To my defense, this was like almost half a year
ago :)

> I just referred this code from cfg80211_prepare_cqm. Do you want me to 
> change this to struct based?

Please, I guess we can fix up cqm too later.

johannes
