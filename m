Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0080.outbound.protection.outlook.com ([104.47.33.80]:34816
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754162AbdE0Iaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 04:30:35 -0400
Subject: Re: [PATCH] Per chain RSSI reporting
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
Message-ID: <72639156-fe54-ff1a-8af0-819a84ee2c3e@ethertronics.com> (sfid-20170527_103042_505445_9881C9A8)
Date: Sat, 27 May 2017 01:30:28 -0700
MIME-Version: 1.0
In-Reply-To: <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been looking at this more and I believe that smoothing/filtering anywh=
ere other than as close as possible to where the ppdu gets unpacked will ha=
ve the disadvantage of being negatively influenced by 'out of band' values =
since the average is not computed or averaged in the upper layers until inv=
oked from their callers? The possibility then exists for several 'out of ba=
nd' values to make their way to the upper layers if the queries happen to c=
oincide with bad values being fed from the hardware unfiltered from ppdu un=
packing.

The ath10k_htt_rx_h_channel function considers every rx event and has a 100=
% likelihood of successfully cleaning up the data.

Because of this, I think a reasonable approach would be to introduce a modu=
le parameter that can be set to a filter value with 0 as the default or no =
filter/smooth function applies.

Does something like this seem reasonable?

** in core.h
int ath10k_chain_rssi_avg;

** in core.c
module_param(ath10k_rssi_chain_avg,int,0644);
MODULE_PARAM_DESC(ath10k_chain_rssi_avg, "Running average/filter of immedia=
te per chain rssi value");

** in htt_rx.c
allocate space based on ath10k_chain_rssi_avg, do the average and cleanup


Norik


On 05/26/2017 07:09 PM, Norik Dzhandzhapanyan wrote:
> Hi Adrian,
>
> Inserting the smoothing function here is motivated by what we see as 'spi=
kes' in rssi data under weak rssi conditions. Figured its best to get rid o=
f the 'bogus' data as close to the source as possible. Also to minimize the=
 impact on the changes.
>
> I believe the averaging  that happens at higher levels is based on EWMA m=
acros in net/mac80211/sta_info.c which not wifi card/chipset specific. Didn=
't want to touch that since other cards seem to not have this spikey behavi=
or. And, it doesnt seem to have an effect on the ath10k data anyway (iw rep=
orts the exact same values for both).
>
> I wonder if it would be acceptable to pass a module load time parameter w=
hich would indicate an average factor with 0 (as default) to indicate no av=
eraging?
>
> Another option would be to add the chain_signal_avg field to the ieee8021=
1_tx_status struct in mac80211.h to expose the average value up the stack t=
his way? I haven't looked too deep on what this entails though and I didn't=
 want to risk impacting anything else.
>
> So yes.. I am OK with the per-chain RSSI changes first.
>
> Norik
>
>
> From: adrian.chadd@gmail.com <adrian.chadd@gmail.com> on behalf of Adrian=
 Chadd <adrian@freebsd.org>
> Sent: Friday, May 26, 2017 6:12 PM
> To: Norik Dzhandzhapanyan
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] Per chain RSSI reporting
>
> [snip]
>
> hiya,
>
> I have something local that I've been meaning to push up to do this,
> but with no smoothing. Ideally (!) smoothing is done optionally in
> mac80211.
>
> What do you think about just committing the per-chain RSSI stuff to
> mac80211 so it shows up right now, and then we figure out how to
> express the smoothing in mac80211 or further up the layers?
>
> (We care about packet-to-packet RSSI values for "reasons" - mostly
> bring-up and board validation, but also for runtime link checks.)
>
>
> -adrian

The contents of this transmission are Ethertronics Inc. Confidential and ma=
y contain proprietary or legally privileged information which may not be di=
sclosed, copied or distributed without the express written consent of Ether=
tronics Inc. The information is intended to be for the use of the individua=
l or entity named on this transmission. If you are not the intended recipie=
nt, be aware that any disclosure, copying, distribution or use of the conte=
nts of this information is prohibited. If you have received this transmissi=
on in error, please notify us by telephone immediately so that we can arran=
ge for the retrieval of the original documents at no cost to you. Alternati=
vely, notify the sender by replying to this transmission and delete the mes=
sage without disclosing it. Thank you
