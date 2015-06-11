Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f193.google.com ([209.85.223.193]:34823 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbFKSvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 14:51:14 -0400
Received: by iebtr6 with SMTP id tr6so4262312ieb.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 11:51:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=fB3_a5gx3x82FyjJZvA+WVF4=F=3958nzV=HQAt+E5g@mail.gmail.com>
References: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> <CA+BoTQ=fB3_a5gx3x82FyjJZvA+WVF4=F=3958nzV=HQAt+E5g@mail.gmail.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Thu, 11 Jun 2015 11:50:33 -0700
Message-ID: <CAG5N3qFV-XKGU5f+sBwYYWe21A2ewnB2E3fT_aAQvuKKoekc1Q@mail.gmail.com> (sfid-20150611_205123_148161_6C4295F8)
Subject: Re: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx
 injection and software crypto
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Michal for the tests you did and the additional patch to
address AMSDU limitation.
Per our discussions offline, in v4, I will squash your patch and add
your test results in the commit log.
I will also put a note that AMSDU be a known limitation when cryptmode!=0.

Thanks
David

On Tue, Jun 9, 2015 at 5:40 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 9 June 2015 at 03:13, Liu CF/TW <cfliu.tw@gmail.com> wrote:
>> This change supports hardware crypto engine bypass by enabling raw
>> Rx/Tx encap mode. This enables use cases such as software crypto and raw
>> tx injection. This change introduces a new module param 'cryptmode'.
>>
>> cryptmode:
>>
>>   0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
>>      encapsulation to the firmware. This is the default mode.
>>   1: Use sofware crypto engine globally with raw mode TX/RX encapsulation
>>      to the firmware.
>>   2: Supports both hardware and software crypto with raw mode TX/RX
>>      encapsulation to the firmware. By default hardware crypto engine is
>>      used. To use software crypto in this mode, set the per ath10k_vif
>>      'nohwcrypt' flag value to True.*
>>      *) The patch for setting vif specific 'nohwcrypt' flag when
>>         cryptmode=2 would be a separate patch to mac80211.
>>
>> Possible use case examples:
>>
>>   - Use software crypto engine in mac80211. (cryptmode=1)
>>
>>   - Support inject raw unencrypted frame on monitor interface and use
>>     hardware crypto to encrypt the injected Tx frames. (cryptmode=2)
>>
>>   - Support receive raw hardware decrypted frame with encryption header
>>     on monitor interface. (cryptmode=2)
>>
>>   - Support hybrid local & split MAC mode to support tunneling protocols
>>     such as CAPWAP: Use hardware crypto for BSS in local mode,
>>     and bypass hardware crypto for BSS in split MAC mode.
>>     (cryptmode=2, ath10k_vif nohwcrypt=0 for local mode, =1 for split MAC
>>      mode)
>>
>> Testing:
>>
>>   Used QCA988x hw 2.0 with firmware-4.bin_10.2.4.48 with
>>   backports-20150424.
>>
>>   All test case tested** with hostapd in both WPA2-PSK-TKIP (11g) and
>>   WPA2-PSK-CCMP(11n/ac). Verified ping and http to google.com works.
>>
>>   **) Need to skip ATH10K_FW_FEATURE_RAW_MODE_SUPPORT check in core.c to
>>   test firmware. After all, none of the existing QCA official firmware
>>   exports that firmware bit yet.
>>
>>   Test Case                                        cryptmode value tested
>>   ---------------------------------------------    ----------------------
>>   1. ath10k hardware crypto can encrypt/decrypt       0: PASS
>>      data frames when hostapd config the BSS in       1: Not applicable.
>>      WPA2-PSK-TKIP and WPA2-PSK-CCMP modes.           2: PASS
>>
>>   2. mac80211 software crypto can encrypt/decrypt     0: Not applicable
>>      data frames when hostapd config the BSS in       1: PASS
>>      WPA2-PSK-TKIP and WPA2-PSK-CCMP modes.           2: PASS, when vif
>>                                                          nohwcrypt=1
>>
>>   3. Monitor interface Tx: User application can       0: Not applicable
>>      inject unencrypted raw Tx frames to monitor      1: PASS (mac80211)
>>      interface for mac80211 or hardware to encrypt    2: PASS (hardware)
>>      the frames.
>>
>>   4. Monitor interface Rx: mac80211 software crypto   0: Not applicable
>>      engine can decrypt received TKIP/CCMP frames.    1: PASS
>>      User application see decrypted frames.           2: PASS, when vif
>>                                                          nohwcrypt=1
>>
>>   5. CAPWAP-like local and split MAC datapath         0: Not applicable
>>      tunneling: Setup BSS1=Local MAC mode on wlan0,   1: Not applicable
>>      BSS2=Split MAC mode on wlan0_monitor interface.  2: PASS
>>      Test BSS1 data frames can be encrypted and
>>      decrypted by ath10k hardware crypto engine
>>      while BSS2 data frames can skip both hardware &
>>      kernel mac80211 crypto engines via monitor
>>      interface to the user application fot tunneling.
>
> I've finally got to run a few tests on your patch.
>
> I've tried qca988x with 10.2.4.48-2 (fw_feature hardcoded in driver).
>
> Here's a short summary of my findings:
>
>  - cryptmode=1 can fix 4addr+802.1q VLAN tagging in both AP and STA
> modes (a problem recently reported by Cedric),
>  - your patch as-is has AP WEP broken, see below
>  - your patch as-is has TCP broken, see below
>  - your patch as-is has performance really broken, see below
>  - once patched it looks pretty solid.
>
>
> At the end of this email I'm attaching (most likely whitespace
> damaged) patch I've made on top of your patch for reviewing
> convenience.
>
> For testing/merging convenience here's a paste link: http://paste.ee/p/YMFrO
>
>
> Performance:
>
> cryptmode=1
>  ap=qca988x sta=killer1525
>   killer1525  ->  qca988x     194.496 mbps [tcp1 ip4]
>   killer1525  ->  qca988x     238.309 mbps [tcp5 ip4]
>   killer1525  ->  qca988x     266.958 mbps [udp1 ip4]
>   killer1525  ->  qca988x     477.468 mbps [udp5 ip4]
>   qca988x     ->  killer1525  301.378 mbps [tcp1 ip4]
>   qca988x     ->  killer1525  297.949 mbps [tcp5 ip4]
>   qca988x     ->  killer1525  331.351 mbps [udp1 ip4]
>   qca988x     ->  killer1525  371.528 mbps [udp5 ip4]
>  ap=killer1525 sta=qca988x
>   qca988x     ->  killer1525  331.447 mbps [tcp1 ip4]
>   qca988x     ->  killer1525  328.783 mbps [tcp5 ip4]
>   qca988x     ->  killer1525  375.309 mbps [udp1 ip4]
>   qca988x     ->  killer1525  403.379 mbps [udp5 ip4]
>   killer1525  ->  qca988x     203.689 mbps [tcp1 ip4]
>   killer1525  ->  qca988x     222.339 mbps [tcp5 ip4]
>   killer1525  ->  qca988x     264.199 mbps [udp1 ip4]
>   killer1525  ->  qca988x     479.371 mbps [udp5 ip4]
>
> vanilla
>  ap=qca988x sta=killer1525
>   killer1525  ->  qca988x     216.882 mbps [tcp1 ip4]
>   killer1525  ->  qca988x     265.066 mbps [tcp5 ip4]
>   killer1525  ->  qca988x     267.344 mbps [udp1 ip4]
>   killer1525  ->  qca988x     481.762 mbps [udp5 ip4]
>   qca988x     ->  killer1525  209.34  mbps [tcp1 ip4]
>   qca988x     ->  killer1525  231.009 mbps [tcp5 ip4]
>   qca988x     ->  killer1525  385.807 mbps [udp1 ip4]
>   qca988x     ->  killer1525  544.823 mbps [udp5 ip4]
>  ap=killer1525 sta=qca988x
>   qca988x     ->  killer1525  198.865 mbps [tcp1 ip4]
>   qca988x     ->  killer1525  232.259 mbps [tcp5 ip4]
>   qca988x     ->  killer1525  369.771 mbps [udp1 ip4]
>   qca988x     ->  killer1525  529.127 mbps [udp5 ip4]
>   killer1525  ->  qca988x     210.846 mbps [tcp1 ip4]
>   killer1525  ->  qca988x     243.255 mbps [tcp5 ip4]
>   killer1525  ->  qca988x     261.926 mbps [udp1 ip4]
>   killer1525  ->  qca988x     485.102 mbps [udp5 ip4]
>
> Note:
>  - only open network tested for RAW vs nwifi performance comparison
>  - killer1525 (qca6174 hw2.2) is 2x2 device (hence max 866mbps)
>  - used iperf
>  - OTA, devices a few cm apart from each other, no shielding
>  - tcpX/udpX, X - means number of threads used
>
> Overview:
>  - relative Tx performance drop is seen but is within reasonable and
>    expected threshold (A-MSDU must be disabled with RAW Tx)
>
>
> Connectivity:
>
> cryptmode=1
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br1vlan  OK
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br1vlan  OK
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br1vlan  OK
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br1vlan  OK
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br1vlan  OK
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br1vlan  OK
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>
> vanilla
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta          OK
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta          OK
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br       FAIL*
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br       OK
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br       OK
>  ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br1vlan  FAIL**
>  ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br1vlan  FAIL**
>  ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br1vlan  FAIL**
>  ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br1vlan  FAIL**
>  ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br1vlan  FAIL**
>  ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br1vlan  FAIL**
>  ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br1vlan  FAIL**
>  ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br1vlan  FAIL**
>
> * This is a known problem with AP with WEP and 4addr
> ** This is another known (recently reported) problem with 802.1q VLAN
> tagging and 4addr
>
> Note:
>  - each test takes all possible endpoint pairs and pings
>  - each pair-ping flushes arp table
>  - ip6 is used
>
>
> Legend:
>
> 1ap1sta:
>   [ap] ---- [sta]
>
>   endpoints: ap, sta
>
> 1ap1sta2br:
>   [veth0] [ap] ---- [sta] [veth2]
>      |     |          |     |
>   [veth1]  |          \   [veth3]
>       \   /            \  /
>       [br0]            [br1]
>
>   endpoints: veth0, veth2, br0, br1
>   note: STA works in 4addr mode, AP has wds_sta=1
>
> 1ap1sta2br1vlan:
>   [veth0] [ap] ---- [sta] [veth2]
>      |     |          |     |
>   [veth1]  |          \   [veth3]
>       \   /            \  /
>     [br0]              [br1]
>       |                  |
>     [vlan0_id2]        [vlan1_id2]
>
>   endpoints: vlan0_id2, vlan1_id2
>   note: STA works in 4addr mode, AP has wds_sta=1
>
>
> [...]
>>  static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>         {
>> @@ -991,6 +994,34 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>>                 return -EINVAL;
>>         }
>>
>> +       ar->wmi.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_NATIVE_WIFI);
>
> This is incorrect. rx_decap_mode is u32, not __le32. No need for the
> __cpu_to_le32() here.
>
>> +       switch (ath10k_cryptmode_param) {
>> +       case ATH10K_CRYPT_MODE_HW:
>> +               clear_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
>> +               clear_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
>> +               break;
>> +       case ATH10K_CRYPT_MODE_SW:
>> +       case ATH10K_CRYPT_MODE_HW_SW:
>> +               if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
>> +                             ar->fw_features)) {
>> +                       ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
>> +                       return -EINVAL;
>> +               }
>> +
>> +               set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
>> +
>> +               if (ath10k_cryptmode_param == ATH10K_CRYPT_MODE_SW)
>> +                       set_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
>> +               break;
>> +       default:
>> +               ath10k_info(ar, "invalid cryptmode: %d\n",
>> +                           ath10k_cryptmode_param);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
>> +               ar->wmi.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_RAW);
>
> Ditto. This is u32, not __le32.
>
>
> [...]
>> @@ -197,12 +198,22 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
>>                 return -EOPNOTSUPP;
>>         }
>>
>> +       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
>> +               key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>> +
>> +       if (arvif->nohwcrypt)
>> +               cmd = DISABLE_KEY;
>> +
>>         if (cmd == DISABLE_KEY) {
>>                 arg.key_cipher = WMI_CIPHER_NONE;
>>                 arg.key_data = NULL;
>>         }
>>
>> -       return ath10k_wmi_vdev_install_key(arvif->ar, &arg);
>> +       ret = ath10k_wmi_vdev_install_key(arvif->ar, &arg);
>> +
>> +       if (arvif->nohwcrypt && !ret)
>> +               return -EOPNOTSUPP;
>> +       return ret;
>
> This causes 2 problems:
>
>  a) Lots of these:
>      [ 5406.702283] ath10k_pci 0000:00:06.0: failed to install key for
> vdev 0 peer 10:0b:a9:0d:c9:e0: -95
>
>  b) WEP in AP mode fails because:
>
>      [ 5616.033102] ath10k_pci 0000:00:06.0: failed to install peer
> wep keys for vdev 0: -95
>      [ 5616.038512] ath10k_pci 0000:00:06.0: failed to associate
> station 10:0b:a9:0d:c9:e0 for vdev 0: -95
>
> See my patch how I've dealt with it for now.
>
>
> Michał
>
> ----
>
> commit 0fd8c42ad92a83c65450575e348c737917e8210a
> Author: Michal Kazior <michal.kazior@tieto.com>
> Date:   Tue Jun 9 09:57:14 2015 +0200
>
>     ath10k: fix some RAW Tx encap mode cases
>
>     A-MSDU must be disabled for RAW Tx encap mode to
>     perform well when heavy traffic is applied.
>
>     Also key handling was a bit buggy and was:
>      - spamming dmesg with -95 warnings
>      - prevented AP WEP from working
>
>     As a solution return a 1 when using software
>     crypto early in set_key(), and adjust all
>     install_key() call sites to treat 1 as non-fatal
>     retval.
>
>     Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c
> b/drivers/net/wireless/ath/ath10k/core.c
> index 0d5f157bc177..48b6bfc778b9 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1021,9 +1021,24 @@ static int
> ath10k_core_init_firmware_features(struct ath10k *ar)
>                 return -EINVAL;
>         }
>
> -       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
> +       ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
> +       ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
> +
> +       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
>                 ar->wmi.rx_decap_mode = ATH10K_HW_TXRX_RAW;
>
> +               /* Workaround:
> +                *
> +                * Firmware A-MSDU aggregation breaks with RAW Tx encap mode
> +                * and causes enormous performance issues (malformed frames,
> +                * etc).
> +                *
> +                * Disabling A-MSDU makes RAW mode stable with heavy traffic
> +                * albeit a bit slower compared to regular operation.
> +                */
> +               ar->htt.max_num_amsdu = 1;
> +       }
> +
>         /* Backwards compatibility for firmwares without
>          * ATH10K_FW_IE_WMI_OP_VERSION.
>          */
> diff --git a/drivers/net/wireless/ath/ath10k/core.h
> b/drivers/net/wireless/ath/ath10k/core.h
> index 72bd19ee6f76..e473488639a9 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -393,9 +393,6 @@ struct ath10k_debug {
>         u32 reg_addr;
>         u32 nf_cal_period;
>
> -       u8 htt_max_amsdu;
> -       u8 htt_max_ampdu;
> -
>         struct ath10k_fw_crash_data *fw_crash_data;
>  };
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c
> b/drivers/net/wireless/ath/ath10k/debug.c
> index 6ad92845de88..5b263e0dedf5 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -1358,11 +1358,8 @@ static ssize_t
> ath10k_read_htt_max_amsdu_ampdu(struct file *file,
>
>         mutex_lock(&ar->conf_mutex);
>
> -       if (ar->debug.htt_max_amsdu)
> -               amsdu = ar->debug.htt_max_amsdu;
> -
> -       if (ar->debug.htt_max_ampdu)
> -               ampdu = ar->debug.htt_max_ampdu;
> +       amsdu = ar->htt.max_num_amsdu;
> +       ampdu = ar->htt.max_num_ampdu;
>
>         mutex_unlock(&ar->conf_mutex);
>
> @@ -1397,8 +1394,8 @@ static ssize_t
> ath10k_write_htt_max_amsdu_ampdu(struct file *file,
>                 goto out;
>
>         res = count;
> -       ar->debug.htt_max_amsdu = amsdu;
> -       ar->debug.htt_max_ampdu = ampdu;
> +       ar->htt.max_num_amsdu = amsdu;
> +       ar->htt.max_num_ampdu = ampdu;
>
>  out:
>         mutex_unlock(&ar->conf_mutex);
> @@ -1900,9 +1897,6 @@ void ath10k_debug_stop(struct ath10k *ar)
>         if (ar->debug.htt_stats_mask != 0)
>                 cancel_delayed_work(&ar->debug.htt_stats_dwork);
>
> -       ar->debug.htt_max_amsdu = 0;
> -       ar->debug.htt_max_ampdu = 0;
> -
>         ath10k_wmi_pdev_pktlog_disable(ar);
>  }
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt.c
> b/drivers/net/wireless/ath/ath10k/htt.c
> index 6da6ef26143a..a4e1a1b03413 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.c
> +++ b/drivers/net/wireless/ath/ath10k/htt.c
> @@ -205,8 +205,27 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
>         }
>
>         status = ath10k_htt_verify_version(htt);
> -       if (status)
> +       if (status) {
> +               ath10k_warn(ar, "failed to verify htt version: %d\n",
> +                           status);
>                 return status;
> +       }
>
> -       return ath10k_htt_send_rx_ring_cfg_ll(htt);
> +       status = ath10k_htt_send_rx_ring_cfg_ll(htt);
> +       if (status) {
> +               ath10k_warn(ar, "failed to setup rx ring: %d\n",
> +                           status);
> +               return status;
> +       }
> +
> +       status = ath10k_htt_h2t_aggr_cfg_msg(htt,
> +                                            htt->max_num_ampdu,
> +                                            htt->max_num_amsdu);
> +       if (status) {
> +               ath10k_warn(ar, "failed to setup amsdu/ampdu limit: %d\n",
> +                           status);
> +               return status;
> +       }
> +
> +       return 0;
>  }
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h
> b/drivers/net/wireless/ath/ath10k/htt.h
> index 7e8a0d835663..58ca5337b4d1 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -1325,6 +1325,8 @@ struct ath10k_htt {
>         u8 target_version_minor;
>         struct completion target_version_received;
>         enum ath10k_fw_htt_op_version op_version;
> +       u8 max_num_amsdu;
> +       u8 max_num_ampdu;
>
>         const enum htt_t2h_msg_type *t2h_msg_types;
>         u32 t2h_msg_types_max;
> @@ -1482,6 +1484,12 @@ struct htt_rx_desc {
>  #define HTT_LOG2_MAX_CACHE_LINE_SIZE 7 /* 2^7 = 128 */
>  #define HTT_MAX_CACHE_LINE_SIZE_MASK ((1 << HTT_LOG2_MAX_CACHE_LINE_SIZE) - 1)
>
> +/* These values are default in most firmware revisions and apparently are a
> + * sweet spot performance wise.
> + */
> +#define ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT 3
> +#define ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT 64
> +
>  int ath10k_htt_connect(struct ath10k_htt *htt);
>  int ath10k_htt_init(struct ath10k *ar);
>  int ath10k_htt_setup(struct ath10k_htt *htt);
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
> b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 5758e3d413ce..2a6267ee6978 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2073,6 +2073,8 @@ void ath10k_htt_t2h_msg_handler(struct ath10k
> *ar, struct sk_buff *skb)
>                 break;
>         case HTT_T2H_MSG_TYPE_CHAN_CHANGE:
>                 break;
> +       case HTT_T2H_MSG_TYPE_AGGR_CONF:
> +               break;
>         default:
>                 ath10k_warn(ar, "htt event (%d) not handled\n",
>                             resp->hdr.msg_type);
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c
> b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index 7099e9181881..7c8156092e32 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -520,7 +520,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct
> sk_buff *msdu)
>
>         flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
>         flags1 |= SM((u16)tid, HTT_DATA_TX_DESC_FLAGS1_EXT_TID);
> -       if (msdu->ip_summed == CHECKSUM_PARTIAL) {
> +       if (msdu->ip_summed == CHECKSUM_PARTIAL &&
> +           !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
>                 flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
>                 flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
>         }
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index b6685a863e70..ce15f3ccb38d 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -172,7 +172,6 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
>                 .key_flags = flags,
>                 .macaddr = macaddr,
>         };
> -       int ret;
>
>         lockdep_assert_held(&arvif->ar->conf_mutex);
>
> @@ -201,19 +200,12 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
>         if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
>                 key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>
> -       if (arvif->nohwcrypt)
> -               cmd = DISABLE_KEY;
> -
>         if (cmd == DISABLE_KEY) {
>                 arg.key_cipher = WMI_CIPHER_NONE;
>                 arg.key_data = NULL;
>         }
>
> -       ret = ath10k_wmi_vdev_install_key(arvif->ar, &arg);
> -
> -       if (arvif->nohwcrypt && !ret)
> -               return -EOPNOTSUPP;
> -       return ret;
> +       return ath10k_wmi_vdev_install_key(arvif->ar, &arg);
>  }
>
>  static int ath10k_install_key(struct ath10k_vif *arvif,
> @@ -229,6 +221,9 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
>
>         reinit_completion(&ar->install_key_done);
>
> +       if (arvif->nohwcrypt)
> +               return 1;
> +
>         ret = ath10k_send_key(arvif, key, cmd, macaddr, flags);
>         if (ret)
>                 return ret;
> @@ -267,7 +262,7 @@ static int ath10k_install_peer_wep_keys(struct
> ath10k_vif *arvif,
>
>                 ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
>                                          addr, flags);
> -               if (ret)
> +               if (ret < 0)
>                         return ret;
>
>                 flags = 0;
> @@ -275,7 +270,7 @@ static int ath10k_install_peer_wep_keys(struct
> ath10k_vif *arvif,
>
>                 ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
>                                          addr, flags);
> -               if (ret)
> +               if (ret < 0)
>                         return ret;
>
>                 spin_lock_bh(&ar->data_lock);
> @@ -333,10 +328,10 @@ static int ath10k_clear_peer_keys(struct
> ath10k_vif *arvif,
>                 /* key flags are not required to delete the key */
>                 ret = ath10k_install_key(arvif, peer->keys[i],
>                                          DISABLE_KEY, addr, flags);
> -               if (ret && first_errno == 0)
> +               if (ret < 0 && first_errno == 0)
>                         first_errno = ret;
>
> -               if (ret)
> +               if (ret < 0)
>                         ath10k_warn(ar, "failed to remove peer wep key
> %d: %d\n",
>                                     i, ret);
>
> @@ -409,10 +404,10 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
>                         break;
>                 /* key flags are not required to delete the key */
>                 ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr, flags);
> -               if (ret && first_errno == 0)
> +               if (ret < 0 && first_errno == 0)
>                         first_errno = ret;
>
> -               if (ret)
> +               if (ret < 0)
>                         ath10k_warn(ar, "failed to remove key for %pM: %d\n",
>                                     addr, ret);
>         }
> @@ -4864,6 +4859,9 @@ static int ath10k_set_key(struct ieee80211_hw
> *hw, enum set_key_cmd cmd,
>         if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
>                 return 1;
>
> +       if (arvif->nohwcrypt)
> +               return 1;
> +
>         if (key->keyidx > WMI_MAX_KEY_INDEX)
>                 return -ENOSPC;
>
> @@ -4933,6 +4931,7 @@ static int ath10k_set_key(struct ieee80211_hw
> *hw, enum set_key_cmd cmd,
>
>         ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags);
>         if (ret) {
> +               WARN_ON(ret > 0);
>                 ath10k_warn(ar, "failed to install key for vdev %i
> peer %pM: %d\n",
>                             arvif->vdev_id, peer_addr, ret);
>                 goto exit;
> @@ -4948,13 +4947,16 @@ static int ath10k_set_key(struct ieee80211_hw
> *hw, enum set_key_cmd cmd,
>
>                 ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags2);
>                 if (ret) {
> +                       WARN_ON(ret > 0);
>                         ath10k_warn(ar, "failed to install (ucast) key
> for vdev %i peer %pM: %d\n",
>                                     arvif->vdev_id, peer_addr, ret);
>                         ret2 = ath10k_install_key(arvif, key, DISABLE_KEY,
>                                                   peer_addr, flags);
> -                       if (ret2)
> +                       if (ret2) {
> +                               WARN_ON(ret2 > 0);
>                                 ath10k_warn(ar, "failed to disable
> (mcast) key for vdev %i peer %pM: %d\n",
>                                             arvif->vdev_id, peer_addr, ret2);
> +                       }
>                         goto exit;
>                 }
>         }
> @@ -7033,7 +7035,8 @@ int ath10k_mac_register(struct ath10k *ar)
>                 goto err_free;
>         }
>
> -       ar->hw->netdev_features = NETIF_F_HW_CSUM;
> +       if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
> +               ar->hw->netdev_features = NETIF_F_HW_CSUM;
>
>         if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
>                 /* Init ath dfs pattern detector */
