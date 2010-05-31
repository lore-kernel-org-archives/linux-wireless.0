Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:53823 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0EaIBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 04:01:46 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id o4V81fmS021804
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 10:01:41 +0200
Message-ID: <4C036CE4.1060503@itwm.fraunhofer.de>
Date: Mon, 31 May 2010 10:01:40 +0200
From: Martin Vogt <martin.vogt@itwm.fraunhofer.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: new bluetooth id for lenovo T410s?
References: <4BFE4124.2090601@itwm.fraunhofer.de> <1274957276.4706.4.camel@aeonflux.t-mobile.de> 	<4BFF9D8E.5040702@itwm.fraunhofer.de> <AANLkTin6B6EHaTzepktDo_TrRF3n0N8ZyUB9oszdE5wS@mail.gmail.com>
In-Reply-To: <AANLkTin6B6EHaTzepktDo_TrRF3n0N8ZyUB9oszdE5wS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, May 28, 2010 at 3:40 AM, Martin Vogt
> <martin.vogt@itwm.fraunhofer.de> wrote:
>> Marcel Holtmann wrote:
>>> Hi Martin,
>>>
>>> so first of all, this is the wrong mailing list. You should be using
>>> linux-bluetooth@vger.kernel.org.
>> Oh, ok.

>>>
>> Just a small update: It works now, the btusb driver
>> from the compat-wireless module didnt load with symbol
>> problems.
>> (I use a Suse 2.6.27 vendor kernel which already is a bit 2.6.28+
>> compat-wireless-2.6.34)
>>
>> I placed some #if 0 #endif combinations in compat-2.6.28.c
>> ==>now it works.
> 
> Was this a Suse distribution problem? If so can you elaborate?
> 

I thought that bluetooth would not work an the T410, but
now Im not sure anymore, if it would have worked directly
with 2.6.27.suse.
(At least the KDE 3.5 bluetooth applet was "grey" (and is still grey),
the KDE 4.x kbluetooth app works now, but maybe
this would have worked before too...--dont know--)

So I cannot say if it wouldnt have worked out of the box
because I directly upgrade to compat-wireless 2.6.34.

regards,

Martin


This was the patch required for the vendor SUSE kernel.

--- compat/compat-2.6.28.c.org  2010-05-27 15:41:41.000000000 +0200
+++ compat/compat-2.6.28.c      2010-05-27 15:57:33.000000000 +0200
@@ -307,6 +307,7 @@
 }
 EXPORT_SYMBOL_GPL(pci_ioremap_bar);

+#if 0
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
                bool force_up)
 {
@@ -369,5 +370,5 @@
        skb->truesize += size;
 }
 EXPORT_SYMBOL(skb_add_rx_frag);
-
+#endif /* vogt */
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */



