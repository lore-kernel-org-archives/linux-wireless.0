Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:49770 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbaLYJLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2014 04:11:04 -0500
Date: Thu, 25 Dec 2014 11:10:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
Subject: Re: hostapd and 11h support
Message-ID: <20141225091059.GA3436@w1.fi> (sfid-20141225_101113_307450_80755090)
References: <549A8827.3070703@broadcom.com>
 <20141224173227.GA1969@w1.fi>
 <549B05F0.9020704@broadcom.com>
 <20141224190452.GA6933@w1.fi>
 <549B24A9.4080001@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549B24A9.4080001@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2014 at 09:40:09PM +0100, Arend van Spriel wrote:
> On 12/24/14 20:04, Jouni Malinen wrote:
> >I see nothing odd in other drivers using the already defined QCA vendor
> >specific nl80211 command.
> 
> Maybe not odd but counter-intuitive to some people.

Maybe so, but certainly not on purpose. It has to be a specific OUI and
as such, assigned to someone.. This one happens to be coordinated in a
way that all (non-MAC address) assignments get done by upstream
hostap.git commits. In other words, there is no intent of trying to
limit it to a single vendor, but to have something that is easily usable
for hostapd/wpa_supplicant extensions in cases where upstream nl80211
extensions for needed functionality are not acceptable for some reason
at the time.

> Anyway, I was
> looking at the code in driver_nl80211_capa.c and stumbled upon
> WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD. I introduced entensible feature
> flags upstream just yesterday to accomodate this type of offload.
> Just curious but are those QCA vendor specific nl80211 commands used
> by the upstream QCA drivers or is this for supporting QCA
> proprietary drivers. I guess the latter as that would be the only
> reason I can think of to have vendor specific commands.

This is currently used by an open source, but not upstream, driver.
There was actually an attempt to get this done in standard nl80211
commands/events, but the response was not exactly encouraging with no
existing upstream driver to show as a user for the new functionality.
I'd still like to get this done cleanly in nl80211 at some point in
time, though, since extensions to Connect command/event are not possible
using the vendor specific commands/events, i.e., you end up having to
fully override these commands/events which gets ugly pretty quickly.

-- 
Jouni Malinen                                            PGP id EFC895FA
