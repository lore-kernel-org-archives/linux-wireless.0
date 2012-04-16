Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2DPUxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:53:22 -0400
Date: Mon, 16 Apr 2012 15:53:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
Message-ID: <20120416205317.GD3959@thinkpad-t410> (sfid-20120416_225325_793339_B7CB5CEC)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <4F8C841F.3030908@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8C841F.3030908@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 10:42:07PM +0200, Arend van Spriel wrote:
> >I've attempted to maintain the same high-level behavior that the
> >brcmsmac internal regulatory support currently enforces. I find a couple
> >of these to be questionable however, those being: the setting of the
> >radio disable state based on whether or not there are any channels
> >allowed by regulatory, and the handling of enabling/disabling OFDM.
> >Perhaps you can comment on whether or not these actions are needed.
> 
> Regarding questionable things, you mean the transmit mute or is
> there another radio disable that I have not found yet. I only recall
> that channel 14 (JP only) does not allow OFDM so it may be to
> accommodate that. It may not be explicitly needed as mac80211
> provides the rate and/or modulation to use for the transmit frame.

I'm referring to radio_disabled in struct brcms_pub, specifically to the
setting and clearing of the WL_RADIO_COUNTRY_DISABLE bit in this field.
Patch 5 in the series deals specifically with this functionality.

Btw, I restored setting the transmit mute for passive channels in this
series, which I had to remove in earlier versions of these changes. Your
patch to enable tx after seeing a beacon fixed the issue I was seeing.

> >So far these changes are testing well on a MacBook Air 4,1 with BCM43224
> >wireless. I'm now able to see and associate with my AP on channel 52,
> >which was not possible previously.
> 
> I will try to organize some regulatory testing over here with your patches.

Great, thanks!

Seth

