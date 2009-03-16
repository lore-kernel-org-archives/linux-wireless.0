Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46326 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbZCPTV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 15:21:27 -0400
Received: by ewy25 with SMTP id 25so3599802ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 12:21:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Fix SLAB corruption during
Date: Mon, 16 Mar 2009 20:21:21 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <200903161925.41102.IvDoorn@gmail.com> <1237230930.16956.66.camel@localhost.localdomain>
In-Reply-To: <1237230930.16956.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903162021.21488.IvDoorn@gmail.com> (sfid-20090316_202147_154657_241A85C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 16 March 2009, Dan Williams wrote:
> On Mon, 2009-03-16 at 19:25 +0100, Ivo van Doorn wrote:
> > At rmmod stage, the code path is the following one :
> > 
> > rt2x00lib_remove_dev
> >   ->  rt2x00lib_uninitialize()
> >         -> rt2x00rfkill_unregister()
> >              -> rfkill_unregister()
> >         -> rt2x00rfkill_free()
> >              -> rfkill_free()
> > 
> > The problem is that rfkill_free should not be called after rfkill_free
> > otherwise put_device(&rfkill->dev) will be called 2 times. This patch
> > fix this by removing the call to rfkill_free
> 
> Needs a better patch title :)  During what?  And I assume you mean
> "rfkill_free() should not be called after rfkill_unregister(), right?

Oops, me and copy & pasting. :)
Will resend with correct information.

Ivo

> Dan
> 
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > Tested-by: Arnaud Patard <apatard@mandriva.com>
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > ---
> > John, this patch is for 2.6.29 and only 2.6.29 since rfkill support itself
> > was removed from later versions (replaced by input_polldev).
> > The patch is quite big to be merged in a late state of the release cycle,
> > but since the SLAB corruption is a serious problem, I hope this can get in regardless.
> > 
> > Thanks.
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> > index 39ecf3b..820fdb2 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00.h
> > +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> > @@ -687,8 +687,7 @@ struct rt2x00_dev {
> >  	 */
> >  #ifdef CONFIG_RT2X00_LIB_RFKILL
> >  	unsigned long rfkill_state;
> > -#define RFKILL_STATE_ALLOCATED		1
> > -#define RFKILL_STATE_REGISTERED		2
> > +#define RFKILL_STATE_REGISTERED		1
> >  	struct rfkill *rfkill;
> >  	struct delayed_work rfkill_work;
> >  #endif /* CONFIG_RT2X00_LIB_RFKILL */
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > index 87c0f2c..e694bb7 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > @@ -1105,7 +1105,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
> >  	 * Register extra components.
> >  	 */
> >  	rt2x00leds_register(rt2x00dev);
> > -	rt2x00rfkill_allocate(rt2x00dev);
> >  	rt2x00debug_register(rt2x00dev);
> >  
> >  	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
> > @@ -1137,7 +1136,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
> >  	 * Free extra components
> >  	 */
> >  	rt2x00debug_deregister(rt2x00dev);
> > -	rt2x00rfkill_free(rt2x00dev);
> >  	rt2x00leds_unregister(rt2x00dev);
> >  
> >  	/*
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> > index 86cd26f..49309d4 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> > +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> > @@ -260,8 +260,6 @@ static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
> >  #ifdef CONFIG_RT2X00_LIB_RFKILL
> >  void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
> >  void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
> > -void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
> > -void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
> >  #else
> >  static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
> >  {
> > @@ -270,14 +268,6 @@ static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
> >  static inline void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
> >  {
> >  }
> > -
> > -static inline void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
> > -{
> > -}
> > -
> > -static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
> > -{
> > -}
> >  #endif /* CONFIG_RT2X00_LIB_RFKILL */
> >  
> >  /*
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> > index 3298cae..08ffc6d 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> > @@ -94,14 +94,50 @@ static void rt2x00rfkill_poll(struct work_struct *work)
> >  			   &rt2x00dev->rfkill_work, RFKILL_POLL_INTERVAL);
> >  }
> >  
> > +static int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
> > +{
> > +	struct device *dev = wiphy_dev(rt2x00dev->hw->wiphy);
> > +
> > +	rt2x00dev->rfkill = rfkill_allocate(dev, RFKILL_TYPE_WLAN);
> > +	if (!rt2x00dev->rfkill)
> > +		return -ENOMEM;
> > +
> > +	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
> > +	rt2x00dev->rfkill->data = rt2x00dev;
> > +	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
> > +	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
> > +		rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
> > +		rt2x00dev->rfkill->state =
> > +			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
> > +			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
> > +	} else {
> > +		rt2x00dev->rfkill->state = RFKILL_STATE_UNBLOCKED;
> > +	}
> > +
> > +	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
> > +
> > +	return 0;
> > +}
> > +
> > +static void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
> > +{
> > +	rfkill_free(rt2x00dev->rfkill);
> > +	rt2x00dev->rfkill = NULL;
> > +}
> > +
> >  void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
> >  {
> > -	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
> > -	    test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
> > +	if (test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
> > +		return;
> > +
> > +	if (rt2x00rfkill_allocate(rt2x00dev)) {
> > +		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
> >  		return;
> > +	}
> >  
> >  	if (rfkill_register(rt2x00dev->rfkill)) {
> >  		ERROR(rt2x00dev, "Failed to register rfkill handler.\n");
> > +		rt2x00rfkill_free(rt2x00dev);
> >  		return;
> >  	}
> >  
> > @@ -117,8 +153,7 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
> >  
> >  void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
> >  {
> > -	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
> > -	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
> > +	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
> >  		return;
> >  
> >  	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
> > @@ -127,46 +162,3 @@ void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
> >  
> >  	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
> >  }
> > -
> > -void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
> > -{
> > -	struct device *dev = wiphy_dev(rt2x00dev->hw->wiphy);
> > -
> > -	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
> > -		return;
> > -
> > -	rt2x00dev->rfkill = rfkill_allocate(dev, RFKILL_TYPE_WLAN);
> > -	if (!rt2x00dev->rfkill) {
> > -		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
> > -		return;
> > -	}
> > -
> > -	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
> > -
> > -	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
> > -	rt2x00dev->rfkill->data = rt2x00dev;
> > -	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
> > -	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
> > -		rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
> > -		rt2x00dev->rfkill->state =
> > -			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
> > -			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
> > -	} else {
> > -		rt2x00dev->rfkill->state = RFKILL_STATE_UNBLOCKED;
> > -	}
> > -
> > -	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
> > -
> > -	return;
> > -}
> > -
> > -void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
> > -{
> > -	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
> > -		return;
> > -
> > -	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
> > -
> > -	rfkill_free(rt2x00dev->rfkill);
> > -	rt2x00dev->rfkill = NULL;
> > -}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


