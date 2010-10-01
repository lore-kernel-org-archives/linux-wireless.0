Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53210 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0JARpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 13:45:46 -0400
Received: by qyk36 with SMTP id 36so3609877qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 10:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285949212.3739.38.camel@jlt3.sipsolutions.net>
References: <1285946441-20152-1-git-send-email-bjordan@rajant.com>
	<1285946441-20152-3-git-send-email-bjordan@rajant.com>
	<1285949159.3739.37.camel@jlt3.sipsolutions.net>
	<1285949212.3739.38.camel@jlt3.sipsolutions.net>
Date: Fri, 1 Oct 2010 13:45:44 -0400
Message-ID: <AANLkTi=tLTe1_gsptX-f3DshGWgqab7D2x3MDV3E--9-@mail.gmail.com>
Subject: Re: [PATCH 2/3] cfg80211: patches to allow setting the WDS peer
From: Bill Jordan <bjordan@rajant.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 12:06 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-10-01 at 18:05 +0200, Johannes Berg wrote:
>> On Fri, 2010-10-01 at 11:20 -0400, Bill Jordan wrote:
>>
>> > +static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
>> > +{
>> > +   struct cfg80211_registered_device *rdev;
>> > +   struct wireless_dev *wdev;
>> > +   struct net_device *dev;
>> > +   u8 *bssid;
>> > +   int err;
>> > +
>> > +   if (!info->attrs[NL80211_ATTR_MAC])
>> > +           return -EINVAL;
>> > +
>> > +   rtnl_lock();
>> > +
>> > +   err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
>> > +   if (err)
>> > +           goto unlock_rtnl;
>> > +
>> > +   wdev = dev->ieee80211_ptr;
>>
>> I think this (or maybe the mac80211 bit, but I think here makes more
>> sense) needs to check !netif_running(), otherwise you can change the
>> peer without it taking effect, or something like that? Sorry, should've
>> noted that earlier.
>
> cfg80211_wds_wext_siwap does this.
>
> johannes

You are correct. I was able to change the peer while the interface was running.
I've updated the patch to fix this, and I'll resend it.

Bill
