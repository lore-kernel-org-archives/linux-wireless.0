Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from che.ojctech.com ([64.198.255.2]:40532 "EHLO che.ojctech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXFUSsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 14:48:07 -0400
Date: Thu, 21 Jun 2007 12:55:41 -0500
From: David Young <dyoung@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: radiotap@ojctech.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
Subject: Re: [Radiotap] radiotap for TX
Message-ID: <20070621175541.GQ19613@che.ojctech.com>
References: <1182375853.3714.103.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182375853.3714.103.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2007 at 11:44:13PM +0200, Johannes Berg wrote:
> Hey,
> 
> I'm currently working on using radiotap for some stuff in the Linux
> wireless stack (mac80211), and ran across the case where we want
> userspace to be able to send the frame to a high-priority queue. I'm
> thinking this should probably be in radiotap.
> 
> There are also other things that need to be controlled via radiotap,
> here's what I can propose so far:
> 
>  * IEEE80211_RADIOTAP_SEND_AC		u8		access category

The MAC access parameters are an important parameter to control, but
I think that if the control is self-contained, then people will use it
in a predictable and consistent way.  As is, you have to interpret the
access category by reference to the current MAC settings for the AC
(AIFS, CWmin, CWmax, et cetera), which can change.

I propose that we add a field such as this,

	IEEE80211_RADIOTAP_TX_WMEPARAM	u32	WME access parameters

with three 8-bit fields for AIFS, log(CWmin), and log(CWmax), and the
remaining 8 bits reserved and set to 0.

This gives us the flexibility to use more MACs to the extent of their
capabilities.  IIRC, one Realtek MAC lets us set the access parameters
packet by packet, instead of category by category or queue by queue.

Some 802.11 MACs have different transmit priority queues, but the queues'
access parameters are not adjustable.  For those MACs, we should provide
for selecting the queue by number:

	IEEE80211_RADIOTAP_TX_QNUM		u8		queue number

I think it's reasonable to say in the _TX_QNUM definition that the queue
numbers do not necessarily have any relationship to queue priority level
or access parameters.

>  *	Indicates which access category to send the frame in, 0-3.
>  *
>  * IEEE80211_RADIOTAP_SEND_FLAGS	u8		flags
...
>    IEEE80211_RADIOTAP_SEND_FLAG_SEQNR (1<<3)
>    /* set if the sequence number in the packet shouldn't be changed,
>     * if not set then the packet is sequence numbered properly */

Let's re-use and augment IEEE80211_RADIOTAP_TX_FLAGS for transmission
control.  For example, let the bits _F_TX_CTS/_F_TX_RTS indicate "use CTS"
and "use RTS" when we transmit.  But see below.  Also, add _F_TX_SEQNR.

>    IEEE80211_RADIOTAP_SEND_FLAG_ENCRYPT (1<<0)
>    /* encrypt with key for the station named in addr1 or default key */

Let's re-use IEEE80211_RADIOTAP_FLAGS[IEEE80211_RADIOTAP_F_WEP] for this.

>    IEEE80211_RADIOTAP_SEND_FLAG_AUTO_RTSCTS (1<<1)
>    /* automatically decide whether rts/cts are used, if unset then
>     * rts/cts are used depending on IEEE80211_RADIOTAP_F_TX_{CTS,RTS} */

I believe implementors will have an easier time if you invert this:
NOAUTO or (errr...) MANUAL.

16-bit fields IEEE80211_RADIOTAP_RTS_THRESHOLD and
IEEE80211_RADIOTAP_CTS_THRESHOLD may be better: if absent, autoselect.
If present and equal to 0, always use RTS(CTS).  If present and greater
than or equal to the maximum packet length, never use RTS(CTS).  We can
likewise control fragmentation.

>    IEEE80211_RADIOTAP_SEND_FLAG_RATE_CONTROL (1<<2)
>    /* should rate control be applied to this algorithm? if not, take
>     * the value of IEEE80211_RADIOTAP_RATE or lowest rate */

Control this by the presence of the _RATE parameter.  If _RATE is absent,
let the driver or NIC autoselect.

Dave

-- 
David Young             OJC Technologies
dyoung@ojctech.com      Urbana, IL * (217) 278-3933 ext 24
