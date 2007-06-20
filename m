Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:41053 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752155AbXFTP4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 11:56:20 -0400
Message-ID: <4679672D.4060503@linux.intel.com>
Date: Wed, 20 Jun 2007 10:43:09 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Hong Liu <hong.liu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [patch]mac80211: add support for iwlist channel
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>	<20070619105024.3c6c68e3@griffin.suse.cz>	<1182305425.19178.12.camel@napa-sdv1.sh.intel.com> <20070620115559.301e10eb@griffin.suse.cz>
In-Reply-To: <20070620115559.301e10eb@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Wed, 20 Jun 2007 10:10:25 +0800, Hong Liu wrote:
>> What is the meaning of IEEE80211_CHAN_W_SCAN flag? I can't find any
>> description of this flag.
> 
> It means we can tune to that channel. That way you can have all
> channels the hardware support in the channel list in ieee80211_hw_mode
> struct and mask out channels disallowed by the regulations.

The following isn't in patch form; thought I'd write it up for some
discussion purposes....

SCAN renamed TUNE, and a couple adds:

/**
 * enum ieee80211_channel_flags - Channel flag bit values
 * @IEEE80211_CHAN_W_TUNE: Hardware can tune to this channel
 * @IEEE80211_CHAN_W_ACTIVE: Channel can be used for active scanning
 * @IEEE80211_CHAN_W_IBSS: Hardware can act as IBSS Master
 * @IEEE80211_CHAN_W_RADAR: Radar spectrum enforcement applies
 * @IEEE80211_CHAN_W_TX_ALLOWED: Tx is allowed
 *
 * Any channel can be added to ieee80211_hw_mode.  If the TUNE flag
 * is not set, however, the channel will never be used.
 *
 * When the ACTIVE bit is set, probe requests can be sent
 * during scans.  If the ACTIVE bit is not set, a probe request
 * can only be sent if other 802.11 traffic is detected.
 *
 * In order to support IBSS mode, a channel must have both the
 * ACTIVE and IBSS bits set.
 *
 * On channels where RADAR is set, certain restrictions apply
 * regarding when a channel can be used.  If the client hardware
 * can detect and enforce RF silence upon radar detection, then
 * the client can transmit on RADAR channels regardless of if
 * other 802.11 RF activity exists on the channel.  If, however
 * the client hardware can not detect and enforce RF silence
 * on a radar channel, the client must "follow" another source
 * of 802.11 traffic.  This means no transmission is allowed
 * on a RADAR channel *until* traffic from a 802.11 access point
 * has been detected.  And then traffic can only be allowed so
 * long as that AP exists and is within range (so that 802.11h
 * CSA frames can be received).
 *
 * A channel without the TX_ALLOWED bit set *can not* be used
 * for any type of transmission and can only be used for passive
 * listening.  This is useful for performing network audits.
 *
 * When using the legacy wireless extension SIOGIWRANGE, only
 * channels with the TUNE and TX_ALLOWED bits will be
 * returned.  Most users of SIOGIWRANGE expect to be able to
 * use the returned results for a network association -- the
 * lack of being able to tune or transmit make a channel
 * unusable in that situation.
 */
enum ieee80211_channel_flags {
	IEEE80211_CHAN_W_TUNE = (1 << 0),
	IEEE80211_CHAN_W_ACTIVE_SCAN = (1 << 1),
	IEEE80211_CHAN_W_IBSS = (1 << 2),
	IEEE80211_CHAN_W_RADAR = (1 << 3),
	IEEE80211_CHAN_W_TX_ALLOWED = (1 << 4),
};
