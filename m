Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22756 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbYLETVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 14:21:43 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	stlc45xx-devel@garage.maemo.org
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
References: <877i98iw4h.fsf@nokia.com>
	<1221819119.10419.75.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 05 Dec 2008 21:20:15 +0200
In-Reply-To: <1221819119.10419.75.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 19 Sep 2008 12\:11\:59 +0200")
Message-ID: <87wsee5t00.fsf@nokia.com> (sfid-20081205_202149_697629_B92B3613)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2008-09-19 at 07:43 +0300, Kalle Valo wrote:
>> Hello all,
>> 
>> Nokia yesterday published stlc45xx, which is a mac80211 driver for
>> N800 and N810. Webpage here:
>> 
>> http://stlc45xx.garage.maemo.org/
>
> quick look at the code

And a VERY late reply, sorry for taking so long.

>> 	if (mutex_lock_interruptible(&stlc->mutex) < 0) {
>> 		len = 0;
>> 		goto out;
>> 	}
>
> The interruptible seems fairly useless, I don't see the mutex being held
> for very long periods of time anywhere?

I added basically for bailing out deadlocks, so that I wouldn't have
to reboot the device during deadlock. But I removed the interruptible
versions now.

>
>> 		stlc45xx_error("invalid cal_rssi lenght: %d", count);
>
> typo. I love reviewing in a program with spell checking ;)

Fixed.

>> 	stlc->cal_rssi_ready = 1;
>
> that variable is unneeded

Actually it's still used:

	if (!stlc->cal_rssi_ready) {
		stlc45xx_error("rssi calibration data missing");
		ret = -ENOENT;
		goto out_unlock;
	}

But I'll remove it in upcoming patches.

>> 	if (count != CHANNEL_CAL_ARRAY_LEN) {
>
> I'd suspect that is not a constant, in the US you have 11 channels? Or
> are they in there but disabled?

It's a constant.

>> 	stlc->cal_channels_ready = 1;

Same comment as with cal_rssi_ready

> another pointless variable
>
>> 	ssize_t len;
>
> trailing whitespace in a number of places, run sed 's/\s*$//' or
> something like that :)

I now run checkpatch and all whitespace problems should be fixed.

>> 	/* FIXME: what's the maximum length of buf? page size? */
>> 	len = 500;
>
> Oh, yes, as far as I know.

Ok, I used PAGE_SIZE.

>> 	len = snprintf(buf, len, "%i\n", stlc->psm);
>
> but really, there's little use for snprintf for something that can at
> most get like 13 characters.

Think it more like academic interest :)

