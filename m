Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37127 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbXC2LO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:14:28 -0400
Message-ID: <460B9F8C.3040701@warmcat.com>
Date: Thu, 29 Mar 2007 12:14:20 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: Monitor mode radiotap-based packet injection
References: <20070320103955.600509703@warmcat.com>	 <20070320104104.837354764@warmcat.com> <1174501733.3944.28.camel@johannes.berg>
In-Reply-To: <1174501733.3944.28.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

Hi Johannes -

I am going to issue a new patch set for the injection stuff shortly, so 
I can reply to your comments with what has happened about them.

> The actual parsing should live in cfg80211 (preferably in a new file) so
> that others can use it. If it's a lot of code then add a new invisible
> Kconfig symbol for it that drivers/stacks can select.

I did this -- it's pretty small so I just added it to the Makefile.

>> +	 * There is also some pervacious arg padding, so that args
> 
> perwhat?

http://www.urbandictionary.com/define.php?term=pervacious

Rephrased to something less exciting.

>> +	static const u8 radiotap_entry_sizes[] = {
>> +		8, /* IEEE80211_RADIOTAP_TSFT */
>> +		1, /* IEEE80211_RADIOTAP_FLAGS */
> [...]
> 
> I'd prefer C99 style for this.

Shocked that stuff from as late as 1999 is allowed.  I normally use // 
myself, I was making a special effort.

>> +		return TXRX_DROP; /* version byte as magic */
> 
> Bad idea. At least the comment. If you mean "drop the packet if it has a
> radiotap version we don't parse" then say so.

the PRISM format stuff that this replaces (on rx anyway) has an explicit 
magic at the start.  Hence the thought to treat the version byte as a 
"magic".  But changed.

>> +	if (le32_to_cpu(rthdr->it_present) & 0x80000000) {
>> +		while (le32_to_cpu(*((u32 *)tap_arg)) & 0x80000000)
> 
> Use a constant for that, introduce one if necessary.

Done.

>> +	control->key_idx = -1; /* no encryption key */
> 
> Is there any way to indicate encryption? I think there might need to be
> for 802.11w.
> 
>> +	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
>> +		IEEE80211_TXCTL_USE_CTS_PROTECT);
> 
> These really should be selectable as well.
> 
>> +	control->flags |= (IEEE80211_TXCTL_DO_NOT_ENCRYPT |
>> +		IEEE80211_TXCTL_NO_ACK);
> 
> And NO_ACK is a really really totally bad idea for a userspace MLME.
> Needs to be selectable for sure.

Yes to cover more usage cases setting more things is needed.  The game 
seems to be to set the elements of the control struct from the radiotap 
header.  For clear discussion here is the list of things that can be set 
in control, first the ones we allow control of with this patch

	int tx_rate; /* Transmit rate, given as the hw specific value for the
		      * rate (from struct ieee80211_rate) */
	u8 power_level;		/* per-packet transmit power level, in dBm */
	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */


and the ones we might possibly want to fiddle with

	int rts_cts_rate; /* Transmit rate for RTS/CTS frame, given as the hw
			   * specific value for the rate (from
			   * struct ieee80211_rate) */
	u32 flags;			       /* tx control flags defined
						* above */
	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
	s8 key_idx;		/* -1 = do not encrypt, >= 0 keyidx from
				 * hw->set_key() */
	u8 icv_len;		/* length of the ICV/MIC field in octets */
	u8 iv_len;		/* length of the IV field in octets */
	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
	u8 queue;		/* hardware queue to use for this frame;
				 * 0 = highest, hw->queues-1 = lowest */
	u8 sw_retry_attempt;	/* number of times hw has tried to
				 * transmit frame (not incl. hw retries) */
	int alt_retry_rate; /* retry rate for the last retries, given as the
			     * hw specific value for the rate (from
			     * struct ieee80211_rate). To be used to limit
			     * packet dropping when probing higher rates, if hw
			     * supports multiple retry rates. -1 = not used */

the flags are these

#define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status 
callback for
						* this frame */
#define IEEE80211_TXCTL_DO_NOT_ENCRYPT	(1<<1) /* send this frame without
						* encryption; e.g., for EAPOL
						* frames */
#define IEEE80211_TXCTL_USE_RTS_CTS	(1<<2) /* use RTS-CTS before sending
						* frame */
#define IEEE80211_TXCTL_USE_CTS_PROTECT	(1<<3) /* use CTS protection for the
						* frame (e.g., for combined
						* 802.11g / 802.11b networks) */
#define IEEE80211_TXCTL_NO_ACK		(1<<4) /* tell the low level not to
						* wait for an ack */
#define IEEE80211_TXCTL_RATE_CTRL_PROBE	(1<<5)
#define IEEE80211_TXCTL_CLEAR_DST_MASK	(1<<6)
#define IEEE80211_TXCTL_REQUEUE		(1<<7)
#define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
						* the frame */
#define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)

I guess the method is to work out what is useful to control and to 
define a minimal set of new radiotap arg indexes to cover them, and 
propose it to the radiotap folks.

> We also need to be able to assign some magic cookie to a packet that we
> get back along with the packet so that we know when the injected packet
> has been acked by the peer.

The idea here is to synthesize an rx packet later after the tx has 
happened, reflecting the tx status back to userspace that way (if he 
elects to listen out for them)?

>> +	/* remove the radiotap header */
>> +	skb_pull(skb, le16_to_cpu(rthdr->it_len));
> 
> Shouldn't there be some sort of sanity check here so we don't pull too
> much if userspace asks us to?

The sanity check for length of the radiotap header vs length of the 
packet is done right after the mag-^H^H^H version test.  It is moved 
into the radiotap iteration init function in cfg80211 in the new patches.

-Andy

