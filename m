Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47163 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1HWWOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 18:14:43 -0400
Received: by fxh19 with SMTP id 19so571635fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 15:14:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bill Jordan <bjordan@rajant.com>
Subject: Re: [PATCH] ath9k: fix MGMT packets when using TKIP
Date: Wed, 24 Aug 2011 00:14:31 +0200
Cc: Kalle Valo <kvalo@adurom.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
References: <4E4C6258.1030409@openwrt.org> <87wre5oogs.fsf@purkki.adurom.net> <CAFKp-_cabGjejG1Mbzcof5jikyOcfYs=4SBLoP3LG=9xALERhw@mail.gmail.com>
In-Reply-To: <CAFKp-_cabGjejG1Mbzcof5jikyOcfYs=4SBLoP3LG=9xALERhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108240014.31436.chunkeey@googlemail.com> (sfid-20110824_001449_191132_F444EED9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 23, 2011 11:59:51 PM Bill Jordan wrote:
> On Mon, Aug 22, 2011 at 4:11 AM, Kalle Valo <kvalo@adurom.com> wrote:
> > Bill Jordan <bjordan@rajant.com> writes:
> >
> >> Prevent 8 bytes from being truncated from MGMT packets
> >> when using TKIP.
> >
> > A bit more information in the commit log would be nice. Is this is a
> > regression or an old bug? Maybe a stable candidate?
> 
> I believe it is an old bug.
No it's not. It was introduced by:

commit 66760eac005d569393bac34136bcbb8af55d8a5a
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Wed Jul 13 23:35:05 2011 +0800

    ath9k: improve reliability of MIC error detection

