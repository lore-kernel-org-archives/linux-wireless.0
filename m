Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59436 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3CXW6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 18:58:22 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so2139897ead.13
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 15:58:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Robert Shade <robert.shade@gmail.com>
Subject: Re: Auth Packet TX Delay
Date: Sun, 24 Mar 2013 23:58:16 +0100
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Marco Fonseca <marco@tampabay.rr.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com> <CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com> <CAMgrJ3buZxZermRmpUW2r3gYtUmF=3UoEo7NW9VYTkAwS7gdtQ@mail.gmail.com>
In-Reply-To: <CAMgrJ3buZxZermRmpUW2r3gYtUmF=3UoEo7NW9VYTkAwS7gdtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303242358.17133.chunkeey@googlemail.com> (sfid-20130324_235826_314745_80BFEAF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Added Marco and me in the CC - please keep it)

On Sunday, March 24, 2013 11:40:27 PM Robert Shade wrote:
> > Hm, so it's doing some fast channel changes?
> 
> Yes, the fastcc does seem to work, it's just that sometimes the chip
> can get in a bad state when it's not cold reset.
> > Just disable fast channel change entirely and re-test? And why not
> > just force a cold reset always? Why bother checking for the queue to
> > be stopped?
> 
> Just disabling fastcc was not enough, the cold resets are what seemed
> to have made the difference.  I was actually thinking about
> re-enabling fastcc and testing again.
> 
> The TXE/RXE checking path is from felix's "ath9k_hw: improve reset
> reliability after errors" patch.  I've just got the exception in there
> for 9160, since I don't have other hardware to test with.  What do the
> hardware engineers say about warm vs. cold reset?  I did notice that
> your latest ar9300 HAL has a note stating that "Warm reset is
> optimistic."

Marco reported in "carl9170: monitor mode hangs due to channel changes"
<http://www.spinics.net/lists/linux-wireless/msg105100.html> that
carl9170 would stop receiving frames after some time.
I looked a bit closer look and it seems that the fast channel change
for AR9170 also seems to be the culprit in this case.

(It seems that the AGC_CONTROL register is suddenly (re-)set by
something to "0x20" (default is 0x0004dd20) and then everything
stops.)

Regards,
	Christian
