Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34102 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754990AbdLOJWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 04:22:34 -0500
Received: by mail-qk0-f182.google.com with SMTP id d66so9581426qkg.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2017 01:22:34 -0800 (PST)
Subject: Re: [PATCH] nl80211: Introduce scan flags to emphasize requested scan
 behavior
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
        Dan Williams <dcbw@redhat.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1513187523-24054-1-git-send-email-jouni@qca.qualcomm.com>
 <1513192172.28704.2.camel@redhat.com>
 <a0d4d2861a90403f8be8fc4725f34087@aphydexm01f.ap.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A339457.60609@broadcom.com> (sfid-20171215_104526_094069_608E4214)
Date: Fri, 15 Dec 2017 10:22:31 +0100
MIME-Version: 1.0
In-Reply-To: <a0d4d2861a90403f8be8fc4725f34087@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2017 7:16 PM, Sunil Dutt Undekari wrote:
>> Can't we have some kind of capability indication that the driver supports each of these flags or not?  Otherwise we get into a situation where you just have to try the flag and hope it works, since it doesn't look like drivers are required to error out if they don't support the flag.
> Sure Dan . We shall have the support for capability indication from the driver.

No top-post please. The capability indication should be done through the 
nl80211 api so I would expect to see a patch for that or just included 
in this patch. So maybe in struct wiphy add supported_scan_flags field 
and provide that through NL80211_CMD_GET_WIPHY command.

Regards,
Arend

> Regards,
> Sunil
>
>
>
> -----Original Message-----
> From: Dan Williams [mailto:dcbw@redhat.com]
> Sent: Thursday, December 14, 2017 12:40 AM
> To: Jouni Malinen <jouni@qca.qualcomm.com>; Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org; Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
> Subject: Re: [PATCH] nl80211: Introduce scan flags to emphasize requested scan behavior
>
> On Wed, 2017-12-13 at 19:52 +0200, Jouni Malinen wrote:
>> From: Sunil Dutt <usdutt@qti.qualcomm.com>
>>
>> This commit defines new scan flags (LOW_SPAN, LOW_POWER,
>> HIGH_LATENCY)
>> to emphasize the requested scan behavior for the driver. These flags
>> are optional and are mutually exclusive. Driver shall resort to
>> default behavior if a respective flag is not supported. The
>> implementation of the respective functionality can be driver/hardware
>> specific.
>
> Can't we have some kind of capability indication that the driver supports each of these flags or not?  Otherwise we get into a situation where you just have to try the flag and hope it works, since it doesn't look like drivers are required to error out if they don't support the flag.
>
> Dan
>
>> These flags can be used to control the compromise between how long a
>> scan takes, how much power it uses, and high accurate/complete the
>> scan is in finding the BSSs.
>>
>> Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
>> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
>> ---
>>   include/uapi/linux/nl80211.h | 23 ++++++++++++++++++++++-
>>   1 file changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h
>> b/include/uapi/linux/nl80211.h index 6dd6939..68fdb95 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -5059,6 +5059,11 @@ enum nl80211_timeout_reason {
>>    * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
>>    * requests.
>>    *
>> + * NL80211_SCAN_FLAG_LOW_SPAN, NL80211_SCAN_FLAG_LOW_POWER, and
>> + * NL80211_SCAN_FLAG_HIGH_ACCURACY flags are exclusive of each
>> other, i.e., only
>> + * one of them can be used in the request. If the driver does not
>> support the
>> + * requested behavior, default scan behavior will be used instead.
>> + *
>>    * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
>>    * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
>>    * @NL80211_SCAN_FLAG_AP: force a scan even if the interface is
>> configured @@ -5086,7 +5091,20 @@ enum nl80211_timeout_reason {
>>    *	and suppression (if it has received a broadcast Probe
>> Response frame,
>>    *	Beacon frame or FILS Discovery frame from an AP that the
>> STA considers
>>    *	a suitable candidate for (re-)association - suitable in
>> terms of
>> - *	SSID and/or RSSI
>> + *	SSID and/or RSSI.
>> + * @NL80211_SCAN_FLAG_LOW_SPAN: Span corresponds to the total time
>> taken to
>> + *	accomplish the scan. Thus, this flag intends the driver to
>> perform the
>> + *	scan request with lesser span/duration. It is specific to
>> the driver
>> + *	implementations on how this is accomplished. Scan accuracy
>> may get
>> + *	impacted with this flag. This flag cannot be used with
>> + * @NL80211_SCAN_FLAG_LOW_POWER: This flag intends the scan attempts
>> to consume
>> + *	optimal possible power. Drivers can resort to their
>> specific means to
>> + *	optimize the power. Scan accuracy may get impacted with
>> this flag.
>> + * @NL80211_SCAN_FLAG_HIGH_ACCURACY: Accuracy here intends to the
>> extent of scan
>> + *	results obtained. Thus HIGH_ACCURACY scan flag aims to get
>> maximum
>> + *	possible scan results. This flag hints the driver to use
>> the best
>> + *	possible scan configuration to improve the accuracy in
>> scanning.
>> + *	Latency and power use may get impacted with this flag.
>>    */
>>   enum nl80211_scan_flags {
>>   	NL80211_SCAN_FLAG_LOW_PRIORITY				
>> = 1<<0,
>> @@ -5097,6 +5115,9 @@ enum nl80211_scan_flags {
>>   	NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP		=
>> 1<<5,
>>   	NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE		
>> = 1<<6,
>>   	NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION	
>> = 1<<7,
>> +	NL80211_SCAN_FLAG_LOW_SPAN				=
>> 1<<8,
>> +	NL80211_SCAN_FLAG_LOW_POWER				=
>> 1<<9,
>> +	NL80211_SCAN_FLAG_HIGH_ACCURACY				
>> = 1<<10,
>>   };
>>
>>   /**
