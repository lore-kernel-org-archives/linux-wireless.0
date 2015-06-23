Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33607 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbbFWMFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 08:05:19 -0400
Received: by igbqq3 with SMTP id qq3so86646547igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 05:05:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com> <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 23 Jun 2015 17:34:59 +0530
Message-ID: <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com> (sfid-20150623_140525_956961_CC209FC5)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2015 at 5:25 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> >>
>> >> I suspect this is because of P2P_GO NoA?
>> >> Who should care about this direct probes tx when GO is not present?
>> >>
>> >> In case we didn't send direct probes - there is no problem and TC
>> >> works correctly
>> >>
>> >
>> > Interesting :)
>> >
>> > Any chance you can provide trace-cmd and sniffer capture?
>> >
>> > Normally, if we provided the FW with the BSSID information and TSF
>> > information for syncing, once the FW hears the 1st beacon with the NoA
>> > it should sync on it and not try to attempt to transmit any frames as
>> > long as the AP is absent. It might also be related to the fact that
>> > the probe requests are sent to broadcast address, but I need to
>> > further checks this. Anyway, having some data would help ;)
>> >
>> Thats exactly the point, if GO is in NoA FW will not transmit but mac80211
>> timed-out for direct probe.
>>
>> So the question is should mac80211 even send the direct probe in this case
>> when GO is in NoA?
>
> I think that this should be the driver's/FW responsibility, as at this stage mac80211 already configured all the information needed for the driver to sync (assuming it heard a beacon/probe) and in addition mgd_prepare_tx() is called to have the driver/FW prepare for a transmission of the mgmt. frame, including synchronization with the P2P GO power state.
Agree, the actual transmission should definitely be in driver/FW
but the timeout for such frames are still at mac80211, so unless
it synchronizes the timeouts to GO NoA period this "can" fail
depending on the absence period of GO. Default auth_timeout is 200ms.
