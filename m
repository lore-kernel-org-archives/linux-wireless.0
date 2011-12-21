Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1LUOnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 09:43:45 -0500
Subject: Re: [RFC] NFC: Add RF technology specific parameters to target info
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <B30D1FD582D6484ABF57420512E5803504FE1669@DNCE03.ent.ti.com>
References: <B30D1FD582D6484ABF57420512E5803504FE1669@DNCE03.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 15:49:01 +0100
Message-ID: <1324478941.5354.2.camel@sortiz-mobl> (sfid-20111221_154348_592387_AC87F07A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Wed, 2011-12-21 at 14:18 +0000, Elias, Ilan wrote:
> Hi Samuel, Lauro, Aloisio,
> 
> Currently, the target information (sent as response to NFC_CMD_GET_TARGET) contains the following: target index, protocols, sens_res, and sel_res.
> As far as I understand, the sens_res (2 Octets) and sel_res (1 Octet) fields are suitable only for tech A.
> 
> It seems that several RF technology specific parameters should be added to the target info:
> 1) For tech A: NFCID1 (0, 4, 7, or 10 Octets), and NFCID1 Length (1 Octet).
> 2) For tech B: SENSB_RES Response (11 or 12 Octets), and SENSB_RES Response Length (1 Octet).
> 3) For tech F: SENSF_RES Response (16 or 18 Octets) and SENSF_RES Response Length (1 Octet).
I agree. When I decided to export sens_res and sel_res, I remember we thought we would need more exports for other technologies.
So, yes, exporting all of those would make sense (e.g. the NFCID one is
on my TODO list).

Cheers,
Samuel.


