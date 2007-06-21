Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:1519 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbXFUVC2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 17:02:28 -0400
Message-ID: <467AE460.1070606@errno.com>
Date: Thu, 21 Jun 2007 13:49:36 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: radiotap@ojctech.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
Subject: Re: radiotap for TX
References: <1182375853.3714.103.camel@johannes.berg>
In-Reply-To: <1182375853.3714.103.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
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
>  *
>  *	Indicates which access category to send the frame in, 0-3.
>  *
>  * IEEE80211_RADIOTAP_SEND_FLAGS	u8		flags
>  *
>    IEEE80211_RADIOTAP_SEND_FLAG_ENCRYPT (1<<0)
>    /* encrypt with key for the station named in addr1 or default key */
> 
>    IEEE80211_RADIOTAP_SEND_FLAG_AUTO_RTSCTS (1<<1)
>    /* automatically decide whether rts/cts are used, if unset then
>     * rts/cts are used depending on IEEE80211_RADIOTAP_F_TX_{CTS,RTS} */
> 
>    IEEE80211_RADIOTAP_SEND_FLAG_RATE_CONTROL (1<<2)
>    /* should rate control be applied to this algorithm? if not, take
>     * the value of IEEE80211_RADIOTAP_RATE or lowest rate */
> 
>    IEEE80211_RADIOTAP_SEND_FLAG_SEQNR (1<<3)
>    /* set if the sequence number in the packet shouldn't be changed,
>     * if not set then the packet is sequence numbered properly */
> 
> So far that's all I would need, but some regular fields would also be
> used like I said above for example IEEE80211_RADIOTAP_F_TX_{CTS,RTS}. A
> good text on using radiotap for this purpose should probably be written,
> I think somebody other than Andy and me was working on something like
> this so we really should work together and define this properly.

This is the control state available on FreeBSD for doing raw 802.11 
frame xmit (packets need not include all this; I've just provided the 
most complete set of knobs):

         uint8_t         ibp_flags;
#define IEEE80211_BPF_SHORTPRE  0x01    /* tx with short preamble */
#define IEEE80211_BPF_NOACK     0x02    /* tx with no ack */
#define IEEE80211_BPF_CRYPTO    0x04    /* tx with h/w encryption */
#define IEEE80211_BPF_FCS       0x10    /* frame incldues FCS */
#define IEEE80211_BPF_DATAPAD   0x20    /* frame includes data padding */
#define IEEE80211_BPF_RTS       0x40    /* tx with RTS/CTS */
#define IEEE80211_BPF_CTS       0x80    /* tx with CTS only */
         uint8_t         ibp_pri;        /* WME/WMM AC+tx antenna */
         uint8_t         ibp_try0;       /* series 1 try count */
         uint8_t         ibp_rate0;      /* series 1 IEEE tx rate */
         uint8_t         ibp_power;      /* tx power (device units) */
         uint8_t         ibp_ctsrate;    /* IEEE tx rate for CTS */
         uint8_t         ibp_try1;       /* series 2 try count */
         uint8_t         ibp_rate1;      /* series 2 IEEE tx rate */
         uint8_t         ibp_try2;       /* series 3 try count */
         uint8_t         ibp_rate2;      /* series 3 IEEE tx rate */
         uint8_t         ibp_try3;       /* series 4 try count */
         uint8_t         ibp_rate3;      /* series 4 IEEE tx rate */

Note that using a monitor mode interface for transmit is a bad idea.  It 
is likely you will encounter devices that disallow any packet transmit 
when operating in monitor mode.  In practice this can be worked around 
by using a non-monitor operating mode for the device (e.g. adhoc mode 
w/o setting up beacons) but exporting this notion to user mode is bad 
IMO.  In net80211 there is an adhoc-demo mode which is essentially adhoc 
mode which was originally added for functionality found in old lucent 
cards but more recently has been used for building applications that 
want a "raw 802.11 device".

	Sam
