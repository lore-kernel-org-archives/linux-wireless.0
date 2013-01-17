Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47702 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3AQRQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 12:16:21 -0500
Received: by mail-bk0-f53.google.com with SMTP id j5so1509209bkw.40
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 09:16:20 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
Date: Thu, 17 Jan 2013 18:16:15 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ivdoorn@gmail.com, gwingerde@gmail.com, stf_xl@wp.pl,
	andihartmann@01019freenet.de,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301171816.15309.chunkeey@googlemail.com> (sfid-20130117_181626_507402_29A35013)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 17, 2013 05:34:32 PM Helmut Schaa wrote:
> Since rt2800 hardware isn't capable of reporting the TX status of
> BlockAckReq frames implement the TX status handling of BARs in
> rt2x00lib. We keep track of all BARs that are send out and try to
> match incoming BAs to the appropriate BARs. This allows us to report a
> more or less accurate TX status for BAR frames which in turn improves
> BA session stability.
---
What about:
> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Mon Dec 3 12:56:33 2012 +0100
> mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL

Should it be kept or dropped (as no driver uses it anymore?)

Regards,
	Chr
