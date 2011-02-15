Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45614 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1BOV6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 16:58:07 -0500
Received: by iwn9 with SMTP id 9so643547iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 13:58:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297760106.3935.0.camel@jlt3.sipsolutions.net>
References: <1297351797-35031-1-git-send-email-nbd@openwrt.org>
 <1297677974.3785.9.camel@jlt3.sipsolutions.net> <AANLkTi=wkmAeBKXv8PKhVRJXFdY_NO7jS+vwFJueuBpL@mail.gmail.com>
 <1297760106.3935.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Feb 2011 13:57:47 -0800
Message-ID: <AANLkTime+EGHkWBEmN-6BZNQ=zhjtq-XT4NCWyj+3gGT@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add a field for the bitrate of the last rx
 data packet from a station
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 12:55 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-02-14 at 23:08 -0800, Luis R. Rodriguez wrote:
>> On Mon, Feb 14, 2011 at 2:06 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2011-02-10 at 16:29 +0100, Felix Fietkau wrote:
>> >> Also fix a typo in the STATION_INFO_TX_BITRATE description
>> >>
>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> >> ---
>> >>  include/linux/nl80211.h |    3 ++
>> >>  include/net/cfg80211.h  |    5 +++-
>> >>  net/wireless/nl80211.c  |   56 +++++++++++++++++++++++++++++++----------------
>> >>  3 files changed, 44 insertions(+), 20 deletions(-)
>> >>
>> >> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> >> index 821ffb9..35bfec2 100644
>> >> --- a/include/linux/nl80211.h
>> >> +++ b/include/linux/nl80211.h
>> >> @@ -1243,6 +1243,8 @@ enum nl80211_rate_info {
>> >>   * @NL80211_STA_INFO_LLID: the station's mesh LLID
>> >>   * @NL80211_STA_INFO_PLID: the station's mesh PLID
>> >>   * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
>> >> + * @NL80211_STA_INFO_RX_BITRATE: last unicast rx rate, nested attribute
>> >> + *   containing info as possible, see &enum nl80211_sta_info_txrate.
>> >
>> > I think it would make sense to restrict this to data frames, as mgmt
>> > frames will often be sent with a low rate.
>>
>> Would it be useful to show both? How about per AC?
>
> Why would anyone care about mgmt frames unless they're debugging
> something (in which case I recommend monitor interface)?

I was thinking enhancing/debugging multicast traffic.

> And normally
> rate control shouldn't care about the AC so that seems pointless?

Again, this would just informational. But sure, mon0 works too.

 Luis
