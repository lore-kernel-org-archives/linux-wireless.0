Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4411 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab1HZR6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 13:58:55 -0400
Date: Fri, 26 Aug 2011 10:58:44 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Jonas Gorski" <jonas.gorski@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110826175844.GH4888@broadcom.com> (sfid-20110826_195859_014907_28B37872)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
 <20110825002032.GA7577@broadcom.com>
 <CAOiHx=narxG2WG1+8jDTah=u=XQ337K7UZZgd8Fv9xksufkEKw@mail.gmail.com>
 <CACna6rxRG_yPsCMG3tNTiHp5GratUn8qYiDYKxa85vuaBLjCtw@mail.gmail.com>
 <CACna6rzhr_OryaAEHwW+NcjrMq+xAZVOxPOJLto5w9rXWeosvw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACna6rzhr_OryaAEHwW+NcjrMq+xAZVOxPOJLto5w9rXWeosvw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 02:09:47PM -0700, Rafał Miłecki wrote:
> Also what about embedded devices? Shouldn't we have core drivers for
> them? I mean, to be able to easily choose driver for a given core?
> 
> Let's say I want to use some ssb-core-based driver for Ethernet port
> (like gige) but I also want to use brcmsmac fo 80211. Is that possible
> without brcmsmac using bcma?

Since brcmsmac doesn't attempt to claim any ssb-based devices, why would there
be any conflict between an ssb-based Ethernet device and a brcmsmac device?

The ssb driver claims the ssb-based devices, and brcmsmac only claims the
AI-based chips that it supports.

There is currently a conflict between bcma and brcmsmac (hence the restriction
in drivers/staging/brcm80211/Kconfig), but, as I've said several times, we want
to move to using bcma as soon as possible.  But we need to work with the
current version of bcma, which isn't available in staging.

- Henry


