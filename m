Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:55233 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXLNFIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 00:08:52 -0500
Date: Fri, 14 Dec 2007 14:07:25 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1197560003.2528.36.camel@localhost.localdomain>
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp> <1197560003.2528.36.camel@localhost.localdomain>
Message-Id: <20071214134745.275B.MOKUNO@sm.sony.co.jp> (sfid-20071214_050856_166524_818C0F00)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 13 Dec 2007 10:33:22 -0500
Dan Williams <dcbw@redhat.com> wrote:
> You'll need to emit more NULL IWAP events on association failure.  For
> example, gelic_wl_assoc_worker() should probably send one right before
> both instances of 'goto scan_lock_out' in that function (the first where
> there are no scan results, and the second where no compatible BSS can be
> found).  Also, gelic_wl_associate_bss() needs to send a disassociation
> event in the failure case where it sets GELIC_WL_ASSOC_STAT_DISCONN.

Thank you for your reviewing.

I'll fix and submit revised version in next week.

-- 
Masakazu MOKUNO

