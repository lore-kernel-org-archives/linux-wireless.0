Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44173 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0LFU2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 15:28:41 -0500
Message-ID: <4CFD4773.6020304@candelatech.com>
Date: Mon, 06 Dec 2010 12:28:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux> <4CF6D8C8.2000308@candelatech.com> <4CF8A6DE.4020804@candelatech.com> <4CFAFBE1.3080505@openwrt.org> <4CFB20BA.5090300@candelatech.com> <20101206193600.GC21442@tux> <4CFD3DE3.4000207@candelatech.com> <20101206195313.GE21442@tux> <20101206195348.GF21442@tux>
In-Reply-To: <20101206195348.GF21442@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 11:53 AM, Luis R. Rodriguez wrote:
> On Mon, Dec 06, 2010 at 11:53:13AM -0800, Luis Rodriguez wrote:
>> On Mon, Dec 06, 2010 at 11:47:47AM -0800, Ben Greear wrote:
>>> On 12/06/2010 11:36 AM, Luis R. Rodriguez wrote:
>>>
>>>> Can you clarify the status of this issue. It remains unclear to me from
>>>> your above description how things are going. As I read it some things
>>>> look OK now but you still get a warning.
>>>
>>> Ok, since you asked :)
>>>
>>> I worked on this over the weekend and this morning.  I had all sorts of
>>> issues until I realized that I had one STA with non-configured SSID.
>>> It sometimes connected to one /a AP and the other STAs attempted to connect
>>> to another /n (on entirely different band) AP.  I basically got zero stations associated for any length
>>> of time due to constant channel switching.  No crashes, but lots of
>>> warnings about DMA failing to stop.
>>>
>>> Now..I've fixed this configuration issue (and adding steps to help prevent this mis-configuration
>>> again).
>>>
>>> With 16 properly configured non-encrypted stations, running with wpa-supplicant
>>> with netlink driver&  sharing scan results,  the interfaces quickly associate.
>>>
>>> However, I do continue to see DMA warnings such as these (I had picked up my
>>> portable phone, and it knocked all the interfaces offline ..here
>>> they are coming back up after I hung up the phone).
>>>
>>> Please note that I ported Felix's 2.6.37 patch he posted this morning
>>> to wireless-testing and have applied it.
>>>
>>> I'm highly tempted to just make that a WARN_ON_ONCE so at least my logs
>>> aren't spammed so heavily with the recv.c:531 DMA warning.
>>
>> You can send this change upstream as well.
>
> Also, feel free to limit the number of STAs you can have up
> physically by setting this to a number you bless yourself.

I have a feeling there is no hard limit..but if I do find one,
I'll cook up a patch.  Probably not many of us ever going to push
anywhere near what I'm trying, and folks like me can limit in
user-space if wanted...

I'll do up the warn-on-once patch shortly.

By the way, would you consider this channel-change suppression
patch, or something similar?


-------------------- drivers/net/wireless/ath/ath9k/main.c --------------------
index f026a03..6c1c43b 100644
@@ -1605,6 +1605,16 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
  		else
  			sc->sc_flags &= ~SC_OP_OFFCHANNEL;

+		/* If channels & HT are the same, then don't actually do anything.
+		 */
+		if ((sc->sc_ah->curchan == &sc->sc_ah->channels[pos]) &&
+		    (aphy->chan_is_ht == conf_is_ht(conf))) {
+			ath_print(common, ATH_DBG_CONFIG,
+				  "Skip Set channel: %d MHz, already there.\n",
+				  curchan->center_freq);
+			goto skip_chan_change;
+		}
+
  		if (aphy->state == ATH_WIPHY_SCAN ||
  		    aphy->state == ATH_WIPHY_ACTIVE)
  			ath9k_wiphy_pause_all_forced(sc, aphy);

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
