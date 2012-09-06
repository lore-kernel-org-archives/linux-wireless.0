Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:29763
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab2IFMFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 08:05:00 -0400
Message-ID: <50489165.1080902@posedge.com> (sfid-20120906_140506_310171_502216BD)
Date: Thu, 6 Sep 2012 17:34:53 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC v2] cfg80211: VHT regulatory
References: <5046FB3D.6090803@posedge.com>  <1346852356.4364.9.camel@jlt4.sipsolutions.net>  <50481C2E.5040303@posedge.com> <1346925298.5469.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346925298.5469.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2012 03:24 PM, Johannes Berg wrote:
> On Thu, 2012-09-06 at 09:14 +0530, Mahesh Palivela wrote:
>> On 09/05/2012 07:09 PM, Johannes Berg wrote:
>
> No, it doesn't. It *derives* these. Check "Table 22-22—Fields to specify
> VHT channels" for how it actually *specifies* them.
>

hostapd.conf specifies using numbers only. hostapd converts to freq 
values, puts into NL attribs and cfg80211 directly gets freq values 
rather than channel numbers.
we have to do these calculations either in app or cfg80211. user space 
vs krnl space. I am ok either way.

>>
>> just a defensive check. I can remove it, if redundant
>
> I was thinking then it should have a WARN_ON_ONCE() maybe.
>
>

ok. will put WARN_ON_ONCE()

>>
>> This is to find the regulatory rule only. Not checking desired BW around
>> prim channel. center freq chan 42 of 36, 40, 44 and 48 for 80 MHz BW may
>> not be in list of freq values in reg rule.
>
> Hmm? Don't think I understand this. Why do you pass in the right
> bandwidth if it's not used?
>

ok. I will define new freq_reg_info_regd() to take center freq and 
desired BW and return reg_rule. I think current freq_reg_info_regd() may 
fail if we give chan 42.

>>> This seems better, but is missing the bandwidth check?
>>
>> bandwidths are checked in reg_chan_use_permitted. reg rule decides it right?
>
> I guess I don't really understand this.
>

what should I do for bandwidth check in reg_sec_chans_permitted() ?

> johannes
>
