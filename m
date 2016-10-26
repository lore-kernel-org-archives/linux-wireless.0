Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50254 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932453AbcJZJ0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:26:34 -0400
Message-ID: <1477473991.4059.26.camel@sipsolutions.net> (sfid-20161026_112638_763103_DB4719BC)
Subject: Re: [PATCH 8/8] mac80211: Claim Fast Initial Link Setup (FILS)
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Oct 2016 11:26:31 +0200
In-Reply-To: <20161026092315.GB3660@jouni.qca.qualcomm.com>
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
         <1477435489-8555-4-git-send-email-jouni@qca.qualcomm.com>
         <1477461036.4059.14.camel@sipsolutions.net>
         <20161026092315.GB3660@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 09:23 +0000, Malinen, Jouni wrote:
> On Wed, Oct 26, 2016 at 07:50:36AM +0200, Johannes Berg wrote:
> > 
> > On Wed, 2016-10-26 at 01:44 +0300, Jouni Malinen wrote:
> > > 
> > > With the previous commits, initial FILS support is now functional
> > > in
> > > mac80211-based drivers for both AP and stations roles.
> > 
> > That's a bit misleading, I guess AP role is handled entirely in
> > hostapd? You documented the extended feature bit to explicitly mean
> > station role only :)
> 
> Yeah.. In case of mac80211, there was not really changes needed in
> the kernel side for AP mode. That may be different with non-mac80211
> drivers, though, since they might be easier to handle with the AES-
> SIV operations for associations frames handled within the driver.

Right.

> Would you prefer to split that NL80211_EXT_FEATURE_FILS into two
> separate values (_STA and _AP) 

I think having it called _STA may be a little clearer, but I think I'm
OK with it the way it is (documented as station) as well.

> and have mac80211 advertise both? 

I wouldn't do that, there's nothing that makes it have that capability.

> Or just add a _STA only case for now and see what we need to do with
> NL80211_ATTR_DEVICE_AP_SME cases separately once such a thing is in
> in functional state?

Yeah, we should do that.

Really all I thought you should do was reword the commit message to
make it clear that the flag only implied the station case, and that the
AP case needed no changes.

Perhaps renaming the flag to ..._STA will make that a bit clearer.

johannes
