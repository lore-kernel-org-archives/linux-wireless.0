Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52785 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab1COVEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 17:04:44 -0400
Message-ID: <4D7FD466.1030609@openwrt.org>
Date: Tue, 15 Mar 2011 22:04:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Subject: Re: [PATCH 2.6.38] ath9k: remove support for the FIF_PROMISC_IN_BSS
 filter flag
References: <1299631692-69094-1-git-send-email-nbd@openwrt.org> <4D76D2C3.2000909@candelatech.com> <4D76D4BD.7070509@openwrt.org> <20110315205122.GI11878@tux>
In-Reply-To: <20110315205122.GI11878@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-15 9:51 PM, Luis R. Rodriguez wrote:
> On Tue, Mar 08, 2011 at 05:15:41PM -0800, Felix Fietkau wrote:
>> On 2011-03-09 2:07 AM, Ben Greear wrote:
>> > On 03/08/2011 04:48 PM, Felix Fietkau wrote:
>> >> The hardware rx filter flag triggered by FIF_PROMISC_IN_BSS is overly broad
>> >> and covers even frames with PHY errors. When this flag is enabled, this message
>> >> shows up frequently during scanning or hardware resets:
>> >>
>> >> ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
>> >>
>> >> Since promiscuous mode is usually not particularly useful, yet enabled by
>> >> default by bridging (either used normally in 4-addr mode, or with hacks
>> >> for various virtualization software), we should sacrifice it for better
>> >> reliability during normal operation.
>> >>
>> >> This patch leaves it enabled if there are active monitor mode interfaces, since
>> >> it's very useful for debugging.
>> >>
>> >> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>> >> Cc: stable@kernel.org
>> >> ---
>> >>   drivers/net/wireless/ath/ath9k/recv.c |    4 +---
>> >>   1 files changed, 1 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> >> index cb559e3..a9c3f46 100644
>> >> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> >> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> >> @@ -413,9 +413,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>> >>   	 * mode interface or when in monitor mode. AP mode does not need this
>> >>   	 * since it receives all in-BSS frames anyway.
>> >>   	 */
>> >> -	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP)&&
>> >> -	     (sc->rx.rxfilter&  FIF_PROMISC_IN_BSS)) ||
>> >> -	    (sc->sc_ah->is_monitoring))
>> >> +	if (sc->sc_ah->is_monitoring)
>> >>   		rfilt |= ATH9K_RX_FILTER_PROM;
>> >>
>> >>   	if (sc->rx.rxfilter&  FIF_CONTROL)
>> > 
>> > Should we enable this flag if we have multiple STA
>> > interfaces?  I had to add something to ath5k recently
>> > to put it into promisc to properly handle multiple STAs
>> > associated with different APs, for instance.
>> No, multiple interfaces is handled by the BSSID mask.
>> 
>> > Do you have any idea *why* enabling this flag causes the DMA error
>> > messages?
>> I don't know why exactly it happens, but it probably cannot be explained
>> without going to the details of the inner workings of the MAC/baseband
>> interaction. But as I mentioned in the description, this flag is overly
>> broad and doesn't just bypass the address match, but lets all kinds of
>> other crap through as well - in many situations where even 'normal'
>> promiscuous behavior would be completely useless.
>> I think because of that, disabling it for non-monitor operation is the
>> right thing to do.
> 
> Nice find, thanks for looking at this. Are we cured now from all of
> these rants? Or has anyone seem more?
There is definitely more. While this does reduce the occurences of the
DMA RX failure a lot, it neither fixes the root cause of this issue, nor
handles the case where a monitor mode interface is configured.
To fix the issue properly, we need more input from the hw guys.

- Felix
