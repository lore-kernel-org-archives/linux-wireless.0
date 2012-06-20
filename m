Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:55772 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab2FTIXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:23:37 -0400
Received: by lbbgj10 with SMTP id gj10so398317lbb.37
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 01:23:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340178370.4655.22.camel@jlt3.sipsolutions.net>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
	<1340178370.4655.22.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 11:23:32 +0300
Message-ID: <CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com> (sfid-20120620_102342_144448_F65DC88D)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 10:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> + * @NL80211_ATTR_SCAN_PSV_MAX_CH_TIME: Maximum passive scan time (in TUs),
>> + *   u32 attribute (similar to @NL80211_ATTR_SCAN_MAX_CH_TIME).
>> + *   Note:
>> + *    The above channel time attributes are for the %NL80211_CMD_TRIGGER_SCAN
>> + *    command. The attributes are optional, the driver will use default
>> + *    channel time values if the attribute is not set.
>> + *    If one of the min times will be greater than max or set to zero,
>> + *    -EINVAL will be returned. For the software scan only the min times
>> + *    are relevant.
>
> What if the driver doesn't support the timings?
>

The attributes are optional, so the scan will run as usual using the
default scan times defined in cfg for software scan and default driver
specific values for the hw_scan (if those exist).

>> +     if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
>> +     if (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]) {
>> +     if (info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]) {
>> +     if (info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]) {
>
> I think you should ignore the attributes if NL80211_FEATURE_SCAN_TIMES
> is not set. That will enforce that anyone implementing it sets the
> feature flag correctly, if they ever test their code at all anyway :-)
>
>

The porpoise of the NL80211_FEATURE_SCAN_TIMES (as we discussed
before) is to advertise this capability to usermode which implements
802.11k.

>> +int cfg80211_trigger_scan(struct cfg80211_registered_device *rdev)
>> +{
>> +     struct cfg80211_scan_request *request;
>> +
>> +     ASSERT_RDEV_LOCK(rdev);
>> +
>> +     request = rdev->scan_req;
>> +
>> +     if (!request)
>> +             return -EINVAL;
>> +
>> +     if (!request->min_passive_ch_time)
>> +             request->min_passive_ch_time =
>> +                   ieee80211_msec_to_tu(IEEE80211_PSV_CH_TIME_MSEC);
>> +     if (!request->min_ch_time)
>> +             request->min_ch_time =
>> +                     ieee80211_msec_to_tu(IEEE80211_CH_TIME_MSEC);
>
> I pointed this out before -- this is problematic. Userspace could
> request a max time of 10, and then this would set the min time to 30,
> which means min > max which is completely stupid. We should prevent such
> settings.
>

This check is done in nl80211_trigger_scan(), please see:

+» » if·(request->min_ch_time·>·request->max_ch_time)
+» » » return·-EINVAL;

and

+» » if·(request->min_passive_ch_time·>·request->max_passive_ch_time)
+» » » return·-EINVAL;

in this case we return EINVAL, btw this also documented:
+ *    If one of the min times will be greater than max or set to zero,
+ *    -EINVAL will be returned. For the software scan only the min times

>
>> @@ -1023,6 +1047,20 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>>               if (wiphy->bands[i])
>>                       creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
>>
>> +     if (wreq->min_channel_time) {
>> +             creq->min_ch_time = wreq->min_channel_time;
>
> are you sure that wext uses TUs?
>

yes, from "struct iw_scan_req":
	__u32		min_channel_time; /* in TU */
	__u32		max_channel_time; /* in TU */

-- 
Thanks,
Victor.
