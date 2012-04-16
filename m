Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3222 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2DPUmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:42:16 -0400
Message-ID: <4F8C841F.3030908@broadcom.com> (sfid-20120416_224229_573420_C4E7F1D0)
Date: Mon, 16 Apr 2012 22:42:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> Hi Arnd,
>
> Here's the latest update to the brcmsmac regulatory rework that I've
> been working on. I've broken it up into a series of smaller patches,
> cleaned things up, and finished what changes I can with the information
> available to me.

I will go through the individual patches and comment on them. This code 
could use some cleanup so it is appreciated.

> I've attempted to maintain the same high-level behavior that the
> brcmsmac internal regulatory support currently enforces. I find a couple
> of these to be questionable however, those being: the setting of the
> radio disable state based on whether or not there are any channels
> allowed by regulatory, and the handling of enabling/disabling OFDM.
> Perhaps you can comment on whether or not these actions are needed.

Regarding questionable things, you mean the transmit mute or is there 
another radio disable that I have not found yet. I only recall that 
channel 14 (JP only) does not allow OFDM so it may be to accommodate 
that. It may not be explicitly needed as mac80211 provides the rate 
and/or modulation to use for the transmit frame.

> All use of the internal regulatory data has been eliminated except for
> the use of the MIMO power limits for filling out the txpwr_limits data.
> I'm anticipating that you'll provide information on how this needs to be
> handled. Otherwise I think these patches are very nearly complete, so
> please let me know if you see anything that needs to be changed.

I asked for this internally, but I do not recall getting an answer. I 
will make another attempt.

> So far these changes are testing well on a MacBook Air 4,1 with BCM43224
> wireless. I'm now able to see and associate with my AP on channel 52,
> which was not possible previously.

I will try to organize some regulatory testing over here with your patches.

Gr. AvS

