Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A4AC10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3246217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388685AbfDRNNo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:13:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44182 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733205AbfDRNNo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:13:44 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-98-nwPXMM-9NGqHeOMqUFPXMA-1; Thu, 18 Apr 2019 14:13:42 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 18 Apr 2019 14:14:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 18 Apr 2019 14:14:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>
CC:     'Fenghua Yu' <fenghua.yu@intel.com>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        "'Paolo Bonzini'" <pbonzini@redhat.com>,
        'Dave Hansen' <dave.hansen@intel.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Ravi V Shankar' <ravi.v.shankar@intel.com>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Christopherson Sean J' <sean.j.christopherson@intel.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Michael Chan' <michael.chan@broadcom.com>,
        'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v7 04/21] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v7 04/21] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHU9Wc8cfw3/6sx9k22vKHnyDMwNqZBowBwgAAfOzD///urAIAAIrYg
Date:   Thu, 18 Apr 2019 13:14:52 +0000
Message-ID: <aceeddaa107a4aed9add47945acaa129@AcuMS.aculab.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-5-git-send-email-fenghua.yu@intel.com>
 <c8ca959a4bc549b59baca563660d42d6@AcuMS.aculab.com>
 <698b9419c81b443fb9c180d2b27fd34a@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904181347210.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904181347210.3174@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: nwPXMM-9NGqHeOMqUFPXMA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Thomas Gleixner
> Sent: 18 April 2019 12:49
> On Thu, 18 Apr 2019, David Laight wrote:
> > From: David Laight
> > > Sent: 18 April 2019 10:21
> > > From: Fenghua Yu
> > > > Sent: 17 April 2019 22:34
> > > >
> > > > set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
> > > > operate on bitmap defined in x86_capability.
> > > >
> > > > Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
> > > > the location is at:
> > > > base address of x86_capability + (bit offset in x86_capability / 64) * 8
> > > >
> > > > Since base address of x86_capability may not be aligned to unsigned long,
> > > > the single unsigned long location may cross two cache lines and
> > > > accessing the location by locked BTS/BTR introductions will cause
> > > > split lock.
> > >
> > > Isn't the problem that the type (and definition) of x86_capability[] are wrong.
> > > If the 'bitmap' functions are used for it, it should be defined as a bitmap.
> > > This would make it 'unsigned long' not __u32.
> > >
> > > This type munging of bitmaps only works on LE systems.
> > >
> > > OTOH the locked BTS/BTR instructions could be changed to use 32 bit accesses.
> > > ISTR some of the associated functions use byte accesses.
> > >
> > > Perhaps there ought to be asm wrappers for BTS/BTR that do 8bit and
> > > 32bit accesses.
> >
> > A quick look shows that this isn't the only __32[] that is being
> > cast to (unsigned long) and then to set/test/clear_bit() in those
> > files.
> >
> > I wonder how much other code is applying such casts?
> 
> The reason for the cpuid stuff using u32 is that this is actually the width
> of the information retrieved from CPUID.

Right, but you shouldn't (as has been found out) cast pointers
to integer types.

Running
grep -r --include '*.[ch]' '_bit([^(]*, *([^)]* ' .
over the entire kernel source tree shows quite a few 'dubious' casts.

They'll be doubly dubious on BE systems.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

