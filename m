Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39139 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab0JVS13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 14:27:29 -0400
Date: Fri, 22 Oct 2010 21:27:24 +0300
From: Jouni Malinen <j@w1.fi>
To: Chaoxing Lin <clin@3eti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Help: Guidance on "AP/VLAN" mode
Message-ID: <20101022182724.GA9896@jm.kir.nu>
References: <loom.20101021T172706-705@post.gmane.org>
 <20101022152753.GA4853@jm.kir.nu>
 <0E78D47E19ECA44893BC64D10E0D130E014FA568@efjrocmx01.EFJDFW.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0E78D47E19ECA44893BC64D10E0D130E014FA568@efjrocmx01.EFJDFW.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 22, 2010 at 01:43:07PM -0400, Chaoxing Lin wrote:
> CLIN: I saw that dynamic-VLAN section. And did not quite understand how
> to setup. Is there any further documentation on dynamica-VLAN?

I don't know, but Google search for the configuration field names in
hostapd.conf will likely give you some hits (no guarantees of usefulness
of those, though).

> Must the interface in /etc/hostapd.vlan be type of __ap_vlan? Or it can
> be any AP interface specified in "bss=xxx" in multi-BSSID case?

You should not create them manually; hostapd will create these for you..
Sure, the type will be NL80211_IFTYPE_AP_VLAN, but you should not need
to know that ;-).

> CLIN: Getting VLAN ID from Radius server means all VLANs must use 802.1x
> way for authentication.

No, it doesn't. But the only other option is to use station MAC address
to VLAN ID mapping, so yes, this has some limitations.

> 1. Most of the time multi-BSSID is superior to multi-SSID. But
> multi-BSSID uses multiple MAC addresses and each radio actually has only
> reserved one MAC address. Meaning, all other MAC addresses used are
> actually reserved by other radio/Ethernet adapter, etc. When product
> like this goes on market, it's bound to have MAC address conflict,
> unless vendor reserves enough MAC for its product. It's kind of a waste
> to reserve 32 (in my case) MAC addresses per radio since most of the
> time multi-BSSID won't be used in SOHO. 

There are costs involved with it, but then again, so there are with
multi-SSID.. I would just refuse to depend on multi-SSID myself because
of interop issues and limitations on what kind of security policies can
be used between the networks sharing the same BSSID.

You can get pretty good results with use of locally administered
addresses, but sure, there is always a possibility of conflict, even if
very unlikely with good address allocation strategy.

> 2. The other thing regarding hostapd dynamic VLAN is that it creates a
> bridge for each VLAN and tag is only added at a certain interface e.g.
> "vlan_tagged_interface=eth0". There are a few problems with this design.

> 	a. One bridge for each VLAN overloads system unnecessarily. It
> means that all protocols over bridge have to run multiple copies, one
> per bridge. This is expensive for embedded devices.

Keep in mind that CONFIG_FULL_DYNAMIC_VLAN is optional functionality..
If you don't want it, don't enable it.

> 	b. In case there multiple interfaces need vlan tag, does hostapd
> allow me to put multiple interfaces in "vlan_tagged_interface=xxx"
> option? Even if it allows that, it's still inconvenient if the interface
> list is dynamic. My current product has one bridge which encloses 
> one Ethernet port, 
> AP/VLAN interface, 
> and multiple(dynamic, auto detect by proprietary app) WDS interfaces. 

I would assume that you can simulate something similar by providing a
some scripts for managing how the interfaces get linked together and not
using hostapd to manage the VLAN interfaces at all.

> Only AP/VLAN interface adds/removes/checks VLAN tag per SSID, while all
> other interfaces in the bridge pass packet as is (In other words, they
> behave as VLAN trunk ports). Eventually, it's up to the VLAN switch
> attached at the Ethernet port to distribute packet per VLAN rules. It
> seems hard for me to use current (mac80211, hostapd, iw, etc) to achieve
> what I need.

I'm not sure whether I would fully agree with that, but sure, it may not
currently provide everything you need. Anyway, it should be possible to
extend this as needed..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
