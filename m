Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42978 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbeEGUGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 16:06:45 -0400
Message-ID: <1525723602.1080.0.camel@sipsolutions.net> (sfid-20180507_220648_181452_7F370D04)
Subject: Re: [PATCH] mesh: don't process mesh channel switch unless csa ie
 provided
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 22:06:42 +0200
In-Reply-To: <81cf6620-d7f6-50f7-23c5-e1ba693f2907@bowerswilkins.com>
References: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com>
         <1525722286.22388.5.camel@sipsolutions.net>
         <81cf6620-d7f6-50f7-23c5-e1ba693f2907@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-07 at 13:04 -0700, Peter Oh wrote:
> 
> On 05/07/2018 12:44 PM, Johannes Berg wrote:
> > On Fri, 2018-04-27 at 12:26 -0700, peter.oh@bowerswilkins.com wrote:
> > > From: Peter Oh <peter.oh@bowerswilkins.com>
> > > 
> > > There is no meaning to call ieee80211_mesh_process_chnswitch
> > > without CSA IE provided, since the function will always return error.
> > 
> > I'm not convinced, an extended channel switch element might be present
> > instead?
> 
> I expected the comment. Yes, extended channel switch element could be 
> present instead of channel switch element which I missed to take care 
> of. So you can ignore the patch for now and I'll get back with right 
> patch for it.

Heh. Well, but then why bother at all? I mean, the inner function will
do the check and fail, and nothing will happen, so why bother?

johannes
