Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:51399 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbXLNFEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 00:04:43 -0500
Date: Fri, 14 Dec 2007 14:03:13 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1197580418.14270.6.camel@localhost.localdomain>
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp> <1197580418.14270.6.camel@localhost.localdomain>
Message-Id: <20071214134918.275E.MOKUNO@sm.sony.co.jp> (sfid-20071214_050453_884616_1AF06D79)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 13 Dec 2007 16:13:38 -0500
Dan Williams <dcbw@redhat.com> wrote:

> One more question; does the driver work with wpa_supplicant for WPA, or
> does the firmware capture the EAPOL frames and handle the 4 way
> handshake internally?  Ideally the firmware would have the ability to
> pass those frames up unmodified so the driver would at least have a
> _hope_ of 802.1x capability.  Does the firmware handle Dynamic WEP at
> all?
> 
> Basically, what happens when the AP you've just associated with starts
> sending you EAPOL traffic to start the 802.1x process?

The PS3 wireless device does the association and 4way handshake in its
firmware/hypervisor.  No interventions between them are allowed to the guest
OSes.  
All frames which are sent/received from/to before the connection process
completed seems to be dropped by the hardware.  Only the static WEP is
supported.


-- 
Masakazu MOKUNO

