Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A72BC3A5A4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E8F62073F
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfH3KkX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:40:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34604 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfH3KkX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 06:40:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3eKL-00044B-N1; Fri, 30 Aug 2019 12:40:21 +0200
Message-ID: <411af6692d26e9c52c0e3caa86a0fbae0c28a96c.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: inspect off channel operation only when off
 channel given
From:   Johannes Berg <johannes@sipsolutions.net>
To:     peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org
Date:   Fri, 30 Aug 2019 12:40:20 +0200
In-Reply-To: <1530880295.3197.39.camel@sipsolutions.net> (sfid-20180706_143329_659166_FFE17039)
References: <1530659052-5834-1-git-send-email-peter.oh@bowerswilkins.com>
         <1530880295.3197.39.camel@sipsolutions.net>
         (sfid-20180706_143329_659166_FFE17039)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-07-06 at 14:31 +0200, Johannes Berg wrote:
> On Tue, 2018-07-03 at 16:04 -0700, peter.oh@bowerswilkins.com wrote:
> > From: Peter Oh <peter.oh@bowerswilkins.com>
> > 
> > NL80211_ATTR_OFFCHANNEL_TX_OK does not mean given channel is always
> > off channel, but it means the channel given could be off channel.
> > Hence it should not block the given channel to be used if given
> > channel does not require off channel mgmt tx although regulatory
> > domain is non-ETSI.
> > 
> > Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
> > ---
> >  net/wireless/nl80211.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index 4eece06..991042b 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -9915,7 +9915,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
> >  		return -EINVAL;
> >  
> >  	wdev_lock(wdev);
> > -	if (params.offchan && !cfg80211_off_channel_oper_allowed(wdev)) {
> > +	if (params.offchan &&
> > +	    !cfg80211_chandef_identical(&chandef, &wdev->chandef) &&
> > +	    !cfg80211_off_channel_oper_allowed(wdev)) {
> >  		wdev_unlock(wdev);
> 
> Hmm. That seems fine, but can we be sure that wdev->chandef is always
> valid? ISTR that it isn't necessarily updated all the time, but I can't
> really say right now.

For the record, in addition to this question, the commit log might need
some rewording since the whole regulatory/non-ETSI part isn't really
obvious (and not clear to me right now).

I've had this patch waiting for about a year now, I'll drop it. Please
resend if it's still relevant.

johannes

