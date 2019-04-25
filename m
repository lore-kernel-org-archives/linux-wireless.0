Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049AAC282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF1E42084B
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfDYLMN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:12:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:45714 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfDYLMN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 07:12:13 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-19-l7csC4glMRq7wD7hxGcYNA-1; Thu, 25 Apr 2019 12:12:10 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 25 Apr 2019 12:13:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 25 Apr 2019 12:13:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>
CC:     'Fenghua Yu' <fenghua.yu@intel.com>,
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
Thread-Topic: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
Thread-Index: AQHU+tYCJUyDFc/Zd0WR7kUsRI2JUKZMsyTw///yEQCAABKeAA==
Date:   Thu, 25 Apr 2019 11:13:23 +0000
Message-ID: <551673e41ac649689243cbe060364b0d@AcuMS.aculab.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
 <762682ba43a0468897ff5ddbf6633d58@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: l7csC4glMRq7wD7hxGcYNA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Thomas Gleixne]
> Sent: 25 April 2019 11:59
> On Thu, 25 Apr 2019, David Laight wrote:
> 
> > From:  Fenghua Yu
> > > Sent: 24 April 2019 20:33
> > > A split locked access locks bus and degrades overall memory access
> > > performance. When split lock detection feature is enumerated, enable
> > > the feature by default by writing 1 to bit 29 in MSR TEST_CTL to find
> > > any split lock issue.
> >
> > You can't enable this by default until ALL the known potentially
> > misaligned locked memory operations have been fixed.
> 
> Errm? The result will be a WARN_ON() printed and no further damage.

ISTR something about sending SIGSEGV to userspace.

> It's not making anything worse than it is now. In fact we just should add a
> 
>     WARN_ON_ONCE(!aligned_to_long(p)) to all the xxx_bit() operations.
> 
> so we catch them even when they do not trigger that #AC thingy.

That will explode the kernel code size.
In any case some of the items I found in a quick scan were bss/data
so the alignment will vary from build to build.

I also found some casts on the xxx_bit() functions in generic code.
I didn't look to see how badly wrong they go on BE systems.

While the x86 xxx_bit() functions could easily be changed to do
32bit accesses, the 'misaligned' operations will affect all
architectures - and may have different effects on others.

I'm not at all sure that 'compare and exchange' operations
are atomic on all cpus if the data is misaligned and crosses
a page boundary and either (or both) pages need faulting in
(or hit a TLB miss).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

