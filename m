Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:47717 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab1HYIxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 04:53:19 -0400
Date: Thu, 25 Aug 2011 10:53:00 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Henry Ptasinski" <henryp@broadcom.com>
Cc: "Jonas Gorski" <jonas.gorski@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110825105300.727a4a87@milhouse> (sfid-20110825_105323_383381_05600482)
In-Reply-To: <20110825002032.GA7577@broadcom.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
	<20110825002032.GA7577@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 24 Aug 2011 17:20:33 -0700
"Henry Ptasinski" <henryp@broadcom.com> wrote:

> I believe the only SB bus functions that brcmfmac uses are the core reset and
> disable functions, and only when initializing the chip to download firmware
> (all other management of the bus is handled by the on-chip CPU).  Is it
> possible to use those funtions from ssb, without the ssb module trying to
> manage the bus?

If that is really the case, why do we care about linking to ssb anyway?
Those functions are less than 100 lines of code. Just copy and paste them.
There's no point in making them work without the ssb core and then linking
the whole unused ssb core to the driver.

-- 
Greetings, Michael.
