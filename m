Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:51424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbYFPJI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 05:08:26 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4269325waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 02:08:26 -0700 (PDT)
Message-ID: <1ba2fa240806160208l2926eeefh7f9eaf4f54d6c25c@mail.gmail.com> (sfid-20080616_110830_519368_71476C17)
Date: Mon, 16 Jun 2008 12:08:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: 11h - Handling measurement request
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Assaf Krauss" <assaf.krauss@intel.com>
In-Reply-To: <1213605673.3803.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com>
	 <1213543410-30890-2-git-send-email-tomas.winkler@intel.com>
	 <1213605673.3803.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 11:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> This patch handles the 11h measurement request information element.
>> This is minimal requested implementation - refuse measurement.
>
> I haven't really read 11h or the -2007 wrt. the added material, but this
> seems a bit odd to me:
>
>> +static void ieee80211_send_measurement_req(struct net_device *dev,
>> +                             struct ieee80211_msrment_ie *request_ie,
>> +                             const u8 *da, const u8 *bssid,
>> +                             u8 dialog_token)
>
>> +     msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
>
> It's sending a report after all, not a request. Maybe it should just be
> named "send_measurement_action"?

Will do.

>
>> +     msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
>> +     msr_report->u.action.u.measurement.msr_elem.mode |= MSR_REPORT_REFUSED;
>
> Also, it seems to me that should be part of the arguments or you won't
> be able to use this function for anything else but sending a 'refused'
> report?

Don't mind to put it into arguments, just the argument list have to be alter
anyway if real measurement is performed and results need to be sent out.
 Currently no plans to implement  more then necessary minimum to
comply with the spec.


>
>> +/* measurement report mode field - refuse to generate a report */
>> +#define MSR_REPORT_REFUSED       BIT(2)
>
> That seems completely misplaced in sta_info.h to me?

Yep will move it to
include/linux/ieee80211.h ?

Thanks
Tomas
