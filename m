Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2812 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1HYAVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 20:21:03 -0400
Date: Wed, 24 Aug 2011 17:20:33 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110825002032.GA7577@broadcom.com> (sfid-20110825_022110_647900_EFCA12EA)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 04:41:54PM -0700, Jonas Gorski wrote:
> Hi Henry,
> 
> On 25 August 2011 00:28, Henry Ptasinski <henryp@broadcom.com> wrote:
> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> > once again propose moving brcm80211 out of staging and into mainline.
> 
> While I like the Idea of brcm80211 going mainline, I'd like to throw
> in the suggestion that brcm80211 should be made a bcma/ssb driver
> first (AFACT brcmfmac would use ssb, not bcma, therefore both).
> 
> My reasoning is that it needs to be done eventually anyway, and the
> earlier this is done the less work it will be in the long term, also
> it would reduce the duplicate code in bcma, ssb, and brcm80211.
> 
> Of course this is just a suggestion, and it's yours and Greg's call
> whether you agree with me or not (since it's quite late in the game to
> add a new TODO, and I suspect a rather big one).

We started converting brcmsmac to bcma, but bcma is evolving rapidly in the
wireless-testing tree.  Since wireless-testing and staging-next only get in
sync during a kernel merge, the version of bcma we have to work with in staging
is usually quit outdated.  Unless Greg and John want to come up with a process
for keeping bcma consistent between their two repos, I don't really see how we
can productively use bcma until we cross over.  We do intend to switch to using
bcma as soon as possible.

I believe the only SB bus functions that brcmfmac uses are the core reset and
disable functions, and only when initializing the chip to download firmware
(all other management of the bus is handled by the on-chip CPU).  Is it
possible to use those funtions from ssb, without the ssb module trying to
manage the bus?

- Henry

