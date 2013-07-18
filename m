Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50406 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934571Ab3GRXbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 19:31:15 -0400
Received: by mail-lb0-f175.google.com with SMTP id r10so2942549lbi.6
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jul 2013 16:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E07@HASMSX106.ger.corp.intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-2-git-send-email-ilan.peer@intel.com> <CAB=NE6Wr_Y+uoGwOT_nE-VE49vd0eobv_F7=hF=mtVfGgCOehg@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DF7B@HASMSX106.ger.corp.intel.com>
 <CAB=NE6WBz36HktdvOd_Ay=xrx0LJQd=9MxxTrTFKhALS+HMHzg@mail.gmail.com> <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E07@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 18 Jul 2013 16:30:53 -0700
Message-ID: <CAB=NE6U3hBaEawcMJ27ZUFPaFo6RDUuzt9hh5AQN=eFWYMX-Hg@mail.gmail.com> (sfid-20130719_013127_805951_896811FB)
Subject: Re: [PATCH 1/3] [RFC] cfg80211: Add indoor only and GO concurrent
 channel attributes
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>,
	"Ginsburg, Noam" <noam.ginsburg@intel.com>,
	"Perelmooter, Liraz" <liraz.perelmooter@intel.com>,
	"Shalev, Oz" <oz.shalev@intel.com>,
	Michael Green <green@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 17, 2013 at 11:47 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
> On some day Luis wrote:
>
>> Based on the documentation I reviewed and your proposal it'd seem to me that
>> we can distinguish GO on the upper layers and determine if a channel is DFS or
>> not by just the DFS flag. The next hint you'd need is if the GO got regulatory
>> information from a master somehow, no?
>
> This should also be handled by user space, based on the device type/sub type of the local device directly, or
> indirectly through other means such a managed interface associating with an AP that it's device type
> value is 6 etc.

This seems reasonable but we need to also consider state machine
changes possible on the channel the GO is on as well and there are
different reasons for the channel to change:

  * beacon hint - nl80211_send_beacon_hint_event()
  * regulatory change - nl80211_send_reg_change_event()

The beacon hint multicast group message sends the channel prior to the
beacon hint and after. The regulatory change event currently isn't as
atomic and only provides the the fact that regulatory domain state
machine has incurred a change. In this case it may make sense to send
all wiphy information and have hostapd verify if a change has occurred
on the channel.

>> That is I am not seeing a need for a new flag at this point in wireless-regdb,
>> given also I mentioned another type of case for regulatory hints technically
>> possible (cellular base station hints but it seems only allowed with exceptional
>> review by the FCC).
>>
>> I take it what you want to enable here is GO operation on DFS channels and use
>> country IEs to determine if you can use GO, but if you do have GO enabled then
>> you'd want hooks to not daisy chain, ack?
>
> Currently, we do not intend to base the relaxation on the country IE directly,

Its still a possibility so it should be handled and we should consider
it on core regulatory. One possible solution might be to not enable GO
unless the the NL80211_ATTR_REG_INITIATOR was something appropriate
for the wiphy.

> but base it on the fact that if
> there is a managed connection to an AP who's not a mobile device (assuming that it is an authorized master),

How do you intend on verifying a device that has associated to an AP,
that that AP is not a mobile device, ie that it fits this "authorized
master" category ?

> than the channel used by the managed connection is valid for use (as long as the managed interface
> is connected to the AP on the channel).

Makes sense.

  Luis
