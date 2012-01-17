Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2AQJsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:48:33 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>,
	"ilanelias78@gmail.com" <ilanelias78@gmail.com>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] NFC: Add NCI data exchange timer
Date: Tue, 17 Jan 2012 09:48:15 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5E0DAF@DNCE03.ent.ti.com> (sfid-20120117_104837_166937_DBBB8E00)
References: <1326024683-30313-1-git-send-email-ilane@ti.com>
 <1326746252.22824.15.camel@sortiz-mobl>
In-Reply-To: <1326746252.22824.15.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel, 

> > -	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
> > +	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
> > +		pr_err("unable to exchange data, already in 
> progress\n");
> This is not really related to that patch.
> 
> > @@ -473,6 +485,8 @@ static struct nfc_ops nci_nfc_ops = {
> >  	.dev_down = nci_dev_down,
> >  	.start_poll = nci_start_poll,
> >  	.stop_poll = nci_stop_poll,
> > +	.dep_link_up = NULL,
> > +	.dep_link_down = NULL,
> Ditto.
You're correct, I will remove those.

Thanks & BR,
Ilan
