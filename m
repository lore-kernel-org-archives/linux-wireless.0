Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42510 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796Ab2FBSbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 14:31:03 -0400
Message-ID: <4FCA5BCE.8080104@openwrt.org> (sfid-20120602_203133_957012_0F02A059)
Date: Sat, 02 Jun 2012 20:30:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix a WARNING in suspend/resume
 with IBSS
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com> <1338533070.4884.4.camel@jlt3.sipsolutions.net> <4FC86AB4.9020602@qca.qualcomm.com> <1338534832.4884.7.camel@jlt3.sipsolutions.net> <4FCA30DE.4080805@qca.qualcomm.com> <1338659135.12823.3.camel@jlt3.sipsolutions.net> <CAHD-aq+wyT2Rm-uYaA34Wspm1+J79=eyCbpiD=T4ti3Bv-MP9g@mail.gmail.com>
In-Reply-To: <CAHD-aq+wyT2Rm-uYaA34Wspm1+J79=eyCbpiD=T4ti3Bv-MP9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-02 8:14 PM, Guido Iribarren wrote:
> On Sat, Jun 2, 2012 at 2:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> The sets are mutually exclusive, and there are implied sets of each
>> interface with a max number of 1. So for example, in iwlwifi we don't
>> advertise IBSS in the combinations at all, because it's not compatible
>> with anything. In your case, I think the same applies, since you said
>>
>>        if the first interface is ADHOC we cannot have any other
>>        interface. we cannot add an ADHOC interface if there is already
>>        an interface is present
> 
> I've been following the thread and still can't get this confusion out
> of my head:
> i'm currently using kernel 3.3.2 (openwrt trunk r31439), with Atheros
> AR9285 and i can succesfully combine IBSS interface with AP or STA
> modes...
> 
> # iw dev
> phy#0
> 	Interface wlan0-1
> 		ifindex 11
> 		type AP
> 	Interface wlan0-2
> 		ifindex 10
> 		type IBSS
> 	Interface wlan0
> 		ifindex 9
> 		type AP
> 
> So, does this patch mean this functionality will be lost in future
> versions of ath9k?
> or maybe it is officially unsupported and openwrt has patches applied?
> or, even worse, I completely misunderstood what you're talking about?
> (in that case i'm sorry for the noise)
It's officially unsupported, OpenWrt has patches to enable it.

- Felix
