Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:36314 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdCETaP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Mar 2017 14:30:15 -0500
Received: by mail-wr0-f170.google.com with SMTP id u108so103438826wrb.3
        for <linux-wireless@vger.kernel.org>; Sun, 05 Mar 2017 11:30:14 -0800 (PST)
Subject: Re: [RFC] cfg80211: Add support for FILS shared key authentication
 offload
To: Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@qca.qualcomm.com>
References: <1488542006-11776-1-git-send-email-jouni@qca.qualcomm.com>
 <1488544081.25750.5.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <078be4ec-c3d1-cde9-3032-d31349db5fe5@broadcom.com> (sfid-20170305_203020_649788_505BF48B)
Date: Sun, 5 Mar 2017 20:20:05 +0100
MIME-Version: 1.0
In-Reply-To: <1488544081.25750.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-3-2017 13:28, Johannes Berg wrote:
>> +void cfg80211_connect_done(struct net_device *dev, const u8 *bssid,
>> +			   struct cfg80211_bss *bss, const u8
>> *req_ie,
>> +			   size_t req_ie_len, const u8 *resp_ie,
>> +			   size_t resp_ie_len, const u8 *fils_kek,
>> +			   size_t fils_kek_len, bool
>> update_erp_seq_num,
>> +			   u16 fils_erp_seq_num, const u8 *pmk,
>> size_t pmk_len,
>> +			   const u8 *pmkid, int status, gfp_t gfp,
>> +			   enum nl80211_timeout_reason
>> timeout_reason);
> Ouch. Please declare most of those (perhaps other than dev) as a
> structure and pass a pointer here.
> 
> Also, why require the BSSID when BSS is set? Seems you could say one or
> the other.

The BSSID/BSS behaviour is already present in current
cfg80211_connect_bss(). bss may be NULL which will result in lookup
using the given bssid.

Regards,
Arend
