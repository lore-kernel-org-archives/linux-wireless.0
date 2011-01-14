Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1ANXCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 18:02:07 -0500
Received: by iyj18 with SMTP id 18so2952057iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 15:02:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D309EC2.2060409@openwrt.org>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
	<AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
	<4D2E0653.7040606@openwrt.org>
	<20110113051849.GD8836@vmraj-lnx.users.atheros.com>
	<4D2F0ADF.1040009@openwrt.org>
	<20110113163513.GA9291@vmraj-lnx.users.atheros.com>
	<4D2F2D22.6070301@openwrt.org>
	<20110114181309.GA11920@vmraj-lnx.users.atheros.com>
	<4D30944A.30100@openwrt.org>
	<20110114185317.GA12051@vmraj-lnx.users.atheros.com>
	<4D309EC2.2060409@openwrt.org>
Date: Sat, 15 Jan 2011 00:02:05 +0100
Message-ID: <AANLkTimQqGQNd2sZiuf=oGK3CBHerBZSmy4n4=Bk1V0b@mail.gmail.com>
Subject: Re: [RFC] ath9k: Handle interface changes properly
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 8:06 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> I think that when we use ah->opmode, we should only use it for very generic
> operating modes:
>
> AP: no TSF sync, beacon tx can be enabled.
> ADHOC: TSF sync against IBSS cell, beacon tx can be enabled
> STATION: TSF sync against one AP, only station beacon timers for PS.
>
> Only the above distinctions are relevant for ath9k_hw, everything else is
> handled by the driver/stack. There is no reason for adding extra checks to
> ath9k_hw for mesh and WDS, since they work best with ah->opmode set to AP,
> and there is nothing extra on the *hardware* side that should be configured
> there via a different opmode. That's why I think leaking the mac80211
> interface types to ath9k_hw is a bad idea.

Isn't that also a good argument against using nl80211_iftype in this
context? The values currently defined are:

 * @NL80211_IFTYPE_ADHOC: independent BSS member
 * @NL80211_IFTYPE_STATION: managed BSS member
 * @NL80211_IFTYPE_AP: access point
 * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
 * @NL80211_IFTYPE_WDS: wireless distribution interface
 * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
 * @NL80211_IFTYPE_MESH_POINT: mesh point
 * @NL80211_IFTYPE_P2P_CLIENT: P2P client
 * @NL80211_IFTYPE_P2P_GO: P2P group owner

But what we really want to do is keep track of TSF sync and beaconing.
For beacon we have already given up on opmode and now use nbcnvifs.
Perhaps we could find some similar way to handle TSF sync?

/Björn
