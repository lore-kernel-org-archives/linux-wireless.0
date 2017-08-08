Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdHHRc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 13:32:57 -0400
Subject: Re: [PATCH v4 10/10] wil6210: make debugfs compilation optional
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        qca_merez <qca_merez@qca.qualcomm.com>
Cc: QCA_gidons <QCA_gidons@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1501787302-22885-11-git-send-email-qca_merez@qca.qualcomm.com>
 <87r2wmianc.fsf@kamboji.qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Message-ID: <51c889b0-de30-ea32-13d7-264f94eed158@codeaurora.org> (sfid-20170808_193301_046923_535FCBB8)
Date: Tue, 8 Aug 2017 20:32:52 +0300
MIME-Version: 1.0
In-Reply-To: <87r2wmianc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8/8/2017 2:03 PM, Kalle Valo wrote:
> Maya Erez <qca_merez@qca.qualcomm.com> writes:
> 
>> From: Gidon Studinski <qca_gidons@qca.qualcomm.com>
>>
>> Since debugfs is a kernel configuration option, enable the driver to
>> compile without debugfs.
>>
>> Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/wil6210/Makefile  | 2 +-
>>  drivers/net/wireless/ath/wil6210/wil6210.h | 6 ++++++
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
>> index 4ae21da..63a751a 100644
>> --- a/drivers/net/wireless/ath/wil6210/Makefile
>> +++ b/drivers/net/wireless/ath/wil6210/Makefile
>> @@ -4,7 +4,7 @@ wil6210-y := main.o
>>  wil6210-y += netdev.o
>>  wil6210-y += cfg80211.o
>>  wil6210-y += pcie_bus.o
>> -wil6210-y += debugfs.o
>> +wil6210-$(CONFIG_DEBUG_FS) += debugfs.o
>>  wil6210-y += wmi.o
>>  wil6210-y += interrupt.o
>>  wil6210-y += txrx.o
>> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
>> index cf20a8c..d7b1e03 100644
>> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
>> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
>> @@ -940,8 +940,14 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>>  			 struct cfg80211_mgmt_tx_params *params,
>>  			 u64 *cookie);
>>  
>> +#if defined(CONFIG_DEBUG_FS)
>>  int wil6210_debugfs_init(struct wil6210_priv *wil);
>>  void wil6210_debugfs_remove(struct wil6210_priv *wil);
>> +#else
>> +static inline int wil6210_debugfs_init(struct wil6210_priv *wil) { return 0; }
>> +static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
>> +#endif
> 
> I was thinking more that should we have CONFIG_WIL6210_DEBUGFS, just
> like we have CONFIG_ATH10K_DEBUGFS and CONFIG_ATH9K_DEBUGFS? This way it
> can be controlled per driver if debugfs interface is available or not.
> 
Hi Kalle, I am answering instead of Maya, she is currently on holiday.
We will consider this and resend the patch.
Is it possible to apply the other patches in the v4 series except this one and
patch #2 (the scan timeout module parameter)?

Thanks,
Lior
