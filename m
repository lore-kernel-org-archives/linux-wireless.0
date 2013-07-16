Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44787 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab3GPUnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 16:43:46 -0400
Received: by mail-wg0-f51.google.com with SMTP id e11so1062863wgh.30
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 13:43:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DF7B@HASMSX106.ger.corp.intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-2-git-send-email-ilan.peer@intel.com> <CAB=NE6Wr_Y+uoGwOT_nE-VE49vd0eobv_F7=hF=mtVfGgCOehg@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DF7B@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Jul 2013 13:43:24 -0700
Message-ID: <CAB=NE6WBz36HktdvOd_Ay=xrx0LJQd=9MxxTrTFKhALS+HMHzg@mail.gmail.com> (sfid-20130716_224354_360673_E4985C27)
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

On Wed, Jul 10, 2013 at 3:43 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> On Tue, Jul 2, 2013 at 5:28 AM, Ilan Peer <ilan.peer@intel.com> wrote:
>> > From: David Spinadel <david.spinadel@intel.com>
>> >
>> > The FCC are clarifying some soft configuration requirements, which
>> > among other includes the following:
>> >
>> > 1. Concurrent GO operation, where devices may support WFD in
>> >    bands where an authorized master (for example with DFS and
>> >    DFS and radar detection capability in the UNII band) is operating.
>>
>> Is WFD WiFi Display? Is there any strict relationship here to WFD and GO and
>> regulatory or is WFD just a use case example? Are you indicating that the FCC
>> is making special rules for cases in specific bands where GO *can* co-exist with
>> other GO devices ?
>
> WFD is WiFi direct in this context. I do not think that the FCC are making special rules only for GO specific scenarios but a more general approach where "compliance may be achieved under the guidance of an authorized master". The WFD/P2P GO case is only an example.

OK then I think cullular base station regulatory hints might be
another example. In fact I believe I am looking at the information you
might be using as reference. I am looking at public draft edit for FCC
KDB 594280:

https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122

The original KDB:

http://transition.fcc.gov/oet/ea/presentations/files/apr11/3b.SoftwareConfigurationControl-RDJS.pdf

Specifically in the above document, the draft edit, I am looking at
page 12. That actually references WiFi Direct precisely and considers
the case that a GO may need to move out of its channel if its master
device its using to configure itself also switches channels. Given
that cellular base station hints could also technically be used this
also would need to be considered for cellular base stations. But also
note on page 14 it states clearly:

"Mobile Country Codes (MCC) or Mobile Network Codes
(MNC) are not acceptable for programming host
compliance"

So it seems cellular base station hints are simply not allowed by the
FCC (unless specific approval is requested / revised). Even if the FCC
allowed for it I believe an API would need to be provided should
cellular base stations have a case where they may stop operating as
well similar to DFS.

BTW in future iterations of patches I'd appreciate if you can include
the above references to documentation given that we've pulled them up
now.

>> You annotate that this is somehow related to DFS, are the GO concurrent rules
>> that the FCC is defining only applicable to DFS frequency ranges? If so would it
>> suffice to only use DFS flag ? Or are there other special cases beyond DFS
>> frequency ranges that the FCC is creating special handling?
>>
>
> DFS was given here as an example. Generally, I think that the changes that the FCC are making are targeting various scenarios and various RF devices (for example those defined in part 15 of CFR title 47).

OK thanks. Things are clear now that I see the document that you might
be referring to.

>> Apart from the FCC are you aware of special cases handling for other
>> regulatory bodies at this point?
>
> Not that I'm aware of. Adding some more people that might know more.

Hey folks, anyone? :)

