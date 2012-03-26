Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54402 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab2CZJtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 05:49:09 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: RE: [PATCH] NFC: Add Core support to generate tag lost event
Date: Mon, 26 Mar 2012 09:48:52 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803516A9376C@DNCE03.ent.ti.com> (sfid-20120326_114913_527784_E3D99D57)
References: <4F6C5C59.2060708@linux.intel.com>
In-Reply-To: <4F6C5C59.2060708@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric, 

> +static void nfc_check_pres_work(struct work_struct *work)
> +{
> +	struct nfc_dev *dev = container_of(work, struct nfc_dev,
> +					   check_pres_work);
> +	int rc;
> +
> +	device_lock(&dev->dev);
> +
> +	if (dev->activated_target_idx != NFC_TARGET_IDX_NONE &&
> +	    timer_pending(&dev->check_pres_timer) == 0) {
> +		rc = dev->ops->check_presence(dev, 
> dev->activated_target_idx);
> +		if (!rc) {
> +			mod_timer(&dev->check_pres_timer, jiffies +
> +				  
> msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
> +		} else {
> +			nfc_target_lost(dev, dev->activated_target_idx);
I'm unable to find the definition of the function nfc_target_lost.

Thanks & BR,
Ilan
