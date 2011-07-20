Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37105 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1GTUAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 16:00:11 -0400
Message-ID: <4E2733BC.3070309@gnu.org> (sfid-20110720_220015_879839_4EB1E303)
Date: Wed, 20 Jul 2011 15:59:56 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] ath5k: merge ath5k_hw and ath5k_softc
References: <20110715002155.14332.3527.stgit@mj.roinet.com> <CAFtRNNy3SvLXUJ8uaOibGfnynS7gwCOMW2x=cLhfPDf9aNw4vQ@mail.gmail.com> <CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
In-Reply-To: <CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2011 06:19 AM, Sedat Dilek wrote:

> I have tested this patch on top of linux-next (next-20110720) and it fails:

The patch is for wireless-testing.

> In file included from
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/drivers/net/wireless/ath/ath5k/caps.c:24:0:
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/drivers/net/wireless/ath/ath5k/ath5k.h:1072:24:
> error: field 'toggleq' has incomplete type

It looks like ath5.h needs to include linux/interrupt.h, which is 
currently included by base.h.

linux-next is stricter about the includes than wireless-testing.  Let's 
not break linux-next, as someone else will need to fix it.

I'll send another version of the patch, tested both on wireless-testing 
and linux-next.

-- 
Regards,
Pavel Roskin
