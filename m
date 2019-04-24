Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569FFC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 13:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E0212054F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 13:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfDXNo3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:44:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58774 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbfDXNo3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 09:44:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-50-CiFaQrbeNPCHVcud67r0LA-1; Wed, 24 Apr 2019 14:44:26 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 24 Apr 2019 14:45:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 24 Apr 2019 14:45:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Fenghua Yu' <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Michael Chan" <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v7 15/21] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
Thread-Topic: [PATCH v7 15/21] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
Thread-Index: AQHU+hcuIxO/8RRUC06MiZvP1071Y6ZLUq/w
Date:   Wed, 24 Apr 2019 13:45:38 +0000
Message-ID: <4a90dd7bf26f44a795ecf55aa54b8ce5@AcuMS.aculab.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-16-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904180042090.3174@nanos.tec.linutronix.de>
 <20190418005711.GB18776@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1904180832290.3174@nanos.tec.linutronix.de>
 <20190423204809.GD18776@romley-ivt3.sc.intel.com>
In-Reply-To: <20190423204809.GD18776@romley-ivt3.sc.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: CiFaQrbeNPCHVcud67r0LA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Fenghua Yu
> Sent: 23 April 2019 21:48
> 
> On Thu, Apr 18, 2019 at 08:41:30AM +0200, Thomas Gleixner wrote:
> > On Wed, 17 Apr 2019, Fenghua Yu wrote:
> > > On Thu, Apr 18, 2019 at 12:47:24AM +0200, Thomas Gleixner wrote:
> > > > On Wed, 17 Apr 2019, Fenghua Yu wrote:
> > > >
> > > > > The interface /sys/device/system/cpu/split_lock_detect is added
> > > > > to allow user to control split lock detection and show current split
> > > > > lock detection setting.
> > > > >
> > > > > Writing [yY1] or [oO][nN] to the file enables split lock detection and
> > > > > writing [nN0] or [oO][fF] disables split lock detection. Split lock
> > > > > detection is enabled or disabled on all CPUs.
> > > > >
> > > > > Reading the file returns current global split lock detection setting:
> > > > > 0: disabled
> > > > > 1: enabled
> > > >
> > > > Again, You explain WHAT this patch does and still there is zero
> > > > justification why this sysfs knob is needed at all. I still do not see any
> > > > reason why this knob should exist.
> > >
> > > An important application has split lock issues which are already discovered
> > > and need to be fixed. But before the issues are fixed, sysadmin still wants to
> > > run the application without rebooting the system, the sysfs knob can be useful
> > > to turn off split lock detection. After the application is done, split lock
> > > detection will be enabled again through the sysfs knob.
> >
> > Are you sure that you are talking about the real world? I might buy the
> > 'off' part somehow, but the 'on' part is beyond theoretical.
> >
> > Even the 'off' part is dubious on a multi user machine. I personally would
> > neither think about using the sysfs knob nor about rebooting the machine
> > simply because I'd consider a lock operation accross a cacheline an malicious
> > DoS attempt. Why would I allow that?
> >
> > So in reality the sysadmin will either move the workload to a machine w/o
> > the #AC magic or just tell the user to fix his crap.
> >
> > > Without the sysfs knob, sysadmin has to reboot the system with kernel option
> > > "no_split_lock_detect" to run the application before the split lock issues
> > > are fixed.
> > >
> > > Is this a valid justification why the sysfs knob is needed? If it is, I can
> > > add the justification in the next version.
> >
> > Why has this information not been in the changelog right away? I'm really
> > tired of asking the same questions and pointing you to
> > Documentation/process over and over.
> 
> So should I remove the sysfs knob patches in the next version?
> 
> Or add the following justification and still keep the sysfs knob patches?
> "To workaround or debug a split lock issue, the administrator may need to
> disable or enable split lock detection during run time without rebooting
> the system."

I've also not seen patches to fix all the places where 'lock bit' operations
get used on int [] data.
Testing had showed one structure that needed 'fixing', there are some others
that are in .bss/.data.
A kernel build could suddenly have them misaligned and crossing a cache line.

All the places that cast the pointer to the bit ops are suspect.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

