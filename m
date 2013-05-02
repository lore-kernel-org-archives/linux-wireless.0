Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2228 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3EBKEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 06:04:09 -0400
Message-ID: <51823A0E.8020005@broadcom.com> (sfid-20130502_120419_569754_7D766FF1)
Date: Thu, 2 May 2013 12:03:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2013 02:26 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Android requires a "p2p0" netdev to exist for P2P Device
> functionality, and will even set it "UP" to start the P2P
> Device functionality.
>
> This is a hack to provide it so not only is Android happy
> but also the current version of wpa_supplicant can work
> with P2P-Device functionality without needing changes to
> support the P2P-Device commands, just a little bit to not
> attempt to change the interface type to station.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Hi Johannes,

I tested the patch on x86 platform and was successful executing a 
p2p_find, p2p_connect, and able to ping my peer. But....

When I tried this a second time I got a lockdep warning about annotation 
as brcmfmac tried to take a mutex during scan (p2p_find). Two minutes 
later I got warning about rcu stalls. Not sure where to look.

Gr. AvS

