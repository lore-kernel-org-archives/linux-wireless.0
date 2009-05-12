Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:23052 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZELRSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:18:13 -0400
Received: by fk-out-0910.google.com with SMTP id 18so52578fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 10:18:13 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905101236h2cd24edewae808da384ae48dd@mail.gmail.com>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
	 <1241606838.18657.1.camel@maxim-laptop> <1241642056.3289.6.camel@mj>
	 <1241958023.6051.14.camel@maxim-laptop>
	 <43e72e890905101133w2314250s7b95a8c100e83cce@mail.gmail.com>
	 <1241984076.6051.18.camel@maxim-laptop>
	 <43e72e890905101236h2cd24edewae808da384ae48dd@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-YLGcjS4CdbSYHjYdk+LC"
Date: Tue, 12 May 2009 18:05:28 +0300
Message-Id: <1242140728.5626.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YLGcjS4CdbSYHjYdk+LC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-05-10 at 12:36 -0700, Luis R. Rodriguez wrote:
> On Sun, May 10, 2009 at 12:34 PM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > On Sun, 2009-05-10 at 11:33 -0700, Luis R. Rodriguez wrote:
> >> On Sun, May 10, 2009 at 5:20 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> > On Wed, 2009-05-06 at 16:34 -0400, Pavel Roskin wrote:
> >> >> gdb /lib/modules/`uname -r`/kernel/net/wireless/cfg80211.ko
> >> >
> >> > I have recompiled the kernel with debugging info.
> >> >
> >> > This is new backtrace:

Ok, here is what I found:

The real BUG_ON that fires up is at 

wireless/reg.c: __set_regdom: BUG_ON(!country_ie_regdomain)

Confirmed by replacing it with printk.


I attach a beacon sample that triggers this:


Best regards,
	Maxim Levitsky

--=-YLGcjS4CdbSYHjYdk+LC
Content-Disposition: attachment; filename="beacon.pcap"
Content-Type: application/octet-stream; name="beacon.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAA5IkJSnACBwDQAAAA0AAAAAAAGABuSAAAAARsCaAAt4EC
AAAAAAAAAIAAAAD///////8ACw4qBIAACw4qBIDQsoFRo7l/AAAAZAAhAAAIVGVjaHdpZmkBCIKE
iwwSlhgkAwEBBQQAAQEABwZJTCABDRILBRUAPwAAQwIAACoBADIEMEhgbN0FAAsOBADdIgALDgIA
AAAAEgwCoQSiC6MMpRKmFqYYpySoMKtIrmC1bLjdLgALDgMC/AmdzrAAoLw8vgc0FdlcJI5bXxlJ
B/V6fLTb0mT0+iHjM8pJCV47nJo=


--=-YLGcjS4CdbSYHjYdk+LC--

