Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f195.google.com ([209.85.221.195]:43252 "EHLO
	mail-qy0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZFHTPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:15:25 -0400
Received: by qyk33 with SMTP id 33so312164qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 12:15:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906081130q3f8363c2i64e05d61812e7be3@mail.gmail.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
	<1244246629-28179-14-git-send-email-lrodriguez@atheros.com>
	<69e28c910906081130q3f8363c2i64e05d61812e7be3@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 8 Jun 2009 12:15:07 -0700
Message-ID: <43e72e890906081215u54f76ae6uded65345829ea843@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] iwlwifi: use ieee80211_is_data(fc)
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/8 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sat, Jun 6, 2009 at 2:03 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
>> Cc: Zhu Yi <yi.zhu@intel.com>
>> Cc: Reinette Chatre <reinette.chatre@intel.com>
>> Cc: ipw3945-devel@lists.sourceforge.net
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    7 +++----
>>  drivers/net/wireless/iwlwifi/iwl-sta.c     |    5 ++---
>>  2 files changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> index 5eb538d..bd2f709 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> @@ -673,7 +673,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
>>        s8 scale_action = 0;
>>        unsigned long flags;
>>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>> -       u16 fc;
>> +       __le16 fc;
>>        u16 rate_mask = 0;
>>        s8 max_rate_idx = -1;
>>        struct iwl_priv *priv = (struct iwl_priv *)priv_r;
>> @@ -685,9 +685,8 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
>>                rate_mask = sta->supp_rates[sband->band];
>>
>>        /* Send management frames and NO_ACK data using lowest rate. */
>> -       fc = le16_to_cpu(hdr->frame_control);
>> -       if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
>> -           info->flags & IEEE80211_TX_CTL_NO_ACK ||
>> +       fc = hdr->frame_control;
>> +       if (!ieee80211_is_data(fc) || info->flags & IEEE80211_TX_CTL_NO_ACK ||
>
> iwl-agn-rs.c also needs this change I think...

You are right, but in my later patch "mac80211: add helper for
management / no-ack frame rate decision" we just nuke this in favor
for the helper. The goal of this intermediary patch was just to make
the changes for that other patch easier to read.

Please let me know if such a change is required in this intermediary
patch. It gets nuked in the end.

  Luis
