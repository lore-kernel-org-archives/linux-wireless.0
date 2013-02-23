Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2399 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3BWRsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 12:48:19 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Adrian Chadd" <adrian@freebsd.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: RE: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
Date: Sat, 23 Feb 2013 17:47:48 +0000
Message-ID: <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com> (sfid-20130223_184825_581362_59F667DE)
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
 <1361564916.3420.11.camel@jlt4.sipsolutions.net>,<CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
In-Reply-To: <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, February 23, 2013 1:30 AM Adrian Chadd wrote:
>
> ... why not tag such traffic with a higher QOS priority and then have
> the BT coex module snoop thaT?
>

In the driver we could inspect each sk_buff and boost priority of any BOOTP packets so that it will end up in the AC_VO fifo and have hardware coexistence handle it further. I consider that more a pragmatic fix, which is not always the worst thing to go for. However, I would prefer a solution is which user-space, ie. dhcp client can control the priority and/or BT coexistence.

Gr. AvS
