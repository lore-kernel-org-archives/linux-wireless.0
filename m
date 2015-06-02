Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35600 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704AbbFBSVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:21:41 -0400
Received: by iesa3 with SMTP id a3so139632192ies.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 11:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmhEUegGBLHv6-CZHAhAQdJUUVSRXs6S5kTW82fLFA5hQ@mail.gmail.com>
References: <1433187843-20698-1-git-send-email-cfliu.tw@gmail.com> <CA+BoTQmhEUegGBLHv6-CZHAhAQdJUUVSRXs6S5kTW82fLFA5hQ@mail.gmail.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Tue, 2 Jun 2015 11:21:00 -0700
Message-ID: <CAG5N3qHRtYMkKj=HcuF_Jg0-f8MxqVnEVm55jMNt=1xC_PhLUw@mail.gmail.com> (sfid-20150602_202146_221414_E1AC11C1)
Subject: Re: [PATCH 1/2] ath10k: add cryptmode param to support sw crypto and
 raw tx injection.
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2015 at 12:17 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 1 June 2015 at 21:44, David Liu <cfliu.tw@gmail.com> wrote:
> [...]
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -91,6 +91,7 @@ struct ath10k_skb_cb {
>>                 u8 tid;
>>                 u16 freq;
>>                 bool is_offchan;
>> +               bool nohwcrypt;
>>                 struct ath10k_htt_txbuf *txbuf;
>>                 u32 txbuf_paddr;
>>         } __packed htt;
>> @@ -349,6 +350,7 @@ struct ath10k_vif {
>>         } u;
>>
>>         bool use_cts_prot;
>> +       bool nohwcrypt;
>
> So this is a bit confusing. This is used only for tx policy only,
> right? It should be named accordingly then. The other nohwcrypt in
> skb_cb pretty much implies Tx already.
>

No, it's also for Rx.
In this patch, in mac.c, if arvif->nohwcrypt is set, ath10k_send_key()
won't install the actual key to hardware, but a clear key is
installed. This makes all matching STA's encrypted frame passthrough
HW and mac80211 can take care of decryption later in host.
(in patch V2 I will take care of the IEEE80211_HW_SW_CRYPTO_CONTROL setting)

