Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43287 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab2FOVJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 17:09:17 -0400
Message-ID: <4FDBA47B.7070709@openwrt.org> (sfid-20120615_230925_824854_60AC6D69)
Date: Fri, 15 Jun 2012 23:09:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 5/9] ath9k_hw: remove the old ANI implementation
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org> <1339766727-61926-2-git-send-email-nbd@openwrt.org> <1339766727-61926-3-git-send-email-nbd@openwrt.org> <1339766727-61926-4-git-send-email-nbd@openwrt.org> <1339766727-61926-5-git-send-email-nbd@openwrt.org> <20120615175810.GC648@vmraj-lnx.qca.qualcomm.com>
In-Reply-To: <20120615175810.GC648@vmraj-lnx.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-15 7:58 PM, Rajkumar Manoharan wrote:
> On Fri, Jun 15, 2012 at 03:25:23PM +0200, Felix Fietkau wrote:
>> It was found to be buggy on a variety of chipsets from AR913x to AR928x.
>> The new version (which was introduced along with AR93xx support) is more
>> reliable in preventing connectivity dropouts and also fixes MIB interrupt
>> storm issues.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> I dont think it is good idea to completely removing old ANI for all AR9002
> family chips. No one have ever tested the new ANI with all ar9002 chips. May
> be there could be some regressions with old ANI. As we discussed in irc did
> you get any feedback from openwrt users with partial revert patch? So it is
> not viable to wipe out old ani support for older chips.
Several OpenWrt users have tested this on various AR9001 and AR9002
devices and have reported a very significant increase in stability in a
variety of environments. Sure, this needs a bit more testing, but the
old code is known broken in many ways, yet at the same time a bit too
convoluted for proper bug analysis.
I think removing the old code is our best option for having a chance to
again be able to fully understand the code and its various side effects.
Leaving the old code in place just makes it more likely for regressions
to show up when the new code is improved (as has already happened on
several occasions).

- Felix
