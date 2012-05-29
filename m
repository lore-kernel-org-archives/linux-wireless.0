Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59144 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2E2TH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 15:07:56 -0400
Received: by bkcji2 with SMTP id ji2so3378915bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 12:07:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
Date: Tue, 29 May 2012 21:07:42 +0200
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4FC04B5A.1070900@candelatech.com> <4FC2437C.9090106@candelatech.com> <4FC51418.5000104@candelatech.com>
In-Reply-To: <4FC51418.5000104@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205292107.42337.chunkeey@googlemail.com> (sfid-20120529_210800_547061_4AB58940)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, May 29, 2012 08:23:20 PM Ben Greear wrote:
> On 05/27/2012 08:08 AM, Ben Greear wrote:
> > On 05/26/2012 09:39 AM, Sujith Manoharan wrote:
> We started testing with two AR9380 NICs today (one AP, the other STA).
> I applied Felix's skb optimization patch, and the ath9k memleak fix patch
> on top of 3.3.7+.
>
> The system has 2GB RAM, but it is 32-bit kernel, so not all
> is available to the networking code...  That said, the OOM
> killer kills VNC and such.
> 
> Anyway, I'll try some memleak debugging to see if
> I can find any leaks.  It seems to me that we should
> not actually OOM just by trying to transmit too fast
> on a station interface :P
well, there's that:
http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/8233

It might not fix the bug, but it can save you time to confirm
that is not related to this particular skb leak.

Regards,
	Chr
