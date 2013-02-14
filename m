Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56273 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760790Ab3BNRs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:48:28 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so1195465bkw.17
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 09:48:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511CD138.70200@cozybit.com>
References: <1360786461-30107-1-git-send-email-thomas@cozybit.com>
 <1360786461-30107-2-git-send-email-thomas@cozybit.com> <511CD138.70200@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 14 Feb 2013 09:48:06 -0800
Message-ID: <CAG6hwVNS0PfTqOxTMVNQ96vUCixrou7OcY_eGuccbCUYiCuOkQ@mail.gmail.com> (sfid-20130214_184832_051070_37FAB3D0)
Subject: Re: [PATCH v2 2/3] mac80211: cache mesh beacon
To: Marco Porsch <marco@cozybit.com>
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2013 at 3:57 AM, Marco Porsch <marco@cozybit.com> wrote:
> When re-submitting, could you please check if you unintentionally removed
> the call to ieee80211_mps_set_frame_flags when building the beacon?

>> -
>> -               skb_reserve(skb, local->hw.extra_tx_headroom);
>> -               mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
>> -               memset(mgmt, 0, hdr_len);
>> -               mgmt->frame_control =
>> -                   cpu_to_le16(IEEE80211_FTYPE_MGMT |
>> IEEE80211_STYPE_BEACON);
>> -               eth_broadcast_addr(mgmt->da);
>> -               memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
>> -               memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
>> -               ieee80211_mps_set_frame_flags(sdata, NULL, (void *) mgmt);

Ouch, missed that one. Thanks.

-- 
Thomas
