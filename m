Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35214 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbeGFLkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:40:55 -0400
Message-ID: <1530877252.3197.5.camel@sipsolutions.net> (sfid-20180706_134057_802141_085F0ABF)
Subject: Re: [PATCH 2/7] cfg80211: Add new NL command to configure peer
 specific rssi threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2018 13:40:52 +0200
In-Reply-To: <5d7f6ec9ffe0272b41102828f37706db@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-3-git-send-email-tamizhr@codeaurora.org>
         <1530264578.3481.34.camel@sipsolutions.net>
         <5d7f6ec9ffe0272b41102828f37706db@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-04 at 11:39 +0530, Tamizh chelvam wrote:
> On 2018-06-29 14:59, Johannes Berg wrote:
> > On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
> > > 
> > > + * @NL80211_ATTR_STA_MON: Station's connection monitor configuration 
> > > in a
> > > + *	nested attribute with %NL80211_ATTR_STA_MON_* sub-attributes.
> > 
> > Can't we reuse the existing attributes in this nesting?
> 
> This new attributes introduced as per the previous discussion.
> https://patchwork.kernel.org/patch/10240697/
> Is my understanding correct ?

Yeah ok ... I'm thinking perhaps we could share some part of it, but
it's not really worth making it more complex due to that.

> > Wait, you went to all this effort in the first patch and now you don't
> > add this to the list?
> > 
> No, the list and the rssi_config structure is for multi threshold value 
> and not for single threshold.

Yeah, though I'm still not sure why we need the single threshold thing
at all. List should always be a superset.

johannes
