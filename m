Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:61926 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbZGPRBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 13:01:11 -0400
Received: by qyk30 with SMTP id 30so238797qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 10:01:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247690000.17896.2205.camel@rc-desk>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
	<1247616853-11221-17-git-send-email-lrodriguez@atheros.com>
	<1247690000.17896.2205.camel@rc-desk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Jul 2009 10:00:50 -0700
Message-ID: <43e72e890907161000h88ee0bbs86af870c0c9b6d68@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 16/21] mac80211: add helper for management /
	no-ack frame rate decision
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	Chittajit Mitra <Chittajit.Mitra@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Derek Smithies <derek@indranet.co.nz>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 1:33 PM, reinette
chatre<reinette.chatre@intel.com> wrote:
> Hi Luis,
>
> On Tue, 2009-07-14 at 17:14 -0700, Luis R. Rodriguez wrote:
>> All current rate control algorithms agree to send management and no-ack
>> frames at the lowest rate. They also agree to do this when sta
>> and the private rate control data is NULL. We add a hlper to mac80211
>> for this and simplify the rate control algorithm code.
>>
>> Developers wishing to make enhancements to rate control algorithms
>> are for broadcast/multicast can opt to not use this in their
>> gate_rate() mac80211 callback.
>>
>> Cc: Zhu Yi <yi.zhu@intel.com>
>> Cc: Reinette Chatre <reinette.chatre@intel.com>
>> Cc: ipw3945-devel@lists.sourceforge.net
>> Cc: Gabor Juhos <juhosg@openwrt.org>
>> Cc: Felix Fietkau <nbd@openwrt.org>
>> Cc: Derek Smithies <derek@indranet.co.nz>
>> Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/rc.c        |   14 +------------
>>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   13 ++---------
>>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    7 +-----
>>  include/net/mac80211.h                     |   23 ++++++++++++++++++++++
>>  net/mac80211/rate.c                        |   29 ++++++++++++++++++++++++++++
>>  net/mac80211/rc80211_minstrel.c            |   22 +--------------------
>>  net/mac80211/rc80211_pid_algo.c            |   11 +---------
>>  7 files changed, 59 insertions(+), 60 deletions(-)
>>
>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> index 3fea027..695a841 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> @@ -2481,13 +2481,8 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
>>       }
>>
>>       /* Send management frames and NO_ACK data using lowest rate. */
>> -     if (!ieee80211_is_data(hdr->frame_control) ||
>> -         info->flags & IEEE80211_TX_CTL_NO_ACK || !sta || !lq_sta) {
>> -             info->control.rates[0].idx = rate_lowest_index(sband, sta);
>> -             if (info->flags & IEEE80211_TX_CTL_NO_ACK)
>> -                     info->control.rates[0].count = 1;
>> +     if (rate_control_send_low(sta, priv_r, txrc))
>
> I think it should be priv_sta instead of priv_r here.
>
> The rest looks good for iwlwifi.

Good catch, thanks for testing and reviewing, will post a v2 for this.

  Luis
