Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1925 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1JQUiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 16:38:08 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: =?iso-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 17 Oct 2011 13:37:56 -0700
Subject: RE: brcmfmac driver implementation: Questions
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0DF4A03E@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20111017_223811_945261_89A96023)
References: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
In-Reply-To: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sent: maandag 17 oktober 2011 19:59
> 
> Hi all,
> 
> I would like to test some custom powersaving algorithms for 802.11abg
> WLANs on some current android smartphone (e.g., nexus one). My
> question is regarding the brcmfmac driver implementation for BCM4329
> chipsets:
> 
> * The current open source implementation of the driver, brcmfmac, does
> ONLY support 11n PHY?

Yes. It supports the bcm4329 device which comes with a 11n phy, which
can connect to a non-11n AP without problems.

> * Does this driver interfaces the mac80211 operations or "acts as" a
> mac80211 driver itself talking to cfg80211/nl80211?

The brcmfmac does not require mac80211, but interfaces with cfg80211.

> * Does the chipset/current implementation support sleep/awake
> triggers? (or at least quiet elements?)

Nope. All powersaving the device does is done on the device as it
knows best what parts of the device can be put to sleep. Who or what
is going to fire those triggers?

> Thanks for your answer,
> Andrés

Hope that helps. 

Gr. AvS

