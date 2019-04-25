Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8A0C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01774208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZaZUiIhp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfDYLl5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:41:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50334 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfDYLl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 07:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=erRFMyCccnjddFJ0MfCAtqH0NA7Ar//n/AsAHoGwyBE=; b=ZaZUiIhpMaVIOvPrOiRNynxVd
        GkCQP672MFIGqaVKTCMuW8Hzk4/yDSjCKl8ByVA38C7PVMEZQIWXtbsxszXH1OWcaigQIZGUh26lt
        go9pAx3Y0nWnxPXEWckPy5e2w5IiNeCwKTomCLodq8PtKlkxkUV7QSfirWdCobe1U6rYHMORjm6lU
        cvuU09xwmWIRlQtubimTJmtDdjsNu9PSMckpjniyQVtvQCMxUpm03KK4Re3iFtIfUcb9pUXGyeymH
        WsEBh/ZCN1htQYRK1h5rULCpvPeLDPQGnt4gg8TsLhOTk+rYc/qWYUjlnJFv8ZEz4wtJ9N+h9bNgn
        YzKTHEMgw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJcl2-0003PT-5l; Thu, 25 Apr 2019 11:41:40 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ADACA20D0A201; Thu, 25 Apr 2019 13:41:37 +0200 (CEST)
Date:   Thu, 25 Apr 2019 13:41:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Thomas Gleixner' <tglx@linutronix.de>,
        'Fenghua Yu' <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
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
Subject: Re: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
Message-ID: <20190425114137.GO4038@hirez.programming.kicks-ass.net>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
 <762682ba43a0468897ff5ddbf6633d58@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
 <551673e41ac649689243cbe060364b0d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551673e41ac649689243cbe060364b0d@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 25, 2019 at 11:13:23AM +0000, David Laight wrote:
> I'm not at all sure that 'compare and exchange' operations
> are atomic on all cpus if the data is misaligned and crosses
> a page boundary and either (or both) pages need faulting in
> (or hit a TLB miss).

Most sane architectures already trap if you attempt that.