>> static ssize_t stlc45xx_sysfs_store_psm(struct device *dev,
>> 					struct device_attribute *attr, 
>> 					const char *buf, size_t count)
>> {
>> 	struct stlc45xx *stlc = dev_get_drvdata(dev);
>> 	int val, ret;
>> 
>> 	ret = sscanf(buf, "%d", &val);
>
> I think you may want strict_strtoul.

I removed entire function and used CONF_PS instead.

>> static u16 stlc45xx_read16(struct stlc45xx *stlc, unsigned long addr)
>
>> static u32 stlc45xx_read32(struct stlc45xx *stlc, unsigned long addr)
>
>> static void stlc45xx_write16(struct stlc45xx *stlc, unsigned long addr, u16 val)
>
>> static void stlc45xx_write32(struct stlc45xx *stlc, unsigned long addr, u32 val)
>
> I'd almost think those should be declared inline, although the compiler
> might?

Compiler should do it automatically.

>> static void stlc45xx_dump_registers(struct stlc45xx *stlc)
>
> Do we need this? It looks unused.

Removed.

>> 	list_for_each_entry(txbuffer, &stlc->txbuffer, buffer_list) {
>> 		if (pos + len < txbuffer->start) {
>> 			found = 1;
>> 			break;
>> 		}
>>                 pos = ALIGN(txbuffer->end + 1, 4);
>> 	}
>> 
>> 	if (!found && (pos + len > FIRMWARE_TXBUFFER_END))
>> 		/* not enough room */
>> 		pos = -1;
>
> Afaict the found variable can be removed since the txbuffer->start will
> be < FIRMWARE_TXBUFFER_END of course.

You are right (as usual), removed the variable.

> This code is actually rather subtle, comments would be good since the
> list must always contain the entries in the order that they're in in the
> firmware buffer too.

I added some comments, but I'll try to add more later.

>> static int stlc45xx_txbuffer_add(struct stlc45xx *stlc,
>> 				 struct txbuffer *txbuffer) 
>> {
>> 	struct txbuffer *r, *prev = NULL;
>> 	int ret = -1;
>> 	
>> 	stlc45xx_debug(DEBUG_FUNC, "%s()", __func__);
>> 
>> 	if (list_empty(&stlc->txbuffer)) {
>> 		list_add(&txbuffer->buffer_list, &stlc->txbuffer);
>> 		ret = 0;
>> 		goto out;
>
> you can just return since there is no cleanup :)

Changed.

>> 	r = list_first_entry(&stlc->txbuffer, struct txbuffer, buffer_list);
>> 	
>> 	if (txbuffer->start < r->start) {
>> 		list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
>> 		ret = 0;
>> 		goto out;
>> 	}
>
> list_add_tail? This seems like it should be list_add() since it's before
> the first item.

Definitely, fixed.

>> 	prev = NULL;
>> 	list_for_each_entry(r, &stlc->txbuffer, buffer_list) {
>> 		WARN_ON_ONCE(txbuffer->start >= r->start
>> 			     && txbuffer->start <= r->end);
>> 		WARN_ON_ONCE(txbuffer->end >= r->start
>> 			     && txbuffer->end <= r->end);
>> 		if (prev && prev->end < txbuffer->start &&
>> 		    txbuffer->start < r->start) {                <---****** txbuffer->end??
>> 			list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
>> 			ret = 0;
>> 			goto out;
>> 		}
>> 		prev = r;
>> 	}
>
> This looks complicated and buggy, how about this instead:

Yeah, I'm not very proud of that buffer allocation code.

> 	prev = NULL;
> 	list_for_each_entry(r, &stlc->txbuffer, buffer_list) {
> 		/* skip first entry, we checked for that above */
> 		if (!prev)
> 			continue;

Expect that we have to update prev, I did it like this:

		/* skip first entry, we checked for that above */
		if (!prev) {
			prev = r;
			continue;
		}

> 		/* double-check overlaps */
> 		WARN_ON_ONCE(txbuffer->start >= r->start &&
> 			     txbuffer->start <= r->end);
> 		WARN_ON_ONCE(txbuffer->end >= r->start &&
> 			     txbuffer->end <= r->end);
>
> 		if (prev->end < txbuffer->start &&
> 		    txbuffer->end < r->start) {
> 			/* insert at this spot */
> 			list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
> 			return 0;
> 		}
> 		prev = r;
> 	}
>

[...]

>>         if (pos < 0) {
>> 		return NULL;
>>         }
>
> useless braces

Fixed.

>> 	WARN_ON_ONCE(pos + len > FIRMWARE_TXBUFFER_END);
>> 	WARN_ON_ONCE(pos < FIRMWARE_TXBUFFER_START);
>> 
>> 	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
>> 	entry->start = pos;
>> 	entry->frame_start = pos + FIRMWARE_TXBUFFER_HEADER;
>> 	entry->end = entry->start + len;
>
> I think this can be
> 	entry->end = entry->start + len - 1
> since you treat it as such in all the other code afaict. Might pack the
> buffers a bit better and require less padding.

I think you are right, though didn't check that throughly. Seems to
work with iperf still, I'm satisfied.

>> /* caller must hold tx_lock */
>> static void stlc45xx_check_txsent(struct stlc45xx *stlc) 
>> {
>> 	struct txbuffer *entry, *n;
>> 
>> 	/* FIXME: notify mac80211? */
>
> Yeah, you'd probably want to.

Fixed.

>> static void stlc45xx_power_on(struct stlc45xx *stlc)
>> {
>> 	omap_set_gpio_dataout(stlc->config->power_gpio, 1);
>> 	enable_irq(OMAP_GPIO_IRQ(stlc->config->irq_gpio));
>> 
>> 	/*
>> 	 * need to wait a while before device can be accessed, the lenght
>
> another typo

Fixed.

>> /* caller must hold tx_lock */
>> static void stlc45xx_flush_queues(struct stlc45xx *stlc) 
>> {
>> 	struct txbuffer *entry;
>> 
>> 	/* FIXME: notify mac80211? */
>
> given that reset shouldn't happen and on stop mac80211 doesn't care, I
> wouldn't bother.

Ok, fixme removed.

>> static void stlc45xx_work_reset(struct work_struct *work)
>> {
>> 	struct stlc45xx *stlc = container_of(work, struct stlc45xx,
>> 					     work_reset);
>
> If reset _does_ happen you could use the mac80211 notification callback
> to tell it to associate again.

Actually that's not needed, in practise the firmware reset happens so
fast that the AP doesn't notice anything. We just need to give exactly
same settings back to the firmware after reset, and then we can
continue as before the reset.

>> static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
>> {
>
>
>> 	stlc45xx_check_txsent(stlc);
>> 	if (list_empty(&stlc->tx_sent))
>> 		/* there are pending frames, we can stop the tx timeout
>> 		 * timer */
>> 		cancel_delayed_work(&stlc->work_tx_timeout);
>
> there are _no_ pending frames [...]

Oops, fixed.

>> 	memset(&status, 0, sizeof(status));
>> 
>> 	status.freq = data->frequency;
>> 	status.signal = data->rcpi / 2 - 110;
>> 
>> 	/* let's assume that maximum rcpi value is 140 (= 35 dBm) */
>> 	status.qual = data->rcpi * 100 / 140;
>> 
>> 	status.band = IEEE80211_BAND_2GHZ;
>> 
>> 	/*
>> 	 * FIXME: this gives warning from __ieee80211_rx()
>> 	 *
>> 	 * status.rate_idx = data->rate;
>> 	 */
>
> That's strange, you should print out the index and see why it warns, it
> shouldn't afaict. Unless the docs are wrong...

I'll check it later.

>> 	__ieee80211_rx(stlc->hw, skb, &status);
>
> Use ieee80211_rx() without the underscores, the __ is just a hack to
> make the symbol clash go away... Jiri never should have let it escape
> the header file.

Fixed.

>> 	setup->antenna = 2;
>> 	setup->rx_align = 0;
>> 	setup->rx_buffer = FIRMWARE_RXBUFFER_START;
>> 	setup->rx_mtu = FIRMWARE_MTU;
>> 	setup->frontend = 5;
>
> There are #defines in the header file for some of these

Added an entry to TODO file.

>> static int stlc45xx_op_add_interface(struct ieee80211_hw *hw,
>> 				     struct ieee80211_if_init_conf *conf)
>> {
>> 	struct stlc45xx *stlc = hw->priv;
>> 
>> 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
>> 	
>> 	switch (conf->type) {
>> 	case IEEE80211_IF_TYPE_STA:
>> 		break;
>> 	default:
>> 		return -EOPNOTSUPP;
>> 	}
>
> You need to keep track whether you're already up or not, right now
> you're allowing multiple STA interfaces.

Again added added to TODO file, will fix it later.

>> static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
>> 					 struct ieee80211_if_init_conf *conf)
>> {
>> 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
>> }
>
> That's why you need _remove_interface in any case and it isn't
> optional :) Also you really should clear the MAC address or go into the
> no-ack mode so pure monitoring works.

Ack.

>> static void stlc45xx_op_configure_filter(struct ieee80211_hw *hw,
>> 				      unsigned int changed_flags,
>> 				      unsigned int *total_flags,
>> 				      int mc_count,
>> 				      struct dev_addr_list *mc_list) 
>> {
>> 	*total_flags = 0;
>> }
>
> If I understand the documentation correctly you can actually support a
> few things here.

Sure does, never just found the time to implement them.

>> /* can't be const, mac80211 writes to this */
>> static struct ieee80211_supported_band stlc45xx_band_2ghz = {
>
> I don't think that's true for this one? Not that it matters. const is a
> pure compiler thing anyway.

Haven't checked for a long time.

>> static int stlc45xx_register_mac80211(struct stlc45xx *stlc)
>> {
>> 	/* FIXME: SET_IEEE80211_PERM_ADDR() requires default_mac_addr
>> 	   to be non-const for some strange reason */
>
> Bug I guess :)

Ok, I'll try to remember to send a patch for this.

>> 	stlc = hw->priv;
>> 	memset(stlc, 0, sizeof(*stlc));
>
> should already be cleared, but you can do it again of course :)

Removed memset().

Thanks a lot for the comments, they were very valuable. Your comments
are also a very good example to show people in our company why open
source really works.

I pushed all the changes to the stlc45xx git repository now:

http://gitorious.org/projects/stlc45xx

gitorious.org doesn't seem to understand about branches and the commit
log looks confusing. Do a git checkout if you want to look at the
changes in more detail.

-- 
Kalle Valo
