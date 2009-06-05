Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:33230 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZFEGeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 02:34:19 -0400
Received: by yw-out-2324.google.com with SMTP id 5so781270ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 23:34:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244183046.22576.92.camel@johannes.local>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	<1244180502-4323-13-git-send-email-lrodriguez@atheros.com>
	<1244183046.22576.92.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 4 Jun 2009 23:34:01 -0700
Message-ID: <43e72e890906042334r5cb24fban1ba8cae92b9a3d8c@mail.gmail.com>
Subject: Re: [PATCH 12/15] mac80211: make minstrel/pid RC use
	ieee80211_is_data(fc)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 4, 2009 at 11:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-06-05 at 01:41 -0400, Luis R. Rodriguez wrote:
>
>> -     u16 fc;
>> +     __le16 fc;
>>
>>       if (txrc->rts)
>>               info->control.rates[0].count =
>> @@ -291,8 +291,7 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
>>
>>       /* Send management frames and NO_ACK data using lowest rate. */
>>       fc = le16_to_cpu(hdr->frame_control);
>> -     if (!sta || !spinfo ||
>> -         (fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
>> +     if (!sta || !spinfo || !ieee80211_is_data(fc) ||
>
> you might want to run sparse on this entire patchset.

I did, PID was not on my kconfig though, so its the only thing I
didn't test compile.

 Luis
