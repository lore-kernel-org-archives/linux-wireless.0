Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44781 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbeEPMYo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:24:44 -0400
Received: by mail-wr0-f193.google.com with SMTP id y15-v6so754627wrg.11
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 05:24:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87efibkf81.fsf@codeaurora.org>
References: <1526468599-14665-1-git-send-email-sushant2k1513@gmail.com>
 <1526468599-14665-2-git-send-email-sushant2k1513@gmail.com> <87efibkf81.fsf@codeaurora.org>
From: sushant kumar mishra <sushant2k1513@gmail.com>
Date: Wed, 16 May 2018 17:54:02 +0530
Message-ID: <CAJD5TLZnZB=3i8bN74ax9V+aBbYyEYPrOgYoTG4vN5hNSiiBYQ@mail.gmail.com> (sfid-20180516_142448_735853_6DD423C1)
Subject: Re: [v2] rsi: add support for hardware scan offload
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2018 at 5:03 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Sushant Kumar Mishra <sushant2k1513@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> With the current approach of scanning, roaming delays are observed.
>> Firmware has support for back ground scanning. To get this advantage,
>> mac80211 hardware scan is implemented, which decides type of scan to
>> do based on connected state.
>>
>> When station is in not connected state, this returns operation not
>> supported(-EPERM) to trigger software scan in mac80211. In case of
>> connected state background scan will be triggered.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
>
> This patch looks much better, thanks. But the subject should be:
>
> [PATCH v2 2/2] rsi: add support for hardware scan offload
>
>> +static int rsi_prepare_probe_request(struct rsi_common *common,
>> +                                  struct cfg80211_scan_request *scan_req,
>> +                                  u8 n_ssid, u8 channel, u8 *pbreq,
>> +                                  u16 *pbreq_len, struct ieee80211_vif *vif)
>> +{
>> +     struct cfg80211_ssid *ssid_info;
>> +     struct ieee80211_hdr *hdr = NULL;
>> +     u8 *pos;
>> +
>> +     if (common->priv->sc_nvifs <= 0)
>> +             return -ENODEV;
>> +     if (!scan_req)
>> +             return -EINVAL;
>> +     if (!scan_req->ssids)
>> +             return -EINVAL;
>> +     ssid_info = &scan_req->ssids[n_ssid];
>> +     hdr = (struct ieee80211_hdr *)pbreq;
>> +     hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
>> +                                      IEEE80211_STYPE_PROBE_REQ);
>> +     hdr->duration_id = 0x0;
>> +     memset(hdr->addr1, 0xff, ETH_ALEN);
>> +     memset(hdr->addr3, 0xff, ETH_ALEN);
>> +     ether_addr_copy(hdr->addr2, vif->addr);
>> +     hdr->seq_ctrl = 0x00;
>> +     pos = (u8 *)hdr + MIN_802_11_HDR_LEN;
>> +
>> +     *pos++ = WLAN_EID_SSID;
>> +     *pos++ = ssid_info->ssid_len;
>> +     if (ssid_info->ssid_len)
>> +             memcpy(pos, ssid_info->ssid, ssid_info->ssid_len);
>> +     pos += ssid_info->ssid_len;
>> +
>> +     if (scan_req->ie_len)
>> +             memcpy(pos, scan_req->ie, scan_req->ie_len);
>> +     pos += scan_req->ie_len;
>> +     *pbreq_len = pos - pbreq;
>> +
>> +     return 0;
>> +}
>
> But can't you use ieee80211_probereq_get()?

Thanks for the input. We ll address this in updated version.
Regards,
Sushant