>> Note that we have already these on regdb.h from CRDA:
>>
>>
>> /*
>>  * The Linux map defined in <linux/uapi/nl80211.h> enum
>> nl80211_reg_rule_flags  */ enum reg_rule_flags {
>>         RRF_NO_OFDM             = 1<<0, /* OFDM modulation not allowed */
>>         RRF_NO_CCK              = 1<<1, /* CCK modulation not allowed */
>>         RRF_NO_INDOOR           = 1<<2, /* indoor operation not allowed */
>>         RRF_NO_OUTDOOR          = 1<<3, /* outdoor operation not allowed */
>>         RRF_DFS                 = 1<<4, /* DFS support is required to be
>>                                          * used */
>>         RRF_PTP_ONLY            = 1<<5, /* this is only for Point To Point
>>                                          * links */
>>         RRF_PTMP_ONLY           = 1<<6, /* this is only for Point To Multi
>>                                          * Point links */
>>         RRF_PASSIVE_SCAN        = 1<<7, /* passive scan is required */
>>         RRF_NO_IBSS             = 1<<8, /* IBSS is not allowed */
>> };
>>
>> Historically we don't distinguish then a type of 802.11 device that initiates
>> radiation except for the NO_IBSS rule, but that rule can be treated more as
>> legacy given that the intent and motivation behind that was that some ODMs
>> simply preferred an interpretation of regulatory rules and we *currently* don't
>> use that in much places other than custom regulatory domains defined in the
>> kernel. The PTP_ONLY and PTMP_ONLY are example other rules that could
>> potentially have been used but to this day we haven't found a use case for it
>> given that typical 802.11 devices are PTMP.
>>
>> I mention the NO_IBSS case as I'd like to try to avoid adding GO specific flag if
>> we can figure out a way to make this more generic. At this point for example I
>> think a more appropriate flag is in place:
>>
>
> Actually, this should be a GO only flag, meaning that such relaxation should not be valid for soft AP, IBSS or mesh. The intention here is limit the extend of the cell, and prevent daisy chain scenarios (assume that you allow a soft AP on such a channel and that a client associated to it, and then that device can also start a soft AP on the channel ....). Anyway, I'll need to have another look at this (might be permissible for IBSS ...)

Based on the documentation I reviewed and your proposal it'd seem to
me that we can distinguish GO on the upper layers and determine if a
channel is DFS or not by just the DFS flag. The next hint you'd need
is if the GO got regulatory information from a master somehow, no?
That is I am not seeing a need for a new flag at this point in
wireless-regdb, given also I mentioned another type of case for
regulatory hints technically possible (cellular base station hints but
it seems only allowed with exceptional review by the FCC).

I take it what you want to enable here is GO operation on DFS channels
and use country IEs to determine if you can use GO, but if you do have
GO enabled then you'd want hooks to not daisy chain, ack?

>> > 2. Indoor operation, where in bands requiring indoor operation, the
>> >    device must be programmed to detect indoor operation, or
>> >    - Device must be connected to AC Power
>>
>> Does anyone  know if the FCC considers "indoor" if we power a device through
>> the car on AC power through a converter ? Are we willing to ignore that corner
>> case?
>
> No. AC power means "mains" and not through portable DC converters (see slide 12 in https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn= 528122). It would be up to the user space to identify the device type etc. and identify if this a truly AC powered AP.

OK thanks for the clarification. I wonder if we can distinguish
between the two in userspace today. I'm happy to start pegging
frequency ranges as indoor-only on wireless-regdb even if we don't
have the userspace APIs to annotate when a device is indoor or not
yet. Patches welcomed then.

>> >    - Device must be under the control of a local master that is acting
>>
>> Interesting, so some APIs would be defined, I take it on hostapd to do the
>> proper callbacks to 'slave' type of devices that depend on the local master(s). I
>> could envision this being implemented on hostapd by expanding the AP
>> interface type and associating 'slave' devices and callbacks for updates on AP
>> device updates (channel changes, and so on). Is this work being planned?
>
> Yes. We have plans to incorporate more logic to hostap (currently into wpa_supplicant for P2P use cases).

Sweet.

  Luis