>
> [...]
>> @@ -484,6 +491,12 @@ enum ath10k_dev_flags {
>>          * waiters should immediately cancel instead of waiting for a time out.
>>          */
>>         ATH10K_FLAG_CRASH_FLUSH,
>> +
>> +       /* Use Raw mode for Tx and Rx */
>> +       ATH10K_RAW_MODE,
>> +
>> +       /* Disable HW crypto engine */
>> +       ATH10K_HW_CRYPTO_DISABLED,
>
> You're missing the _FLAG prefix. Also this isn't documented well
> enough. RAW_MODE implies sw crypto rx, no? Perhaps a more fine grained
> approach would be better:

Thanks. Will fix.

Raw mode doesn't imply SW crypto only.
Indeed Raw mode is the only way to get sw crypto support, but it also
supports HW crypto.
I just tested both HW/SW crypto cases working fine in raw mode.

So my plan for the new cryptmode parameter has 3 values:

       0    Use HW crypto engine only. This uses native WiFi mode Tx/Rx encap

       1    Use SW crypto engine only. This uses raw mode Tx/Rx encap

       2    Supports both SW & HW crypto engine. This uses raw mode Tx/Rx encap.

Once this patch is in, I guess people would only use cryptmode=0 or 1.
For cryptmode=2, I have subsequent changes to allow per BSS based
control of HW/SW crypto selection.
Plan is to make make arvif->nohwcrypt configurable via debugfs or
nl80211 (subject to review feedback)

>
>  ATH10K_FLAG_RAW_TX,
>  ATH10K_FLAG_RAW_RX,
>  ATH10K_FLAG_SW_TX_CRYPTO,
>  ATH10K_FLAG_SW_RX_CRYPTO,
>
> Obviously not all combinations are valid/doable but I think this will
> make the code look more obvious.
>

That would be too many flags and too complex.
I'd suggest keep the proposed ATH10K_RAW_MODE and ATH10K_HW_CRYPTO_DISABLED.
Let's make Tx/Rx HW crypto always both enabled or both disabled AFA
driver is concerned.
Ben's CT 10.1 FW is a special use case and would fit into cryptmode=0
where his FW internally does the magic to disable HW Rx which is
independent to the driver.
Once Ben's FW is ready for raw mode, driver then can switch to use
cryptmode=1 or 2.

>
>>  };
>>
>>  enum ath10k_cal_mode {
>> @@ -492,6 +505,15 @@ enum ath10k_cal_mode {
>>         ATH10K_CAL_MODE_DT,
>>  };
>>
>> +enum ath10k_crypt_mode {
>> +       /* Use HW crypto engine only */
>> +       ATH10K_CRYPT_MODE_HW,
>> +       /* HW SW crypto engine only (ie. HW crypto engine disabled) */
>> +       ATH10K_CRYPT_MODE_SW,
>> +       /* Both SW & HW crypto engine supported */
>> +       ATH10K_CRYPT_MODE_HW_SW,
>
> I don't think this is clear enough (and the comments don't help at all):
>
>  ATH10K_CRYPT_MODE_HW,
>  ATH10K_CRYPT_MODE_SW,
>  ATH10K_CRYPT_MODE_SW_RX_HW_TX,
>
> It would also be nice to have some sort of indication in driver
> logs/dmesg (without any debug_masks) as to what crypto mode driver
> uses so that if someone reports a bug we can quickly see their base
> configuration. Having it completely configurable during runtime is a
> bit of a pain in this regard though.. but most people will likely just
> set cryptmode in modprobe.conf or something. Thoughts?

I will add a log line to print the cryptmode param value.

>
>
>> +};
>> +
>>  static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
>>  {
>>         switch (mode) {
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index 89eb16b..a7df05d 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1018,8 +1018,7 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
>>
>>         /* In most cases this will be true for sniffed frames. It makes sense
>>          * to deliver them as-is without stripping the crypto param. This would
>> -        * also make sense for software based decryption (which is not
>> -        * implemented in ath10k).
>> +        * also make sense for software based decryption.
>
> I guess you should update the comment even more. The "would" doesn't
> fit anymore. Instead: "This is necessary for software crypto too. "

will do.

>
> Nonetheless kudos for taking care to update comments.
>
>
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
>> index 85cca29..37fd2f83 100644
>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>> @@ -296,7 +296,7 @@ enum ath10k_hw_rate_cck {
>>  #define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
>>  #define TARGET_10X_VOW_CONFIG                  0
>>  #define TARGET_10X_NUM_MSDU_DESC               (1024 + 400)
>> -#define TARGET_10X_MAX_FRAG_ENTRIES            0
>> +#define TARGET_10X_MAX_FRAG_ENTRIES            10
>
> This is probably enough at "2" (ath10k doesn't send more than 2 tx
> fragments now). I assume fw crashes with raw tx if this isn't fixed,
> correct?
>
> Sidenote: I guess TARGET_MAX_FRAG_ENTRIES could be fixed as well. It
> might make sense for QCA61X4 hw2.1 which still uses the old Rx
> indication event and might be able to do raw txrx + swcrypto. But I'm
> a bit reluctant to change this without any testing.
>

Sure. I change it to 10 because the document I got from QCA says so.
Since this is a global setting, I will remove this and keep it =0 for
now so it doesn't affect existing HW based datapath.
Per QCA, the main issue not changing this would be SW crypto then
won't be able to handle large Rx AMSDU.
When HW is not doing Rx decryption, the whole AMSDU needs to be DMA to
host for SW based decryption & AMSDU subframe deaggregation.


>
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 77220b0..1202150 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -508,7 +508,7 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
>>         .txbf = WMI_VDEV_PARAM_UNSUPPORTED,
>>         .packet_powersave = WMI_VDEV_PARAM_UNSUPPORTED,
>>         .drop_unencry = WMI_VDEV_PARAM_UNSUPPORTED,
>> -       .tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
>> +       .tx_encap_type = WMI_10X_VDEV_PARAM_TX_ENCAP_TYPE,
>
> Hmm..
>
> Technically this isn't correct because 10.1 doesn't support this vdev
> parameter. Practically this might not matter since 10.1 won't ever
> have the appropriate fw_feature set
> (ATH10K_FW_FEATURE_RAW_MODE_SUPPORT).. unless Ben implements it in his
> 10.1 CT fork.
>

Good point. Actually I think I will leave tx_encap_type as
WMI_VDEV_PARAM_UNSUPPORTED since I don't really need to use/change it.
I used to set the per VDEV Tx encap type, but I found just use the
finer grained per Tx frame descriptor encap type control is
sufficient.


David

> Ideally you should create wmi_10_2_vdev_param_map and use it for the
> 10.2 op_version. Also you should probably update
> wmi_10_2_4_vdev_param_map as well - if 10.2 works then 10.2.4 will
> mostly like do too.
>
> I would actually even suggest for this tx_encap_type to be done in a
> separate patch as it'll change ath10k behaviour on its own. It'll be
> easier to bisect the driver later in case something will have gone
> wrong.
>
>
> Michał
