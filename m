Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbGAOxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 10:53:46 -0400
Message-ID: <1435762425.7441.8.camel@redhat.com> (sfid-20150701_165350_230377_B5C7767F)
Subject: Re: Dual mode operation
From: Dan Williams <dcbw@redhat.com>
To: Stark Pister <stark@cirrent.co>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Jul 2015 09:53:45 -0500
In-Reply-To: <CAPA_7hazB4hKyNOMd892riL1p4-pqDQEAP=UTS2AofGJy3_21A@mail.gmail.com>
References: <CAPA_7hazB4hKyNOMd892riL1p4-pqDQEAP=UTS2AofGJy3_21A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-30 at 16:57 -0700, Stark Pister wrote:
> I am trying to figure out how to use virtual interfaces to run my wifi
> module in both AP mode and station mode simultaneously. From the
> description on this page
> (https://wireless.wiki.kernel.org/en/users/documentation/iw/vif) it
> would seem this is possible on devices using the mac80211 subsystem,
> but from what I have read online it only works with madwifi drivers
> which is outdated and abandoned.

Most of the common mac80211-based devices allow this.  You can see what
modes your driver supports by doing:

$ iw phy phy0 info
...
  software interface modes (can always be added):
  	 * AP/VLAN
  	 * monitor
  valid interface combinations:
  	 * #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1,
#{ P2P-device } <= 1,
  	   total <= 3, #channels <= 2
...

This is for an Intel 7265 card, and you can see that this device
supports simultaneous STA and AP modes, but only one interface of each.

> Are there other drivers that tap into this capability of mac80211 or
> is no one else interested in this? Is the generic nl80211 driver
> capable of using this functionality and if so, how do I go about using
> it (note that the "AP" and "Station" sections of the above
> documentation page are blank)? If not, what would I have to change to
> enable the use of this dual mode capability?

Whether your device has this capability highly depends on the hardware,
firmware, and driver.  The 'iw' command I posted above will show what
your combination supports.

Dan


