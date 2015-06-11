Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33853 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbFKIek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 04:34:40 -0400
Received: by wgv5 with SMTP id 5so266521wgv.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 01:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <021101d09fac$563cf090$02b6d1b0$@acksys.fr>
References: <01eb01d09f64$fd522730$f7f67590$@acksys.fr>
	<CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>
	<01f701d09f71$47ae9910$d70bcb30$@acksys.fr>
	<CA+BoTQkQyTbgctPOTSvLH76+YKkjvYySJSYtGszJ3TT35-uXQQ@mail.gmail.com>
	<01fb01d09f7c$d6bdfa00$8439ee00$@acksys.fr>
	<CA+BoTQkBPkNPCX2YJSvSBbcGe_4RT3Ua_54MVmSMwUyWef-gzA@mail.gmail.com>
	<CA+BoTQmkV9Pg9pMiVarhj_peSPFCBZykMJDx_sZ0HbQ-4NUmdA@mail.gmail.com>
	<021101d09fac$563cf090$02b6d1b0$@acksys.fr>
Date: Thu, 11 Jun 2015 10:34:39 +0200
Message-ID: <CA+BoTQ=oNea1mb4mayG6E6tZ1KLp8wZrBkL5VriW-814+rk8bA@mail.gmail.com> (sfid-20150611_103513_616082_4AD14542)
Subject: Re: ATH10K and VLAN : Frame with VLAN tag are not sent
From: Michal Kazior <michal.kazior@tieto.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2015 at 18:26, voncken <cedric.voncken@acksys.fr> wrote:
>> >>> [...]
>> >>> >> I see no reason why this should fail. The dot1q encapsulation
>> >>> >> shouldn't influence how firmware behaves.. but maybe I'm wrong.
>> >>> >>
>> >>> >> It's still unclear to me what your topology looks like. Perhaps
>> >>> >> you're having problem with environmental configuration itself?
>> >>> >> Did you try other Wi-Fi device (e.g. ath9k) instead of ath10k?
>> >>> > Yes I tested with ath9k wireless card, the same configuration
>> works.
>> >>> >
>> >>> > I did an interesting test. With ostinato software I generate an
>> >>> > ICMP
>> >>> frame without vlan tag. I changed the ethertype in the frame.
>> >>> > I tried with the ethertype 0x800 (IP), 0x801, 0x8892 (PROFINET),
>> >>> > 0x8100
>> >>> (dot1q), 0x0600. All frames are sent except when the ethertype is
>> >>> set to 0x8100. It seems the firmware do not accept the ethertype
>> 0x8100.
>> >>>
>> >>> Interesting. This may suggest firmware actually doesn't handle dot1q
>> >>> VLAN tagging properly in NWifi Tx encap mode. Can you try changing
>> >>> it to 802.3 encap and re-test, please?
>> >>>
>> >>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> >>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> >>> @@ -3172,7 +3172,7 @@ ath10k_tx_h_get_txmode(struct ath10k *ar,
>> >>> struct ieee80211_vif *vif,
>> >>>         if (ieee80211_is_data_present(fc) && sta && sta->tdls)
>> >>>                 return ATH10K_HW_TXRX_ETHERNET;
>> >>>
>> >>> -       return ATH10K_HW_TXRX_NATIVE_WIFI;
>> >>> +       return ATH10K_HW_TXRX_ETHERNET;
>> >>>  }
>> >>>
>> >>> Note: Your backports may not have the necessary code.. In which case
>> >>> it'll be difficult to do this the easy way. If that's the case I
>> >>> suggest you get latest backports or generate them yourself from the
>> >>> latest kvalo/ath master.
>> >> I will try to change my backport. But it is not easy, because I need
>> to use a cross-compiler. From openwrt website I can download a backport
>> 2015-05-08. I will try to integrate it.
>> >>
>> >> Do you know how I can generate a tar file for openwrt from kale git
>> hub?
>> >
>> > That's non-trivial as far as I understand. You could try generating a
>> > quilt patch in openwrt to update ath10k. Either some sort of manual
>> > cherry-picking of the txmode patch for ath10k or create a partial diff
>> > (e.g. only drivers/net/wireless/ath/ath10k) between openwrt backports
>> > and kvalo/ath generated backports.
>>
>> I've managed to reproduce your problem in my setup.
>>
>> With NWifi Txed frames with dot1Q VLAN tagging aren't even sent OTA and
>> are reported as not acked by firmware.
>>
>> When I changed the Tx encap mode to 802.3 (ethernet) I can see frames OTA
>> but they are corrupted 3addr frames with invalid SA/DA addresses.
>> I'm guessing this is because firmware expects explicit
>> WMI_PEER_ADD_WDS_ENTRY_CMDID to be issued when trying too use 802.3 Tx
>> encap with 4addr frames.
>>
> In my compat, I intagrated the function ath10k_tx_h_get_txmode (I don't not if it is sufficient). The frame seems be formwarded (in wireshark I can see an encapsuled Ethernet frame). I will work to find where I need to add the flag WMI_PEER_ADD_WDS_ENTRY_CMDID.

I've been playing with getting 4addr + 802.1q to work. The main
problem is mac80211 doesn't tell if an interface/peer is 4addr so
driver is forced to inspect each Tx frame and infer the addressing
mode. This isn't very efficient and is pretty ugly.

I was only able to get STA+4addr+802.1q to work with some hacks. I
didn't get AP+4addr+802.1q to work yet.

Perhaps a much better solution to your problem will be to use work
done by David, see the RAW/sw crypto patch thread:
 http://lists.infradead.org/pipermail/ath10k/2015-June/005393.html

You might not be interested in the sw crypto per se, but the RAW Tx
encap that comes with it is promising and if the patch goes in (or if
you apply it manually) you should be able to get your VLAN tagging to
work (with cryptmode=1 ath10k_core parameter) now at the cost of some
CPU waste and slower performance (no A-MSDU with RAW Tx encap).


Michał
