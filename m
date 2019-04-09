Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E237C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 06:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584AA20883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 06:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfDIGGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:06:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:2795 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfDIGGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 02:06:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Apr 2019 23:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,328,1549958400"; 
   d="scan'208";a="159480170"
Received: from lxy-dell.sh.intel.com ([10.239.159.145])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2019 23:06:26 -0700
Message-ID: <e1bd195d02862bb4003d262854ce6dafceb73bea.camel@intel.com>
Subject: Re: [PATCH v6 11/20] kvm/x86: Emulate MSR IA32_CORE_CAPABILITY
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 09 Apr 2019 14:03:05 +0800
In-Reply-To: <alpine.DEB.2.21.1904051356070.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
         <1554326526-172295-12-git-send-email-fenghua.yu@intel.com>
         <alpine.DEB.2.21.1904051356070.1802@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-05 at 14:00 +0200, Thomas Gleixner wrote:
> On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >  
> > +u64 kvm_get_core_capability(void)
> > +{
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_get_core_capability);
> 
> Why is this global and exported? The only users are in this very file.

You're right.
Will remove it in next version.

> Thanks,
> 
> 	tglx

