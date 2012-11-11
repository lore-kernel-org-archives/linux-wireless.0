Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52001 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2KKIPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 03:15:40 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, <j@w1.fi>
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210)
Date: Sun, 11 Nov 2012 10:15:35 +0200
Message-ID: <12645035.o6OUeozobZ@lx-vladimir> (sfid-20121111_091551_377707_B16A0089)
In-Reply-To: <1352450346.9238.9.camel@jlt4.sipsolutions.net>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1351701417-3140-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352450346.9238.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 09, 2012 09:39:06 AM Johannes Berg wrote:
> On Wed, 2012-10-31 at 18:36 +0200, Vladimir Kondratiev wrote:
> > Card wil6210 by Wilocity supports operation on the 60GHz band
> > 
> > This development snapshot supports:
> > 
> > - STA, PCP and monitor modes
> 
> Ok so I have a more fundamental question/comment/issue.
> 
> 802.11ad obviously distinguishes between a regular BSS, IBSS, and the
> new PBSS. We also differentiate between BSS and IBSS in our interface
> types, so I have a feeling that maybe we should also differentiate here,
> and not re-use the NL80211_IFTYPE_AP/... interface types.

Yes, you are absolutely right. Standard says about PBSS (802.11ad draft 9):

---cut---
4.3.2a The Personal BSS (PBSS) as an ad hoc network

Similar to the IBSS, the PBSS is a type of IEEE 802.11 LAN in which STAs 
communicate directly with each other.

In contrast to the IBSS, in the PBSS one STA assumes the role of the PBSS 
control point (PCP). The PCP provides the basic timing for the PBSS through 
DMG Beacon and Announce frames as well as allocation of service periods and 
contention-based access periods.

A PBSS can be established only by DMG STAs. Not every DMG BSS is a PBSS. A DMG 
BSS can be a PBSS, an infrastructure BSS or an IBSS.
---cut---

Right now I do not have patch for this; but yes, it need to be done. I want to 
finish with initial driver submission first, then continue with 
infrastructure. As you mentioned earlier (and yes, I agree), without single 
60g driver infrastructure work have little meaning.

> 
> It seems that then we'd also need a PBSS_P2P_CLIENT and PBSS_P2P_GO,
> which is a bit odd, but then again we also do that for P2P_CLIENT vs.
> normal managed and P2P_GO vs. AP.

This time - not exactly. P2P spec says that in DMG (Direct Multi-Gigabit) 
networks P2P GO is PCP. From P2P spec 1.3 draft 4 (#2.1 P2P components):
---cut---
P2P Group Owner role:
- “AP-like” entity that provides BSS functionality and services for associated  
Clients (P2P Clients or Legacy Clients) in a non-DMG network, or a PCP that 
provides PBSS functionality and services for Clients (P2P Clients) in a DMG 
network.
---cut---
And then, in #3.2 P2P Group operation:
---cut---
P2P Group operation in a DMG network follows PBSS operation as defined in [15]
[16] with the P2P Group Owner assuming the role of the PCP and the P2P Client 
assuming the role of the non-PCP/non-AP STA. Additional mechanisms applicable 
to P2P Group operation in a DMG network are described in this section.
---cut---
So, for P2P it is sufficient to have P2P_GO and P2P_CLIENT. In DMG, spec 
dictates that P2P group is PBSS. P2P supplicant may deduce everything from 
band.

> 
> I'm not sure if we're ever going to see chipsets that have 60GHz and
> 2.4/5 GHz combined, and are not going to just register two wiphy's with
> the system for that, but if there was then this would certainly help
> with interface combinations etc.

Most likely, 60g chips will be accompanied with 2.4/5 GHZ ones. Spec actually 
encourage this; it defines FST (Fast Session Transfer) mechanism to bundle 60g 
with 2.4/5.

FST itself is interesting story, will discuss it later.

> 
> Even if there isn't, it could help tools like network-manager not manage
> the 60 GHz device (without having to add special checks), which I
> suspect is what you'd want? Not really sure though.

Yes, and I am working with Jouni for wpa_supplicant additions.

Sure I want 60g to be managed by the network manager as it does for other 
devices.

It works well right now for PBSS client - I connect using GUI frontend as 
provided by Ubuntu or Fedora. Actually, PBSS client is like BSS one. There is 
some work pending to display PCP (differentiate from AP) in the scan list.

It is correct PBSS need additional work as it should allow for automatic PCP 
selection - it is like simplified P2P. P2P need some work as well. I am 
looking in this direction right now. For P2P, we don't have GUI right now - or 
do I miss something here?

Thanks, Vladimir

> 
> Thoughts?
> 
> johannes
