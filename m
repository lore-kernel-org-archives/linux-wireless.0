Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24546 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762387AbYCEKbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 05:31:11 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT flags
Date: Wed, 5 Mar 2008 12:29:13 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com> (sfid-20080305_103116_560963_4DADF503)
In-Reply-To: <1204711417.25502.59.camel@johannes.berg>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com> <1204682972-26004-2-git-send-email-reinette.chatre@intel.com> <1204682972-26004-3-git-send-email-reinette.chatre@intel.com> <1204682972-26004-4-git-send-email-reinette.chatre@intel.com> <1204682972-26004-5-git-send-email-reinette.chatre@intel.com> <1204682972-26004-6-git-send-email-reinette.chatre@intel.com> <1204710116.25502.48.camel@johannes.berg> <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com> (sfid-20080305_100051_308051_571E68F9) <1204711417.25502.59.camel@johannes.berg>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>-----Original Message-----
>From: Johannes Berg [mailto:johannes@sipsolutions.net]
>Sent: Wednesday, March 05, 2008 12:04 PM
>To: Rindjunsky, Ron
>Cc: Chatre, Reinette; linville@tuxdriver.com; linux-
>wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net; Winkler,
>Tomas
>Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags
andHT
>flags
>
>
>On Wed, 2008-03-05 at 12:00 +0200, Ron Rindjunsky wrote:
>> > > Tx command can be a combination of any of these flags, along with
>> > > bitrate represented by ieee80211_rate. this will allow legacy
drivers
>to
>> > > switch easily to any 11n rate representation.
>> >
>> > Looks good, but I wonder if there's any chance we'll see a generic
rate
>> > control algorithm use these flags? I.e. one not tied to Intel HW
and
>> > hidden in the iwlwifi subdir.
>> >
>> I sure hope so. the problem with current use of ieee80211_rates is
>> since it is targeted for ABG rates you can have all rates ready in
>> advance in the ieee80211_rates vector, but as soon an algorithm will
>> need to move those rates to siso/mimo, 40 mhz, ect. each combination
>> will multiple this vector, ending in a very big one. using the flags
>> will allow any rate scaling algorithm to keep using current
>> ieee80211_rates vector method, with any flags combination suitable.
>
>Hmm. Can you explain the new HT flags a bit better?

All the flags we added are from spec there are not 4965 specific 

>
>What, for example, is OFDM_HT? What happens when you select a bitrate
>of, say, 11MBit and have the 40_MHZ_WIDTH flag set?

HT doesn't work on CCK modulations, so this flag just basically says
it's HT rate and not legacy rate.

Tomas



>johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

