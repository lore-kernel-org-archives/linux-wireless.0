Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:60181
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505Ab2FVGr1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 02:47:27 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3] cfg80211/mac80211: 802.11ac changes
Date: Fri, 22 Jun 2012 06:47:25 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E0F@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120622_084730_456395_22393323)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CE8@mbx022-e1-nj-10.exch022.domain.local>
	 <1340302471.4489.43.camel@jlt3.sipsolutions.net>
	 <4FE36942.1090801@broadcom.com>
	 <1340303967.4489.44.camel@jlt3.sipsolutions.net>
	,<4FE36FC1.2020702@broadcom.com>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3D6F@mbx022-e1-nj-10.exch022.domain.local>,<1340346809.4491.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340346809.4491.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Friday, June 22, 2012 12:03 PM
To: Mahesh Palivela
Cc: Arend van Spriel; linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: RE: [RFC v3] cfg80211/mac80211: 802.11ac changes

On Fri, 2012-06-22 at 03:06 +0000, Mahesh Palivela wrote:
> ________________________________________
> From: Arend van Spriel [arend@broadcom.com]
> Sent: Friday, June 22, 2012 12:32 AM
> To: Johannes Berg
> Cc: Mahesh Palivela; linville@tuxdriver.com; linux-wireless@vger.kernel.org
> Subject: Re: [RFC v3] cfg80211/mac80211: 802.11ac changes
>
> On 06/21/2012 08:39 PM, Johannes Berg wrote:
> > On Thu, 2012-06-21 at 20:34 +0200, Arend van Spriel wrote:
> >> On 06/21/2012 08:14 PM, Johannes Berg wrote:
> >>> On Thu, 2012-06-21 at 16:51 +0000, Mahesh Palivela wrote:
> >>>
> >>>> +/* 802.11ac VHT Capabilities */
> >>>> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
> >>>> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454               0x00000002
> >>>
> >>> I have a feeling there should be a value for 3895, since this isn't
> >>> really a bitfield only (it doesn't make sense to set both of these, in
> >>> fact 3 is reserved)
> >>
> >> These are matching the values specified for the VHP Capability Info IE.
> >> 3895 is specified as 0. Value 3 is reserved because it is not to be
> >> regarded as a bit field.
> >
> > Right, but I think it'd make more sense to actually have the 3895 value
> > as a constant here so you're not tempted to think that you could set
>
> [MP] Should I declare another constant for this?
> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895   0

Yes I think that would be good

johannes

But every VHT capability bitfields value zero has a meaning.
Max_MPDU_len field is 2 bits. 0 - 3895, 1 - 7991, 2 - 11454, 3 - reserved
Supp_ch_width field is 2 bits. 0 - 160 MHz not supp, 1 - 160 MHz supp, 2 - 160/80+80 supp.
My point is should we have constant defines for all of those?

Thanks,
Mahesh