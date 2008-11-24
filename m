Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:41944 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYKXLiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 06:38:54 -0500
Received: by ey-out-2122.google.com with SMTP id 6so790785eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 03:38:53 -0800 (PST)
Message-ID: <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com> (sfid-20081124_123859_494055_67377A76)
Date: Mon, 24 Nov 2008 13:38:52 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS clients (wireless-testing).
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1227525694.3599.95.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
	 <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com>
	 <1227525694.3599.95.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  I indeed intend to fix the driver to do the buffering and use
_get_buffered_bc() (and also add sequence numbering, which is easier).
It will take time to fix it and to test it with hostapd and clients.

When it will be ready, the only thing which will be needed is
to remove the "hw->wiphy->ap_ps_challenged = true" from
zd_mac_alloc_hw() in zd_mac.c. The other changes in the driver should
of course stay (adding handling of NL80211_IFTYPE_AP).

As far as I understand, the zd1211rw is not the only one which does
not support buffering; (and I assume there will be other such drivers
without this support in the future); so it seems to me that the
nl80211 patch, which enable users who would prefer to have an AP that
can't support fully PS clients, rather than not having an AP at all,
is a good enough reason for the nl80211 patch.

Using Linux as an access point with a standard and a wide range of
commodity wireless drivers seems really a nice and important feature.

Regards,
Rami Rosen


On Mon, Nov 24, 2008 at 1:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-24 at 13:09 +0200, Rami Rosen wrote:
>
>> If you are talking about whether the zd1211 driver can buffer
>> mcast/bcast frames in software, it seems to me that the answer is
>> negative, since there is no call for ieee80211_get_buffered_bc() in
>> the zd1211rw driver code and also there is no handling of
>> IEEE80211_TX_CTL_SEND_AFTER_DTIM or
>> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING in the zd1211rw driver code.
>> This what made me add the NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
>> attribute and prepare this patch.
>
> Yes, I know that's why you did it, but I'm still wondering whether it
> was necessary, is it really impossible to implement mcast/bcast
> buffering with this hardware? IOW, can we fix the driver to do the
> buffering and using _get_buffered_bc()?
>
> johannes
>
