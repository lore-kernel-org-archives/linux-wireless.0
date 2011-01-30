Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61749 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1A3PyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 10:54:07 -0500
Received: by iwn9 with SMTP id 9so4637117iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 07:54:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D439AEA.6020101@candelatech.com>
References: <4D439AEA.6020101@candelatech.com>
Date: Sun, 30 Jan 2011 16:54:05 +0100
Message-ID: <AANLkTinSxnxYdUuQGWRr-fA8HF_JotQfG3S1QWEwS3K=@mail.gmail.com>
Subject: Re: ath9k: Still seeing DMA issues in latest wireless-testing.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 29, 2011 at 5:43 AM, Ben Greear <greearb@candelatech.com> wrote:
> Looks like some potentially nice ath9k patches just got merged into
> wireless-testing.  It has been stable and fast so far, but I
> do still see DMA issues in the logs.
>
> This is on a system with 30 STAs associated with a flakey netgear running
> HT40-, and 30 associated with a cisco running HT20.  (Through some luck,
> the netgear managed to send proper ht-info channel this time,
> so the NIC went HT40-).

Ben, the fact that you see much more of these DMA issues when you're
running your virtual STAs suggests to me that root cause is some race
condition between dma and cpu. The main difference between the 60 STA
use-case and the one STA use case is that rx irq processing will take
longer with multiple STAs, right? Is there some other difference?

/Björn
