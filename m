Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYHNS26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 14:28:58 -0400
Subject: Re: Pondering: how to improve mac80211 roaming ...
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080814082519.GI4981@jm.kir.nu>
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
	 <20080812082246.GD4981@jm.kir.nu> <87skt86pqg.fsf@nokia.com>
	 <20080814082519.GI4981@jm.kir.nu>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 14:30:18 -0400
Message-Id: <1218738618.22939.11.camel@localhost.localdomain> (sfid-20080814_202902_541256_CE17A6D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-08-14 at 11:25 +0300, Jouni Malinen wrote:
> On Thu, Aug 14, 2008 at 10:05:27AM +0300, Kalle Valo wrote:
> 
> > What about PMKSA caching? Shouldn't user space need to provide PMKIDs
> > (or the IEs) to mac80211 before association?
> 
> There are two possible designs for this. In wpa_supplicant terms,
> ap_scan=2 would most likely mean that driver is responsible for
> generating the RSN IE, including PMKID list, and wpa_supplicant is
> providing the driver a list of currently available PMKs (PMKIDs for
> them). In ap_scan=1, there is option for the driver to use the RSN IE
> from wpa_supplicant (which is something that mac80211 is doing at the
> moment) and in that case, yes, PMKIDs would indeed need to be updated
> in the RSN IE just before association.

The problem with ap_scan is that it really has two uses: roaming (it's
original meaning) and hidden SSID support (the acquired meaning because
of WEXT command ordering issues and lack of SSID scan support).

It's important to note that historically, mac80211 has completely failed
with ap_scan=2 and I'm not sure it's worth fixing that because effort
should be directed into cfg80211.

So if you're going to suggest that people should actually start using
roaming support and fixing it up, we need to figure out how to do
scanning better in the supplicant config too.

Dan


