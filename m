Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42698 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3CHUp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 15:45:28 -0500
Date: Fri, 8 Mar 2013 15:34:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask
 that don't include chain 0
Message-ID: <20130308203451.GA402@tuxdriver.com> (sfid-20130308_214536_724878_ED367BEB)
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org>
 <5138A4C8.7040500@neratec.com>
 <5138AB4A.7000405@openwrt.org>
 <5138B656.5090408@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5138B656.5090408@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 07, 2013 at 04:46:30PM +0100, Wojciech Dubowik wrote:
> On 03/07/2013 03:59 PM, Felix Fietkau wrote:
> >On 2013-03-07 3:31 PM, Wojciech Dubowik wrote:
> >>There is a regression introduced by this patch when power save is off on
> >>the station for idle checks.
> >>I have AR9590 station with rx and tx chain set to 0x1 connected
> >>to legacy AP (based on Ar9390) with RF cable and 40dB attenuator.
> >>
> >>Before this patch in connection polling the station was properly sending
> >>null function to check whether AP is still there. After this patch it sends
> >>broadcast probe request which is anyway wrong or some 16 or so packets
> >>of random data (rarely). It manifests itself in lost connection because
> >>there
> >>is no ack from AP which is expected for null function.
> >>
> >>I have been following skb's up to the descriptor setting in ath9k and it was
> >>all ok i.e. proper null function with valid addresses.
> >>
> >>I have been bisecting it twice because it doesn't make much sense but maybe
> >>it's a HW issue?
> >You're right, it does not make much sense. I can't figure out how this
> >patch could possibly change the runtime behavior with tx chainmask set
> >to 0x1. Have you tried reverting this patch in a current build to see if
> >that fixes the issue?
> It does fix it. I will check tomorrow whether it's only AR9590 or also
> previous revisions. I will also try with different chainmasks. I will have
> to rescrew my setup...

Do I need to revert this one?  Or is there a new fix coming?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
