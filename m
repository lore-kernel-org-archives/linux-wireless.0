Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1834 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab3B1Lyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 06:54:35 -0500
Message-ID: <512F454D.4020802@broadcom.com> (sfid-20130228_125438_966533_A9C11A7F)
Date: Thu, 28 Feb 2013 12:53:49 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "Dan Williams" <dcbw@redhat.com>,
	"Felix Fietkau" <nbd@openwrt.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
 <1361564916.3420.11.camel@jlt4.sipsolutions.net>
 <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
 <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
 <1361726886.8129.9.camel@jlt4.sipsolutions.net>
 <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
 <512AFC80.9030808@openwrt.org>
 <1361787911.8887.2.camel@jlt4.sipsolutions.net>
 <512B61F9.60802@openwrt.org> <1361960826.15573.8.camel@dcbw.foobar.com>
 <512E4612.2050106@broadcom.com>
In-Reply-To: <512E4612.2050106@broadcom.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/13 18:44, Arend van Spriel wrote:
>> I think the best approach here is to allow the higher layers to hint to
>> the driver that some operations that are about to start must be "more
>> reliable".  That includes EAPOL, DHCP, IP autoconfiguration, etc.  Then
>> when the higher layers know the operation is finished, they can indicate
>> the operations are done and the driver can go do whatever it wants.
> 
> Indeed the RFC approach was explicit about the scope of this interface being BT coex or actually BT
> coex override. Johannes proposes one dedicated to DHCP as a similar interface in Android is used for
> that right now. Abstracting it to "more reliable" mainly avoids renaming it when someone comes up
> with a use-case other than BT coex or DHCP.
Definitely a more generic interface would be great as there are many driver independent things
that can be done to improve "reliability" (defer scanning, prevent band/channel switching).
But I  think it is a good idea to keep this "reliability boost" time constrained on cfg80211 level,
with userspace signaling that it is done resulting in return to default operation earlier.

Piotr


