Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33574 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaLOT2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:43 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so10203379wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 11:28:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418668867.5731.8.camel@sipsolutions.net>
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
 <1417622897-30768-2-git-send-email-arik@wizery.com> <1418387963.2470.32.camel@sipsolutions.net>
 <CA+XVXffHzjVg_KiaFz+sdQPsV+2iTmPGGoLHE7K9dhs7mYDhWg@mail.gmail.com> <1418668867.5731.8.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 15 Dec 2014 21:28:26 +0200
Message-ID: <CA+XVXffmZD=c-B3G0FGTQ0CZh2v3ALHDwCw_66WoFgk2iqLUow@mail.gmail.com> (sfid-20141215_204736_913345_EED0513B)
Subject: Re: [PATCH v8 2/4] cfg80211: allow wiphy specific regdomain management
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2014 at 8:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-12-15 at 19:12 +0200, Arik Nemtsov wrote:
>> On Fri, Dec 12, 2014 at 2:39 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:
>> >
>> >> +void nl80211_send_reg_change_event(struct regulatory_request *request)
>> >> +{
>> >> +     nl80211_common_reg_change_event(NL80211_CMD_REG_CHANGE, request);
>> >> +}
>> >> +
>> >> +void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request)
>> >> +{
>> >> +     nl80211_common_reg_change_event(NL80211_CMD_WIPHY_REG_CHANGE, request);
>> >> +}
>> >
>> > These are trivial wrappers, I'd make them inlines.
>>
>> You mean inline here or in the header header? I'll do it here..
>
> Inline here makes no sense since it's declared in the header - it'd have
> to be in the header.

Yea, that's where I put it in v10.

Arik
