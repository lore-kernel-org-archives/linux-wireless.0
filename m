Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39430 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754734AbXFUMgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 08:36:00 -0400
Date: Thu, 21 Jun 2007 14:35:58 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070621143558.68fc8e4a@griffin.suse.cz>
In-Reply-To: <1182418939.10821.8.camel@johannes.berg>
References: <1182418939.10821.8.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Jun 2007 11:42:19 +0200, Johannes Berg wrote:
> This patch kills the management interface type now that we can
> see transmitted frames on monitor interfaces.
> 
> I renamed the req_tx_status to reliable_tx_mntr and the flag
> constant as well since that's what they now mean. It is always
> set for injected frames so that hostapd can rely on seeing the
> frames it sent.

I have two comments.

1. I'm still not sure if using monitor interface for this purpose is a
good idea. Given the fact we want to switch to user space MLME, this
will mean that at least one monitor interface is always present. So we
got rid of management interface just to introduce another user visible
magic interface.

2. How is hostapd (or other programs) supposed to connect frames
returned on monitor interface with frames it sent? Does it need to
remember each sent frame and compare it with the ones received through
the monitor interface? (It probably wouldn't work anyway because of seq
numbers, sw encryption, etc).

Maybe allowing to put some stamp on injected frames (in a radiotap
header?) and keep the stamp in frames returned through monitor
interface (again, in the radiotap header?) would solve all those
problems. When the stamp field is not present, the frame needs not to
be returned.

But I'd prefer some other solution than using monitor interface for
this stuff.

> There are a few minor remaining problems:
>  * some notifications are now missing
>    (radar, key threshold, michael MIC failure, wep unknown key)
>    [radar, key threshold aren't used anywhere so can probably
>     be left out for now]
>  * injected frames aren't sent to AC_VO pending on the radiotap
>    definition for access category
>  * rate control extra.mgmt_data isn't properly assigned
> 
> The biggest problem, however, and I'm not sure how to solve it, is
> that hostapd will see either encrypted or unencrypted frames on the
> monitor interface depending on whether hardware encryption is used
> or not. However, hostapd really needs to see eapol frames to do
> whatever it needs to with them. Right now, I don't really have an
> idea except maybe to send these packets to hostapd via nl80211,
> or to introduce some sort of "decrypted soft monitor" iface.

Using stamps (independent of the mechanism used for handing frames from
and to user space MLME) could solve this.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
