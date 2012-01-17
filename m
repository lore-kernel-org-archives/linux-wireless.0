Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58748 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2AQKHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 05:07:02 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>
CC: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] NFC: Download TI NFC init script
Date: Tue, 17 Jan 2012 10:06:42 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5E0DCE@DNCE03.ent.ti.com> (sfid-20120117_110708_356436_C84FA3F0)
References: <1326296420-3568-1-git-send-email-ilane@ti.com>
 <1326747643.22824.23.camel@sortiz-mobl>
In-Reply-To: <1326747643.22824.23.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> > @@ -208,11 +489,13 @@ static int nfcwilink_send(struct sk_buff *skb)
> >  
> >  	nfc_dev_dbg(&drv->pdev->dev, "send entry, len %d", skb->len);
> >  
> > -	if (!test_bit(NFCWILINK_RUNNING, &drv->flags))
> > -		return -EBUSY;
> > +	if (!test_bit(NFCWILINK_RUNNING, &drv->flags)) {
> > +		kfree_skb(skb);
> > +		return -EINVAL;
> > +	}
> This is not related to this patch.
> 
> 
> >  	/* add the ST hdr to the start of the buffer */
> > -	hdr.len = skb->len;
> > +	hdr.len = cpu_to_le16(skb->len);
> Same here.
> 
> 
> >  	memcpy(skb_push(skb, NFCWILINK_HDR_LEN), &hdr, 
> NFCWILINK_HDR_LEN);
> >  
> >  	/* Insert skb to shared transport layer's transmit queue.
> > @@ -239,7 +522,7 @@ static int nfcwilink_probe(struct 
> platform_device *pdev)
> >  {
> >  	static struct nfcwilink *drv;
> >  	int rc;
> > -	u32 protocols;
> > +	__u32 protocols;
> Ditto.
You're correct, I will split the patch.

> Cheers,
> Samuel.
Thanks & BR,
Ilan
