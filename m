Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34147 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbF0VtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 17:49:20 -0400
Received: by wgqq4 with SMTP id q4so113334188wgq.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2015 14:49:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	<CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	<CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	<1435082418.2777.11.camel@ipeer-box>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
Date: Sat, 27 Jun 2015 23:49:18 +0200
Message-ID: <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com> (sfid-20150627_234925_073191_A31AF065)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 June 2015 at 14:20, Peer, Ilan <ilan.peer@intel.com> wrote:
> Hi Janusz,
>
> Any chance you can check if the attached patch fixes the issue you reported?
>
> Thanks in advance,
>
I just check the mac80211/cfg80211 code, and I am not sure this direct
probe could work correctly.

Function ieee80211_rx_mgmt_probe_resp() is interesting.
Seems we call
ieee80211_rx_bss_info() -> ieee80211_bss_info_update ->
cfg80211_inform_bss_width_frame() -> cfg80211_bss_update() -> this
could set bss->proberesp_ies
and after that check:

        if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
            ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss->bssid)) {
                /* got probe response, continue with auth */
                sdata_info(sdata, "direct probe responded\n");

So, ifmgd->auth_data->bss->proberesp_ies could be set before check?

BTW, During my tests (no matter which card used) I never saw this msg:
sdata_info(sdata, "direct probe responded\n");
And always saw 3 failed direct probes.

@Johannes: Is that possible or I miss something.

BR
Janusz

> Ilan.
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Peer, Ilan
>> Sent: Tuesday, June 23, 2015 21:00
>> To: chaitanya.mgit@gmail.com
>> Cc: linux-wireless@vger.kernel.org; janusz.dziedzic@tieto.com
>> Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
>> direct probe issue
>>
>> -----Original Message-----
>> From: Krishna Chaitanya
>> <chaitanya.mgit@gmail.com<mailto:Krishna%20Chaitanya%20%3cchaitanya.m
>> git@gmail.com%3e>>
>> To: "Peer, Ilan"
>> <ilan.peer@intel.com<mailto:%22Peer,%20Ilan%22%20%3cilan.peer@intel.c
>> om%3e>>
>> Cc: Janusz Dziedzic
>> <janusz.dziedzic@tieto.com<mailto:Janusz%20Dziedzic%20%3cjanusz.dziedzic
>> @tieto.com%3e>>, linux-wireless@vger.kernel.org <linux-
>> wireless@vger.kernel.org<mailto:%22linux-
>> wireless@vger.kernel.org%22%20%3clinux-wireless@vger.kernel.org%3e>>
>> Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
>> direct probe issue
>> Date: Tue, 23 Jun 2015 17:34:59 +0530
>>
>>
>>
>> On Tue, Jun 23, 2015 at 5:25 PM, Peer, Ilan
>> <ilan.peer@intel.com<mailto:ilan.peer@intel.com>> wrote:
>> >> >>
>> >> >> I suspect this is because of P2P_GO NoA?
>> >> >> Who should care about this direct probes tx when GO is not present?
>> >> >>
>> >> >> In case we didn't send direct probes - there is no problem and TC
>> >> >> works correctly
>> >> >>
>> >> >
>> >> > Interesting :)
>> >> >
>> >> > Any chance you can provide trace-cmd and sniffer capture?
>> >> >
>> >> > Normally, if we provided the FW with the BSSID information and TSF
>> >> > information for syncing, once the FW hears the 1st beacon with the
>> >> > NoA it should sync on it and not try to attempt to transmit any
>> >> > frames as long as the AP is absent. It might also be related to the
>> >> > fact that the probe requests are sent to broadcast address, but I
>> >> > need to further checks this. Anyway, having some data would help ;)
>> >> >
>> >> Thats exactly the point, if GO is in NoA FW will not transmit but
>> >> mac80211 timed-out for direct probe.
>> >>
>> >> So the question is should mac80211 even send the direct probe in this
>> >> case when GO is in NoA?
>> >
>> > I think that this should be the driver's/FW responsibility, as at this stage
>> mac80211 already configured all the information needed for the driver to
>> sync (assuming it heard a beacon/probe) and in addition mgd_prepare_tx() is
>> called to have the driver/FW prepare for a transmission of the mgmt. frame,
>> including synchronization with the P2P GO power state.
>> Agree, the actual transmission should definitely be in driver/FW but the
>> timeout for such frames are still at mac80211, so unless su it synchronizes the
>> timeouts to GO NoA period this "can" fail depending on the absence period of
>> GO. Default auth_timeout is 200ms.
>>
>>
>> I do not think that mac80211 should handle the synchronization, mostly since
>> it does not  get the beacons from the AP we are associated with.  As I
>> explained above, this should be the drivers/FW responsibility once they have
>> all the information they require. As such, I think that is expected from the
>> driver/FW to only send the frames when the P2P GO/AP is on the channel.
>>
>> Regards,
>>
>> Ilan.
>>
>>
>>
>> N     r  y   b X  ǧv ^ )޺{.n +    {  *ޕ , {ay  ʇڙ ,j   f   h   z   w       j:+v   w j m         zZ+
>> ݢj"  ! i
