Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60333 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbbCITw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:52:59 -0400
Message-ID: <1425930775.28819.42.camel@sipsolutions.net> (sfid-20150309_205303_504915_0DCF211D)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 09 Mar 2015 20:52:55 +0100
In-Reply-To: <wrfjbnk2qarp.fsf@ultrasam.lan.trained-monkey.org>
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1425923186.28819.32.camel@sipsolutions.net>
	 <wrfjbnk2qarp.fsf@ultrasam.lan.trained-monkey.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 14:35 -0400, Jes Sorensen wrote:

> >> +		if (sta->ht_cap.ht_supported) {
> >> +			ampdu_factor = sta->ht_cap.ampdu_factor;
> >> +			ampdu_density = sta->ht_cap.ampdu_density;
> >> +			sifs = 0x0e;
> >> +		} else {
> >> +			ampdu_factor = 0;
> >> +			ampdu_density = 0;
> >> +			sifs = 0x0a;
> >> +		}
> >> +		rcu_read_unlock();
> >
> > This doesn't really make much sense - BSS_CHANGED_HT only says we
> > changed bss_conf.ht_operation_mode which you don't use here.
> 
> In this case, is there another flag that would be more appropriate to
> handle this under?

I think this would be similarly appropriate to handle in the sta_state()
call (when it becomes associated) since these values also cannot change
on the fly. Or just also roll it up into ASSOC where you seem to need it
mostly.

> >> +	if (unlikely(ieee80211_is_beacon(hdr->frame_control)))
> >> +		queue = TXDESC_QUEUE_BEACON;
> >> +	if (ieee80211_is_mgmt(hdr->frame_control))
> >
> > I think you mean else if?
> >
> > Anyway beacons cannot happen here except perhaps for injection, in which
> > case you probably wouldn't want to use the beacon queue anyway. I'd
> > remove the beacon case here entirely.
> 
> This is probably suffer from being derived from vendor driver. They have
> a special beacon queue in the hardware which doesn't seem to map
> directly to anything the Linux stack does.
> 
> Until I or someone else eventually implements AP support in this driver,
> it probably doesn't matter.

Indeed. Nonetheless, I'd remove the is_beacon() as you could hit this
code path from userspace by injecting beacon frames, and it's unlikely
to work correctly.

When you actually add AP mode, you probably won't go through this
function to send beacons anyway, but through some other code path that
can just statically select the beacon queue, so even then it doesn't
seem like you'd need this.

> > Something about the TX is a bit fishy, you're using some software rate
> > control data but aren't reporting any data back for rate control which
> > seems to imply the device does it. You're also setting
> > IEEE80211_HW_HAS_RATE_CONTROL which means you can't be using rates etc.
> > here? I'll probably have to look into this more, it's an area that I'm
> > not intimately familiar with.
> 
> The reason for this is that I can do either way and I have been playing
> around with both. The vendor driver explicitly uses sw rate control for
> management packets, whether this is necessary or legacy I cannot tell,
> but I was trying to map to what they were doing.

Ok. If you're actually getting good rates out of it then you probably do
have firmware rate control kicking in, so it's probably fine. Reporting
things back would be nice but isn't really essential.

> >> +		skb_size = sizeof(struct rtl8xxxu_rx_desc) +
> >> +			RTL_RX_BUFFER_SIZE;
> >> +		skb = dev_alloc_skb(skb_size);
> >
> > And then you allocate a new one into the same variable. From a
> > maintenance POV that seems a bit ugly, perhaps you should avoid that.
> 
> I have always done this, kinda like it, but I am not really objecting to
> it.

Sure, if you like doing it that way I certainly won't object to it. It
just caught my eye because initially I thought that you were using the
skb after giving up ownership by passing to mac80211.

> > This is also very strange, you're sending essentially random data, from
> > an skb pointer that's not even a proper skb len? I think you just want
> > to use kmalloc() here instead of having an skb? Or at least use
> > skb_put() to reserve that memory area - it doesn't make a big difference
> > to you but using the skb API in this way is likely to confuse people in
> > the future.
> 
> I wanted to avoid having to allocate and then copy on arrival. It's been
> quite common for drivers to do this, but I guess I ought to set the skb
> len as well at this point to keep it clean.

Yeah I kinda understood that later :) I guess you set the len later, so
perhaps just adding some comments would be best, since otherwise you
could also arguably have to initialize the skb memory which you really
don't want to. Btw, there doesn't seem to be much point in initialising
the hdr either?

> > In fact you could even allocate a page instead, and then add it to the
> > skb as a frag like iwlwifi does for example, and potentially not have to
> > copy the data around later when it goes somewhere. Not sure that's worth
> > it for this device though :)
> 
> I think the device can handle fragments, problem is I have zero
> documentation on how it does so.

Oh, no, I meant on RX. Submit URBs with pages, and then allocate a very
small skb only later, etc. But anyway since this works for you it's
probably better to keep as is unless you notice performance issues with
it. Using pages has some downsides as well.

> Well yes and no, the hardware happens to match to those values too,
> which is a bit of good luck. I think when it uses some of the strange
> encryptions it no longer matches up.

That's probably because the "strange encryption" is SMS4, which is
defined by the Chinese and not by the 802.11 spec :)

> >> +	if (priv->rf_paths > 1) {
> >> +		sband->ht_cap.mcs.rx_mask[1] = 0xff;
> >> +		sband->ht_cap.mcs.rx_highest = cpu_to_le16(300);
> >> +		sband->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
> >> +	} else {
> >> +		sband->ht_cap.mcs.rx_mask[1] = 0x00;
> >> +		sband->ht_cap.mcs.rx_highest = cpu_to_le16(150);
> >> +	}
> >
> > You don't really need to set rx_highest, and you already cleared
> > rx_mask[1], so you don't need the else branch and can remove the
> > rx_highest from the if branch.
> 
> I wanted to prepare the code for adding support for 2r2t devices, but
> I'll remove the rx_highest bits.

Right but all I wrote above applies even when you do have a 2x2 device.

> >> +	sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
> >
> > That doesn't seem true?
> 
> I may misunderstand the meaning of this parameter.

Sorry, no, I got confused. Perhaps VHT has this differently? Can't say
why I got confused, but I double-checked the spec and this is correct.

johannes

