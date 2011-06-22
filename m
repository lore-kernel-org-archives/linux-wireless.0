Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab1FVM5D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 08:57:03 -0400
Date: Wed, 22 Jun 2011 14:57:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
Message-ID: <20110622125710.GD22420@sortiz-mobl> (sfid-20110622_145707_407773_47BB918C)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
 <1308728084.3883.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308728084.3883.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 22, 2011 at 09:34:44AM +0200, Johannes Berg wrote:
> 
> > + * @NFC_ATTR_TARGET_SENS_RES: extra information for NFC-A targets
> > + * @NFC_ATTR_TARGET_SEL_RES: extra information for NFC-A targets
> 
> Those descriptions aren't very useful to me, but hopefully if I knew
> anything about NFC I'd understand :)
You might, yes :)


> > +struct nfc_target {
> > +	u32 idx;
> > +	u32 supported_protocols;
> > +	u16 sens_res;
> > +	u8 sel_res;
> > +};
> 
> There's no list_head here.
> 
> >  struct nfc_dev {
> >  	unsigned idx;
> > +	unsigned target_idx;
> > +	struct nfc_target *targets;
> 
> And this looks like an array. Do you really want to do that? That means
> lots of reallocations.
So NFC polling is a bit weird. Whenever you start polling for passive targets,
the polling results are minimal: You only know that there is _a_ target on a
particular frequency/modulation. It could be the same as the one you got 5
minutes ago, or not. To verify it, you'd need to select the target (and put
all other ones on standby) and start sending specific commands to it (Of
course, you have a different set of commands per target family...). Only then
you _may_ read some sort of UID that could help you matching targets from your
previous poll cycle.
My point is, when we start polling, we will invalidate all existing targets
anyway. So a linked list or an array won't make a big difference in that area.


> > +/**
> > + * nfc_targets_found - inform that targets were found
> > + *
> > + * @dev: The nfc device that found the targets
> > + * @targets: array of nfc targets found
> > + * @ntargets: targets array size
> > + *
> > + * The device driver must call this function when one or many nfc targets
> > + * are found. After calling this function, the device driver must stop
> > + * polling for targets.
> > + */
> > +int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
> > +							int n_targets)
> 
> I haven't looked at the API users, but do you really expect them to
> build an array? That seems rather odd since I'd typically expect targets
> to be discovered one by one, not en bloc.
That's a typical use case, yes. But the HCI specs clearly leaves some room for
detecting one target per frequency/modulation. So for example if you have a
Felica card and a Mifare one next to your NFC dongle, the dongle itself will
send an event to the host saying "I found several targets". You then read some
sort of pseudo registry for each rf family to check if there is a target for
it or not. So, the driver gets one single event for several targets found.

> > @@ -298,7 +353,10 @@ int nfc_register_device(struct nfc_dev *dev)
> >  	rc = device_add(&dev->dev);
> >  	mutex_unlock(&nfc_devlist_mutex);
> >  
> > -	return rc;
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	return nfc_genl_device_added(dev);
> 
> No rollback if nfc_genl_device_added() fails? Either you need to ignore
> the error or roll back I think.
True.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
