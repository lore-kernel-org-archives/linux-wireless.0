Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37539 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZCXPD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 11:03:29 -0400
Received: by bwz17 with SMTP id 17so2261188bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 08:03:26 -0700 (PDT)
To: "Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: wireless powersaving (in NM?)
References: <1237891149.4320.73.camel@johannes.local>
	<1237902786.4320.92.camel@johannes.local>
	<E9954878DD1FB34FAE5187FB88C58A3546DA95D4@orsmsx506.amr.corp.intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Mar 2009 17:03:24 +0200
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3546DA95D4@orsmsx506.amr.corp.intel.com> (Wey-Yi W. Guy's message of "Tue\, 24 Mar 2009 07\:47\:46 -0700")
Message-ID: <8763hzq7yb.fsf@litku.valot.fi> (sfid-20090324_160333_006399_247E410F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com> writes:

> Hi Johannes,

Hello,

> Especially for Netbook and Handle devices with newer processor.
> Putting system into lower C-state and having longer battery life is
> very important. I think letting driver making the default choice based
> on the power source is the right way to go, but always can be
> overwritten by upper layer (mac80211 or NM?).

You mean that the driver knows if the AC is connected or not?
Definitely not, the AC connection logic is a policy decision and needs
to be in userspace. It should not be in kernel, it would just
complicate the implementation.

> I do not think we need to expose all the power levels to user space;
> those should be internal decision (mac80211 or driver). User space can
> make the choice of turn power saving mode on/off and leave the detail
> decision to the lower layer which has better knowledge of how to
> balance the power and performance.

mac80211 or the driver doesn't have all the needed knowledge. For
example, how to enable more aggressive power save when the display is
off? The driver certainly doesn't (and shouldn't) know that.

-- 
Kalle Valo
