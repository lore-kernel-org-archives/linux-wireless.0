Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2CZKEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 06:04:40 -0400
Message-ID: <1332756769.5884.17.camel@sortiz-mobl> (sfid-20120326_120444_927537_4B506E45)
Subject: RE: [PATCH] NFC: Add Core support to generate tag lost event
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Date: Mon, 26 Mar 2012 12:12:49 +0200
In-Reply-To: <B30D1FD582D6484ABF57420512E5803516A9376C@DNCE03.ent.ti.com>
References: <4F6C5C59.2060708@linux.intel.com>
	 <B30D1FD582D6484ABF57420512E5803516A9376C@DNCE03.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Mon, 2012-03-26 at 09:48 +0000, Elias, Ilan wrote:
> Hi Eric, 
> 
> > +static void nfc_check_pres_work(struct work_struct *work)
> > +{
> > +	struct nfc_dev *dev = container_of(work, struct nfc_dev,
> > +					   check_pres_work);
> > +	int rc;
> > +
> > +	device_lock(&dev->dev);
> > +
> > +	if (dev->activated_target_idx != NFC_TARGET_IDX_NONE &&
> > +	    timer_pending(&dev->check_pres_timer) == 0) {
> > +		rc = dev->ops->check_presence(dev, 
> > dev->activated_target_idx);
> > +		if (!rc) {
> > +			mod_timer(&dev->check_pres_timer, jiffies +
> > +				  
> > msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
> > +		} else {
> > +			nfc_target_lost(dev, dev->activated_target_idx);
> I'm unable to find the definition of the function nfc_target_lost.
This patch is based on my nfc-next branch, where nfc_target_lost is
implemented. I'm waiting for John to take patches for the next merge
window before sending him a pull request for that.

Cheers,
Samuel.

