Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56907 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965805AbeFOLZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:25:31 -0400
Date: Fri, 15 Jun 2018 13:25:08 +0200
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 5/5] staging: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Message-ID: <20180615112508.GA22268@kroah.com> (sfid-20180615_132537_617376_4B34CD24)
References: <1528971217-566-1-git-send-email-omer.efrat@tandemg.com>
 <1528974574.26847.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528974574.26847.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2018 at 01:09:34PM +0200, Johannes Berg wrote:
> On Thu, 2018-06-14 at 13:13 +0300, Omer Efrat wrote:
> > Since 'filled' member in station_info changed to u64, BIT_ULL macro
> > should be used with NL80211_STA_INFO_* attribute types instead of BIT.
> > 
> > The BIT macro uses unsigned long type which some architectures handle as 32bit
> > and this results in compilation warnings such as:
> > 
> > net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
> >   sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
> >   ^
> 
> Same here, I don't think this patch is really needed, but I'll leave it
> up to Greg.
> 
> Greg, FWIW, only a few values are >=31 to need this, including the one
> pointed out in the commit message, but none in this code are affected.

Thanks for the warning, I'll take this just to keep things "clean".

greg k-h
