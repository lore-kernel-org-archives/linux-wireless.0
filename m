Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62138 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3AAXkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jan 2013 18:40:55 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so6325443wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2013 15:40:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E2FE5E.6040300@openwrt.org>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
	<CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>
	<CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>
	<50E2FE5E.6040300@openwrt.org>
Date: Tue, 1 Jan 2013 15:40:54 -0800
Message-ID: <CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com> (sfid-20130102_004100_632588_8591FE4F)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 January 2013 07:18, Felix Fietkau <nbd@openwrt.org> wrote:

> I think the best way to properly fix this issue is to implement NAPI
> support (which mac80211 already supports).

Sure, but there may be some underlying issues (maybe even on just that
particular platform) that need to be addressed.

Migrating to NAPI / breaking out of the tasklet early should also be
done, but it's potentially orthogonal to the OP's problem.


Adrian
