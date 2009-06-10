Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:37180 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZFJUb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:31:57 -0400
Received: by qw-out-2122.google.com with SMTP id 5so701890qwd.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 13:31:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244660916.20900.326.camel@rc-desk>
References: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
	<1244621975-1238-5-git-send-email-lrodriguez@atheros.com>
	<1244660916.20900.326.camel@rc-desk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Jun 2009 13:31:39 -0700
Message-ID: <43e72e890906101331l22b37c4vbaa2d56ea75a61a5@mail.gmail.com>
Subject: Re: [PATCH 04/18] iwlwifi: remove rs_get_rate workaround
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 12:08 PM, reinette
chatre<reinette.chatre@intel.com> wrote:
> Hi Luis,
>
> On Wed, 2009-06-10 at 01:19 -0700, Luis R. Rodriguez wrote:
>> This removes the work around implemented for transmitting on
>> an unsupported band on iwlwifi. This was added via the patch:
>>
>> 8e1856e82cb8f541e925738bebfbc473420cda68:
>> iwlwifi: fix rs_get_rate WARN_ON()
>>
>> Cc: Mohamed Abbas <mohamed.abbas@intel.com>
>> Cc: Reinette Chatre <reinette.chatre@intel.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 ++----------
>>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   11 +----------
>>  2 files changed, 3 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> index 5eb538d..b23fd53 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>> @@ -674,28 +674,20 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
>>       unsigned long flags;
>>       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>       u16 fc;
>> -     u16 rate_mask = 0;
>> +     u16 rate_mask = sta ? sta->supp_rates[sband->band] : 0;
>>       s8 max_rate_idx = -1;
>>       struct iwl_priv *priv = (struct iwl_priv *)priv_r;
>>       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>>
>>       IWL_DEBUG_RATE(priv, "enter\n");
>>
>> -     if (sta)
>> -             rate_mask = sta->supp_rates[sband->band];
>> -
>>       /* Send management frames and NO_ACK data using lowest rate. */
>>       fc = le16_to_cpu(hdr->frame_control);
>>       if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
>>           info->flags & IEEE80211_TX_CTL_NO_ACK ||
>>           !sta || !priv_sta) {
>>               IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
>> -             if (!rate_mask)
>> -                     info->control.rates[0].idx =
>> -                                     rate_lowest_index(sband, NULL);
>> -             else
>> -                     info->control.rates[0].idx =
>> -                                     rate_lowest_index(sband, sta);
>> +             info->control.rates[0].idx = rate_lowest_index(sband, sta);
>>               if (info->flags & IEEE80211_TX_CTL_NO_ACK)
>>                       info->control.rates[0].count = 1;
>>               return;
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> index ff20e50..3fea027 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
>> @@ -2466,7 +2466,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
>>       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>>       struct iwl_lq_sta *lq_sta = priv_sta;
>>       int rate_idx;
>> -     u64 mask_bit = 0;
>>
>>       IWL_DEBUG_RATE_LIMIT(priv, "rate scale calculate new rate for skb\n");
>>
>> @@ -2481,18 +2480,10 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
>>                       lq_sta->max_rate_idx = -1;
>>       }
>>
>> -     if (sta)
>> -             mask_bit = sta->supp_rates[sband->band];
>> -
>>       /* Send management frames and NO_ACK data using lowest rate. */
>>       if (!ieee80211_is_data(hdr->frame_control) ||
>>           info->flags & IEEE80211_TX_CTL_NO_ACK || !sta || !lq_sta) {
>> -             if (!mask_bit)
>> -                     info->control.rates[0].idx =
>> -                                     rate_lowest_index(sband, NULL);
>> -             else
>> -                     info->control.rates[0].idx =
>> -                                     rate_lowest_index(sband, sta);
>> +             info->control.rates[0].idx = rate_lowest_index(sband, sta);
>>               if (info->flags & IEEE80211_TX_CTL_NO_ACK)
>>                       info->control.rates[0].count = 1;
>>               return;
>
>
> I applied patches 1, 2, and 4 from your series. After this I can again
> trigger the rs_get_rate warning.
>
> The steps I use are:
> $ ip link set wlan0 up
> $ iwlist wlan0 scan
> $ iwconfig wlan0 channel <from G band> essid essid
> $ #assign IP and ping to test association
> $ iwconfig wlan0 channel <from A band> essid essid
>
> The last command triggers the warning below (the warning that tainted
> the kernel is this same warning):
>
> [ 6447.873784] WARNING: at /home/wifi/iwlwifi-2.6/include/net/mac80211.h:2104 rs_get_rate+0x1e5/0x430 [iwlagn]()
> [ 6447.883695] Hardware name: Santa Rosa platform
> [ 6447.888179] Modules linked in: iwlagn iwlcore led_class mac80211 cfg80211 rfkill arc4 ecb i915 drm i2c_algo_bit i2c_core binf
> mt_misc ppdev acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_ondemand cpufreq_stats freq_table cpufreq_userspace sb
> s sbshc ipv6 iptable_filter ip_tables x_tables parport_pc lp parport psmouse serio_raw pcspkr battery iTCO_wdt iTCO_vendor_support video output container ac processor button intel_agp evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod e100 mii ata_piix ehci_hcd uhci_hcd pata_acpi ata_generic libata usbcore scsi_mod thermal fan thermal_sys fuse [last unloaded: rfkill]
> [ 6447.943478] Pid: 9409, comm: iwconfig Tainted: G        W  2.6.30-rc8-wl #40
> [ 6447.950534] Call Trace:
> [ 6447.953005]  [<ffffffff8026bee9>] ? is_module_text_address+0x9/0x20
> [ 6447.959295]  [<ffffffffa055aad5>] ? rs_get_rate+0x1e5/0x430 [iwlagn]
> [ 6447.965662]  [<ffffffff80239c68>] warn_slowpath_common+0x78/0xd0
> [ 6447.971682]  [<ffffffff80239ccf>] warn_slowpath_null+0xf/0x20
> [ 6447.977451]  [<ffffffffa055aad5>] rs_get_rate+0x1e5/0x430 [iwlagn]
> [ 6447.983669]  [<ffffffffa04ed27e>] rate_control_get_rate+0xbe/0xd0 [mac80211]
> [ 6447.990745]  [<ffffffffa04f4a61>] invoke_tx_handlers+0x6b1/0xf70 [mac80211]
> [ 6447.997734]  [<ffffffffa04f3e8e>] ? __ieee80211_tx_prepare+0x1ae/0x3b0 [mac80211]
> [ 6448.005244]  [<ffffffffa04f5b75>] ieee80211_tx+0xf5/0x2f0 [mac80211]
> [ 6448.011628]  [<ffffffffa04f5b0d>] ? ieee80211_tx+0x8d/0x2f0 [mac80211]
> [ 6448.018224]  [<ffffffffa04f6b2a>] ieee80211_master_start_xmit+0x1fa/0x390 [mac80211]
> [ 6448.025974]  [<ffffffff80467d7d>] dev_hard_start_xmit+0x29d/0x340
> [ 6448.032129]  [<ffffffff8047aeb6>] __qdisc_run+0x256/0x2a0
> [ 6448.037574]  [<ffffffff80468268>] dev_queue_xmit+0x308/0x4e0
> [ 6448.043243]  [<ffffffff80467fb2>] ? dev_queue_xmit+0x52/0x4e0
> [ 6448.049059]  [<ffffffffa04f8897>] ieee80211_tx_skb+0x67/0x70 [mac80211]
> [ 6448.055751]  [<ffffffffa04e7803>] ieee80211_send_deauth_disassoc+0x113/0x160 [mac80211]
> [ 6448.063813]  [<ffffffffa04e7c20>] ieee80211_set_disassoc+0x290/0x370 [mac80211]
> [ 6448.071147]  [<ffffffffa04e7990>] ? ieee80211_set_disassoc+0x0/0x370 [mac80211]
> [ 6448.078518]  [<ffffffffa04e8037>] ieee80211_sta_req_auth+0xb7/0xe0 [mac80211]
> [ 6448.085726]  [<ffffffffa04e030b>] ieee80211_ioctl_siwessid+0xbb/0xd0 [mac80211]
> [ 6448.093086]  [<ffffffff804eaed4>] ioctl_standard_call+0x1f4/0x460
> [ 6448.099206]  [<ffffffffa04e0250>] ? ieee80211_ioctl_siwessid+0x0/0xd0 [mac80211]
> [ 6448.106643]  [<ffffffff804ea92b>] wext_handle_ioctl+0x16b/0x240
> [ 6448.112621]  [<ffffffff8046a2c2>] dev_ioctl+0x3f2/0x5e0
> [ 6448.117893]  [<ffffffff802a3432>] ? unlock_page+0x22/0x30
> [ 6448.123306]  [<ffffffff804553c9>] sock_ioctl+0x89/0x290
> [ 6448.128580]  [<ffffffff802e5441>] vfs_ioctl+0x31/0xa0
> [ 6448.133691]  [<ffffffff802e553a>] do_vfs_ioctl+0x8a/0x580
> [ 6448.139136]  [<ffffffff80256816>] ? up_read+0x26/0x30
> [ 6448.144198]  [<ffffffff802e5ac9>] sys_ioctl+0x99/0xa0
> [ 6448.149269]  [<ffffffff8020bdab>] system_call_fastpath+0x16/0x1b
> [ 6448.155317] ---[ end trace 487d6d48e50362db ]---

Please try the patch I just posted.

 Luis
