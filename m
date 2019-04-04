Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E54C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FAB6206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfDDQwa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:52:30 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:46038 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfDDQwa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:52:30 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hC5b8-0006NC-9X; Thu, 04 Apr 2019 18:52:18 +0200
Date:   Thu, 4 Apr 2019 18:52:17 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Fenghua Yu' <fenghua.yu@intel.com>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        'Dave Hansen' <dave.hansen@intel.com>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Michael Chan' <michael.chan@broadcom.com>,
        'Ravi V Shankar' <ravi.v.shankar@intel.com>,
        'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 04/20] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
In-Reply-To: <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.21.1904041833480.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-5-git-send-email-fenghua.yu@intel.com> <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com> <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1812670699-1554396738=:1802"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1812670699-1554396738=:1802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 4 Apr 2019, David Laight wrote:
> From: David Laight Sent: 04 April 2019 15:45
> > From: Fenghua Yu Sent: 03 April 2019 22:22
> > That is not true.
> > The BTS/BTR instructions access the memory word that contains the
> > expected bit.
> > The 'operand size' only affects the size of the register use for the
> > bit offset.
> > If the 'operand size' is 16 bits wide (+/- 32k bit offset) the cpu might
> > do an aligned 16bit memory access, otherwise (32 or 64bit bit offset) it
> > might do an aligned 32 bit access.
> > It should never do an 64bit access and never a misaligned one (even if
> > the base address is misaligned).
> 
> Hmmm... I may have misread things slightly.
> The accessed address is 'Effective Address + (4 ∗ (BitOffset DIV 32))'.
> However nothing suggests that it ever does 64bit accesses.
>
> If it does do 64bit accesses when the operand size is 64 bits then the
> asm stubs ought to be changed to only specify 32bit operand size.

bitops operate on unsigned long arrays, so the RMW on the affected array
member has to be atomic vs. other RMW operations on the same array
member. If we make the bitops 32bit wide on x86/64 we break that.

So selecting 64bit access (REX.W prefix) is correct and has to stay.

Thanks,

	tglx


--8323329-1812670699-1554396738=:1802--
