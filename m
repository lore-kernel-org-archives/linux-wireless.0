Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbXLNNAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 08:00:30 -0500
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
From: Dan Williams <dcbw@redhat.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20071214134918.275E.MOKUNO@sm.sony.co.jp>
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp>
	 <1197580418.14270.6.camel@localhost.localdomain>
	 <20071214134918.275E.MOKUNO@sm.sony.co.jp>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 07:58:47 -0500
Message-Id: <1197637127.16724.1.camel@localhost.localdomain> (sfid-20071214_130039_161128_F248072C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-14 at 14:03 +0900, Masakazu Mokuno wrote:
> On Thu, 13 Dec 2007 16:13:38 -0500
> Dan Williams <dcbw@redhat.com> wrote:
> 
> > One more question; does the driver work with wpa_supplicant for WPA, or
> > does the firmware capture the EAPOL frames and handle the 4 way
> > handshake internally?  Ideally the firmware would have the ability to
> > pass those frames up unmodified so the driver would at least have a
> > _hope_ of 802.1x capability.  Does the firmware handle Dynamic WEP at
> > all?
> > 
> > Basically, what happens when the AP you've just associated with starts
> > sending you EAPOL traffic to start the 802.1x process?
> 
> The PS3 wireless device does the association and 4way handshake in its
> firmware/hypervisor.  No interventions between them are allowed to the guest
> OSes.  
> All frames which are sent/received from/to before the connection process
> completed seems to be dropped by the hardware.  Only the static WEP is
> supported.

That sort of sucks; but I guess there's not too much you can do about
it.  That probably means that using wpa_supplicant + WPA is completely
out of the picture, which unfortunately makes the PS3 wireless unlike
any other card, which would require special-casing the PS3 in userspace
tools.

Dan


