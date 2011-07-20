Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47850 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GTL6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:58:24 -0400
Message-ID: <4E26C2DC.8090208@qca.qualcomm.com> (sfid-20110720_135833_334075_A3424E60)
Date: Wed, 20 Jul 2011 14:58:20 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ethtool: fix ethtool_get_regs() to work with zero length
 registers
References: <20110720091850.32210.2059.stgit@localhost6.localdomain6> <1311161889.1041.11.camel@localhost>
In-Reply-To: <1311161889.1041.11.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2011 02:38 PM, Ben Hutchings wrote:
> On Wed, 2011-07-20 at 12:18 +0300, Kalle Valo wrote:
>> cfg80211 exports zero length register size as it currently only uses
>> struct ethtool_regs.version to export struct wiphy.hw_version.
> [...]
> 
> The ethtool_regs::version field represents the version of the register
> dump format.  This may or may not relate to a hardware version.
> 
> If you don't actually provide a register dump then don't implement this
> operation.

Then we have a problem as cfg80211 exports the hw version without any
register dumps:

static int cfg80211_get_regs_len(struct net_device *dev)
{
	/* For now, return 0... */
	return 0;
}

static void cfg80211_get_regs(struct net_device *dev, struct
ethtool_regs *regs,
			void *data)
{
	struct wireless_dev *wdev = dev->ieee80211_ptr;

	regs->version = wdev->wiphy->hw_version;
	regs->len = 0;
}

And this has been there a long time already. How cfg80211 should export
hw version if this is not a proper way?

Kalle
