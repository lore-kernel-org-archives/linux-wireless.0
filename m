Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2AQIbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 03:31:21 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] NFC: Export new attributes sensb_res and sensf_res
Date: Tue, 17 Jan 2012 08:31:02 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5E0D0C@DNCE03.ent.ti.com> (sfid-20120117_093128_749474_53E06E01)
References: <1326012961-29832-1-git-send-email-ilane@ti.com>
 <1326736973.22824.9.camel@sortiz-mobl>
In-Reply-To: <1326736973.22824.9.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel, 

> > diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
> > index 8696b77..d8aef2e 100644
> > --- a/include/net/nfc/nfc.h
> > +++ b/include/net/nfc/nfc.h
> > @@ -66,6 +66,8 @@ struct nfc_ops {
> >  #define NFC_TARGET_IDX_ANY -1
> >  #define NFC_MAX_GT_LEN 48
> >  #define NFC_MAX_NFCID1_LEN 10
> > +#define NFC_MAX_SENSB_RES_LEN 12
> > +#define NFC_MAX_SENSF_RES_LEN 18
> I think those values should be exported to user space though
> include/linux/nfc.h.
> When fetching the byte stream from the netlink socket, you 
> usually want
> to check if it has a valid length in order to memcpy it to a static
> array embedded with your target structure.
> Same applies to NFC_MAX_NFCID1_LEN.
Sure, I will move the definitions to include/linux/nfc.h.

> The rest of the code looks fine to me.
> 
> Cheers,
> Samuel.

Thanks & BR,
Ilan