Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF57ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D7320818
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JhoMeYaV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UXFSqciQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9D7320818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbeKIDGU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 22:06:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbeKIDGT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 22:06:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E756F60B7E; Thu,  8 Nov 2018 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541698189;
        bh=XHRcNVei2xh/nfSxR6t/n5hkOify1lqcg/ALEKnyq0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JhoMeYaVRvDS8UxDUIjvq85bJ+PpPyTJxW1PLOuA6arzaS2FpAWorbw7lIPxyO6Xy
         XV2SiMSwWnUmVNmnNiskDTI9zRA9fkMF2bwpfeyt1tdEmOrqos6RAOucUGnkCYsLr7
         zFa9DwYkdfsHAVpTBrV25f4R7GE84lYfSwhEpzpE=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 53B8D60791;
        Thu,  8 Nov 2018 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541698188;
        bh=XHRcNVei2xh/nfSxR6t/n5hkOify1lqcg/ALEKnyq0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXFSqciQni7OKSeD9c8/9vt/XuDToAiG0u4K3tvM2HD8FODryGCfn+i3HVyeyHQ2q
         8Ip993VIBDtenAIw5NfHU3DZaW5gL+rxM8dd3NDxhXq08h1YeEVXd068RDQgT/HoCZ
         N2nOxMk5S+tb/1EM4G7OqouzpsKBcMcFlQkTFPwU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 22:59:48 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
In-Reply-To: <20181106101601.526ovvmabfqrr7sl@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
 <20181106101601.526ovvmabfqrr7sl@bars>
Message-ID: <7a8662ce7744bee6d9e695c67d7e9643@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-06 15:46, Sergey Matyukevich wrote:
> Hello Tamizh,
> 
>> Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  include/net/cfg80211.h       |   14 +++++++
>>  include/uapi/linux/nl80211.h |   69 +++++++++++++++++++++++++++++++++
>>  net/wireless/nl80211.c       |   86 
>> ++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/rdev-ops.h      |   15 ++++++++
>>  net/wireless/trace.h         |   27 +++++++++++++
>>  5 files changed, 211 insertions(+)
> 
> ...
> 
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 5801d76..dd024da 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
> 
> ...
> 
>>  /**
>> @@ -4035,6 +4044,9 @@ struct wiphy_iftype_ext_capab {
>>   * @txq_limit: configuration of internal TX queue frame limit
>>   * @txq_memory_limit: configuration internal TX queue memory limit
>>   * @txq_quantum: configuration of internal TX queue scheduler quantum
>> + *
>> + * @max_data_retry_count: Maximum limit can be configured as retry 
>> count
>> + *     for a TID.
>>   */
>>  struct wiphy {
>>         /* assign these fields before you register the wiphy */
>> @@ -4171,6 +4183,8 @@ struct wiphy {
>>         u32 txq_memory_limit;
>>         u32 txq_quantum;
>> 
>> +       u8 max_data_retry_count;
>> +
>>         char priv[0] __aligned(NETDEV_ALIGN);
>>  };
> 
> Could you please clarify why do you define max_data_retry_count instead 
> of
> making use of existing wiphy params: retry_short (dot11ShortRetryLimit)
> and retry_long (dot11LongRetryLimit) ?

max_data_retry_count added to validate the max limit for the retry count 
supported by the driver.
existing wiphy parames: retry_short and retry_long can be modified 
through user command.
So, I've added this param for validation purpose. Correct me If I'm 
wrong.
> 
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index d744388..d386ad7 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
> 
> ...
> 
>> +static int nl80211_set_tid_config(struct sk_buff *skb,
>> +                                 struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
>> +       struct nlattr *tid;
>> +       struct net_device *dev = info->user_ptr[1];
>> +       const char *peer = NULL;
>> +       u8 tid_no;
>> +       int ret = -EINVAL, retry_short = -1, retry_long = -1;
>> +
>> +       tid = info->attrs[NL80211_ATTR_TID_CONFIG];
>> +       if (!tid)
>> +               return -EINVAL;
>> +
>> +       ret = nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
>> +                              nl80211_attr_tid_policy, info->extack);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (!attrs[NL80211_ATTR_TID])
>> +               return -EINVAL;
>> +
>> +       if (attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
>> +               retry_short = 
>> nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_SHORT]);
>> +               if (!retry_short ||
>> +                   retry_short > rdev->wiphy.max_data_retry_count)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       if (attrs[NL80211_ATTR_TID_RETRY_LONG]) {
>> +               retry_long = 
>> nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_LONG]);
>> +               if (!retry_long ||
>> +                   retry_long > rdev->wiphy.max_data_retry_count)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       tid_no = nla_get_u8(attrs[NL80211_ATTR_TID]);
>> +       if (tid_no >= IEEE80211_FIRST_TSPEC_TSID)
>> +               return -EINVAL;
> 
> Not that important, but this tid_no check can be placed after
> attrs[NL80211_ATTR_TID].
> 
> BTW, some special tid_no value (e.g. (u8)-1) could be used to notify 
> driver
> that retry settings should be applied for all the TIDs. IIUC the only
> required change would be to modify this tid_no sanity check.

Sure, we can use that.
> 
> Regards,
> Sergey

Thanks,
Tamizh.
