Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52350 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab1IMRp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:45:27 -0400
Date: Tue, 13 Sep 2011 13:44:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
Message-ID: <20110913174444.GG11772@tuxdriver.com> (sfid-20110913_194531_636990_518B7BA5)
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 12, 2011 at 11:27:20PM +0200, Rafał Miłecki wrote:

> The problem is that brcmsmac duplicates code present in the bcma
> driver. It doesn't use bcma bus architecture.
> 
> The real solution is to add bcma driver support in brcmsmac and ssb
> driver support in brcmfmac. Then you can always use bcma and:
> 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
> 2) brcmsmac will be loaded to let it support the core

We are going to have to find a way to get brcmsmac into the
wireless-next tree to make it feasible for the Broadcom guys to get
bcma support into that driver.  Do you agree?

We could move it under the drivers/net/wireless tree.  Or, maybe I
could negotiate with Greg to keep it under the drivers/staging tree
but to let me manage it under wireless-next.  Or...?  Do you have
any thoughts on this?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
