Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC39C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27ABD2082E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfDDOnl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:43:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:44287 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726888AbfDDOnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 10:43:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-45-Ax38F7LhM8a1MVH26902Kg-1; Thu, 04 Apr 2019 15:43:37 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 4 Apr 2019 15:44:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 4 Apr 2019 15:44:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Fenghua Yu' <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 04/20] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v6 04/20] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHU6mTrt6127B4KeUCFmArv0ksdfKYsEdZA
Date:   Thu, 4 Apr 2019 14:44:44 +0000
Message-ID: <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-5-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1554326526-172295-5-git-send-email-fenghua.yu@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Ax38F7LhM8a1MVH26902Kg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Fenghua Yu
> Sent: 03 April 2019 22:22
> set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
> operate on bitmap defined in x86_capability.
> 
> Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
> the location is at:
> base address of x86_capability + (bit offset in x86_capability / 64) * 8
> 
> Since base address of x86_capability may not be aligned to unsigned long,
> the single unsigned long location may cross two cache lines and
> accessing the location by locked BTS/BTR introductions will trigger #AC.

That is not true.
The BTS/BTR instructions access the memory word that contains the
expected bit.
The 'operand size' only affects the size of the register use for the
bit offset.
If the 'operand size' is 16 bits wide (+/- 32k bit offset) the cpu might
do an aligned 16bit memory access, otherwise (32 or 64bit bit offset) it
might do an aligned 32 bit access.
It should never do an 64bit access and never a misaligned one (even if
the base address is misaligned).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

