Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B558C282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 10:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE467214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 10:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfDYK6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:58:44 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:58526 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbfDYK6n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 06:58:43 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJc5I-0003Mo-SB; Thu, 25 Apr 2019 12:58:33 +0200
Date:   Thu, 25 Apr 2019 12:58:32 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Fenghua Yu' <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
In-Reply-To: <762682ba43a0468897ff5ddbf6633d58@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com> <1556134382-58814-14-git-send-email-fenghua.yu@intel.com> <762682ba43a0468897ff5ddbf6633d58@AcuMS.aculab.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 25 Apr 2019, David Laight wrote:

> From:  Fenghua Yu
> > Sent: 24 April 2019 20:33
> > A split locked access locks bus and degrades overall memory access
> > performance. When split lock detection feature is enumerated, enable
> > the feature by default by writing 1 to bit 29 in MSR TEST_CTL to find
> > any split lock issue.
> 
> You can't enable this by default until ALL the known potentially
> misaligned locked memory operations have been fixed.

Errm? The result will be a WARN_ON() printed and no further damage. It's
not making anything worse than it is now. In fact we just should add a

    WARN_ON_ONCE(!aligned_to_long(p)) to all the xxx_bit() operations.

so we catch them even when they do not trigger that #AC thingy.

Thanks,

	tglx
