Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54239 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3HUE7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 00:59:45 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so216790lbh.23
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 21:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVdMKmd6fPi7ugrWUVaSZeU54K+jyT=gLY2tnxvyBPogQ@mail.gmail.com>
References: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com>
	<CAGRGNgVdMKmd6fPi7ugrWUVaSZeU54K+jyT=gLY2tnxvyBPogQ@mail.gmail.com>
Date: Wed, 21 Aug 2013 07:59:43 +0300
Message-ID: <CANUX_P3X2emXmTHiDxcs9yP1VzVJ=EPgxuRa5BYGpfCeOi=Q-g@mail.gmail.com> (sfid-20130821_065956_472806_67699240)
Subject: Re: [RFC 1/2] mac80211: allow APs to send SMPS frames
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for the review.

> On Tue, Aug 20, 2013 at 9:12 PM, Emmanuel Grumbach
> <emmanuel.grumbach@intel.com> wrote:
>> SMPS code checks all over the place that the vif is
>> BSS. Remove that constraint and allow SMPS for AP too.
>>
>> Provide dummy implementation that will be used for
>> further patches.
>>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  net/mac80211/cfg.c            |   15 ++++++++++++---
>>  net/mac80211/debugfs_netdev.c |   24 +++++++++++++++---------
>>  net/mac80211/ht.c             |   38 ++++++++++++++++++++++++++++----------
>>  net/mac80211/ieee80211_i.h    |   13 ++++++++++---
>>  net/mac80211/iface.c          |    2 ++
>>  net/mac80211/mlme.c           |    2 +-
>>  6 files changed, 68 insertions(+), 26 deletions(-)
>>
>> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
>> index e601c9f..7609e47 100644
>> --- a/net/mac80211/debugfs_netdev.c
>> +++ b/net/mac80211/debugfs_netdev.c
>> @@ -245,12 +248,15 @@ static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
>>  static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
>>                                      char *buf, int buflen)
>>  {
>> -       if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> -               return -EOPNOTSUPP;
>> -
>> -       return snprintf(buf, buflen, "request: %s\nused: %s\n",
>> -                       smps_modes[sdata->u.mgd.req_smps],
>> -                       smps_modes[sdata->smps_mode]);
>> +       if (sdata->vif.type == NL80211_IFTYPE_STATION)
>> +               return snprintf(buf, buflen, "request: %s\nused: %s\n",
>> +                               smps_modes[sdata->u.mgd.req_smps],
>> +                               smps_modes[sdata->smps_mode]);
>> +       if (sdata->vif.type == NL80211_IFTYPE_AP)
>> +               return snprintf(buf, buflen, "request: %s\nused: %s\n",
>> +                               smps_modes[sdata->u.ap.req_smps],
>> +                               smps_modes[sdata->smps_mode]);
>> +       return -EINVAL;
>
> Do you intend to change the return value for this function when we
> can't do SMPS from -EOPNOTSUPP to -EINVAL?

You are right - v2 on the way with other comments I got internally.
