Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2897 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883Ab3DDJhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 05:37:06 -0400
Message-ID: <515D49B5.6070803@broadcom.com> (sfid-20130404_113717_902821_426C75C7)
Date: Thu, 4 Apr 2013 11:36:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH for-3.9] brcmsmac: request firmware in .start()
 callback
References: <1364978488-5295-1-git-send-email-arend@broadcom.com>
 <20130403184936.GA320@tuxdriver.com>
In-Reply-To: <20130403184936.GA320@tuxdriver.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 08:49 PM, John W. Linville wrote:
>    CC      drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.o
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c: In function ‘brcms_remove’:
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:337:3: error: implicit declaration of function ‘brcms_led_unregister’ [-Werror=implicit-function-declaration]
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c: In function ‘brcms_request_fw’:
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:385:2: error: implicit declaration of function ‘brcms_release_fw’ [-Werror=implicit-function-declaration]
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c: At top level:
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:393:13: warning: conflicting types for ‘brcms_release_fw’ [enabled by default]
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:393:13: error: static declaration of ‘brcms_release_fw’ follows non-static declaration
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:385:2: note: previous implicit declaration of ‘brcms_release_fw’ was here
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:393:13: warning: ‘brcms_release_fw’ defined but not used [-Wunused-function]
> cc1: some warnings being treated as errors

Yikes. That is not properly rebased on the wireless tree. Sorry about 
that. I will correct that and send a working patch.

Gr. AvS

> On Wed, Apr 03, 2013 at 10:41:28AM +0200, Arend van Spriel wrote:
>> The firmware is requested from user-space. To assure the request
>> can be handled it is recommended to do the request upon IFF_UP.
>> For a mac80211 driver the .start() callback can be considered
>> the equivalent.
>>
>> Reported-by: John Talbut <jt@dpets.co.uk>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Piotr Haber <phaber@broadcom.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Hi John,
>>
>> Forgot this one for the 3.9 kernel, which was reported recently
>> using a system with an encrypted root filesystem although the issue
>> is more generic.
>>
>> It applies to the master branch in the wireless repository.
>>
>> Gr. AvS
>> ---
>>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  267 ++++++++++----------
>>   1 file changed, 134 insertions(+), 133 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> index c6451c6..2f063a2 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> @@ -274,6 +274,131 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>>   	}
>>   }
>>
>> +/**
>> + * This function frees the WL per-device resources.
>> + *
>> + * This function frees resources owned by the WL device pointed to
>> + * by the wl parameter.
>> + *
>> + * precondition: can both be called locked and unlocked
>> + *
>> + */
>> +static void brcms_free(struct brcms_info *wl)
>> +{
>> +	struct brcms_timer *t, *next;
>> +
>> +	/* free ucode data */
>> +	if (wl->fw.fw_cnt)
>> +		brcms_ucode_data_free(&wl->ucode);
>> +	if (wl->irq)
>> +		free_irq(wl->irq, wl);
>> +
>> +	/* kill dpc */
>> +	tasklet_kill(&wl->tasklet);
>> +
>> +	if (wl->pub) {
>> +		brcms_debugfs_detach(wl->pub);
>> +		brcms_c_module_unregister(wl->pub, "linux", wl);
>> +	}
>> +
>> +	/* free common resources */
>> +	if (wl->wlc) {
>> +		brcms_c_detach(wl->wlc);
>> +		wl->wlc = NULL;
>> +		wl->pub = NULL;
>> +	}
>> +
>> +	/* virtual interface deletion is deferred so we cannot spinwait */
>> +
>> +	/* wait for all pending callbacks to complete */
>> +	while (atomic_read(&wl->callbacks) > 0)
>> +		schedule();
>> +
>> +	/* free timers */
>> +	for (t = wl->timers; t; t = next) {
>> +		next = t->next;
>> +#ifdef DEBUG
>> +		kfree(t->name);
>> +#endif
>> +		kfree(t);
>> +	}
>> +}
>> +
>> +/*
>> +* called from both kernel as from this kernel module (error flow on attach)
>> +* precondition: perimeter lock is not acquired.
>> +*/
>> +static void brcms_remove(struct bcma_device *pdev)
>> +{
>> +	struct ieee80211_hw *hw = bcma_get_drvdata(pdev);
>> +	struct brcms_info *wl = hw->priv;
>> +
>> +	if (wl->wlc) {
>> +		brcms_led_unregister(wl);
>> +		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
>> +		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
>> +		ieee80211_unregister_hw(hw);
>> +	}
>> +
>> +	brcms_free(wl);
>> +
>> +	bcma_set_drvdata(pdev, NULL);
>> +	ieee80211_free_hw(hw);
>> +}
>> +
>> +/*
>> + * Precondition: Since this function is called in brcms_pci_probe() context,
>> + * no locking is required.
>> + */
>> +static int brcms_request_fw(struct brcms_info *wl, struct bcma_device *pdev)
>> +{
>> +	int status;
>> +	struct device *device = &pdev->dev;
>> +	char fw_name[100];
>> +	int i;
>> +
>> +	memset(&wl->fw, 0, sizeof(struct brcms_firmware));
>> +	for (i = 0; i < MAX_FW_IMAGES; i++) {
>> +		if (brcms_firmwares[i] == NULL)
>> +			break;
>> +		sprintf(fw_name, "%s-%d.fw", brcms_firmwares[i],
>> +			UCODE_LOADER_API_VER);
>> +		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
>> +		if (status) {
>> +			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
>> +				  KBUILD_MODNAME, fw_name);
>> +			return status;
>> +		}
>> +		sprintf(fw_name, "%s_hdr-%d.fw", brcms_firmwares[i],
>> +			UCODE_LOADER_API_VER);
>> +		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
>> +		if (status) {
>> +			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
>> +				  KBUILD_MODNAME, fw_name);
>> +			return status;
>> +		}
>> +		wl->fw.hdr_num_entries[i] =
>> +		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
>> +	}
>> +	wl->fw.fw_cnt = i;
>> +	status = brcms_ucode_data_init(wl, &wl->ucode);
>> +	brcms_release_fw(wl);
>> +	return status;
>> +}
>> +
>> +/*
>> + * Precondition: Since this function is called in brcms_pci_probe() context,
>> + * no locking is required.
>> + */
>> +static void brcms_release_fw(struct brcms_info *wl)
>> +{
>> +	int i;
>> +	for (i = 0; i < MAX_FW_IMAGES; i++) {
>> +		release_firmware(wl->fw.fw_bin[i]);
>> +		release_firmware(wl->fw.fw_hdr[i]);
>> +	}
>> +}
>> +
>>   static void brcms_ops_tx(struct ieee80211_hw *hw,
>>   			 struct ieee80211_tx_control *control,
>>   			 struct sk_buff *skb)
>> @@ -297,7 +422,7 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
>>   {
>>   	struct brcms_info *wl = hw->priv;
>>   	bool blocked;
>> -	int err;
>> +	int err = 0;
>>
>>   	ieee80211_wake_queues(hw);
>>   	spin_lock_bh(&wl->lock);
>> @@ -306,6 +431,14 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
>>   	if (!blocked)
>>   		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
>>
>> +	if (!wl->ucode.bcm43xx_bomminor) {
>> +		err = brcms_request_fw(wl, wl->wlc->hw->d11core);
>> +		if (err) {
>> +			brcms_remove(wl->wlc->hw->d11core);
>> +			return -ENOENT;
>> +		}
>> +	}
>> +
>>   	spin_lock_bh(&wl->lock);
>>   	/* avoid acknowledging frames before a non-monitor device is added */
>>   	wl->mute_tx = true;
>> @@ -793,128 +926,6 @@ void brcms_dpc(unsigned long data)
>>   	wake_up(&wl->tx_flush_wq);
>>   }
>>
>> -/*
>> - * Precondition: Since this function is called in brcms_pci_probe() context,
>> - * no locking is required.
>> - */
>> -static int brcms_request_fw(struct brcms_info *wl, struct bcma_device *pdev)
>> -{
>> -	int status;
>> -	struct device *device = &pdev->dev;
>> -	char fw_name[100];
>> -	int i;
>> -
>> -	memset(&wl->fw, 0, sizeof(struct brcms_firmware));
>> -	for (i = 0; i < MAX_FW_IMAGES; i++) {
>> -		if (brcms_firmwares[i] == NULL)
>> -			break;
>> -		sprintf(fw_name, "%s-%d.fw", brcms_firmwares[i],
>> -			UCODE_LOADER_API_VER);
>> -		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
>> -		if (status) {
>> -			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
>> -				  KBUILD_MODNAME, fw_name);
>> -			return status;
>> -		}
>> -		sprintf(fw_name, "%s_hdr-%d.fw", brcms_firmwares[i],
>> -			UCODE_LOADER_API_VER);
>> -		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
>> -		if (status) {
>> -			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
>> -				  KBUILD_MODNAME, fw_name);
>> -			return status;
>> -		}
>> -		wl->fw.hdr_num_entries[i] =
>> -		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
>> -	}
>> -	wl->fw.fw_cnt = i;
>> -	return brcms_ucode_data_init(wl, &wl->ucode);
>> -}
>> -
>> -/*
>> - * Precondition: Since this function is called in brcms_pci_probe() context,
>> - * no locking is required.
>> - */
>> -static void brcms_release_fw(struct brcms_info *wl)
>> -{
>> -	int i;
>> -	for (i = 0; i < MAX_FW_IMAGES; i++) {
>> -		release_firmware(wl->fw.fw_bin[i]);
>> -		release_firmware(wl->fw.fw_hdr[i]);
>> -	}
>> -}
>> -
>> -/**
>> - * This function frees the WL per-device resources.
>> - *
>> - * This function frees resources owned by the WL device pointed to
>> - * by the wl parameter.
>> - *
>> - * precondition: can both be called locked and unlocked
>> - *
>> - */
>> -static void brcms_free(struct brcms_info *wl)
>> -{
>> -	struct brcms_timer *t, *next;
>> -
>> -	/* free ucode data */
>> -	if (wl->fw.fw_cnt)
>> -		brcms_ucode_data_free(&wl->ucode);
>> -	if (wl->irq)
>> -		free_irq(wl->irq, wl);
>> -
>> -	/* kill dpc */
>> -	tasklet_kill(&wl->tasklet);
>> -
>> -	if (wl->pub) {
>> -		brcms_debugfs_detach(wl->pub);
>> -		brcms_c_module_unregister(wl->pub, "linux", wl);
>> -	}
>> -
>> -	/* free common resources */
>> -	if (wl->wlc) {
>> -		brcms_c_detach(wl->wlc);
>> -		wl->wlc = NULL;
>> -		wl->pub = NULL;
>> -	}
>> -
>> -	/* virtual interface deletion is deferred so we cannot spinwait */
>> -
>> -	/* wait for all pending callbacks to complete */
>> -	while (atomic_read(&wl->callbacks) > 0)
>> -		schedule();
>> -
>> -	/* free timers */
>> -	for (t = wl->timers; t; t = next) {
>> -		next = t->next;
>> -#ifdef DEBUG
>> -		kfree(t->name);
>> -#endif
>> -		kfree(t);
>> -	}
>> -}
>> -
>> -/*
>> -* called from both kernel as from this kernel module (error flow on attach)
>> -* precondition: perimeter lock is not acquired.
>> -*/
>> -static void brcms_remove(struct bcma_device *pdev)
>> -{
>> -	struct ieee80211_hw *hw = bcma_get_drvdata(pdev);
>> -	struct brcms_info *wl = hw->priv;
>> -
>> -	if (wl->wlc) {
>> -		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
>> -		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
>> -		ieee80211_unregister_hw(hw);
>> -	}
>> -
>> -	brcms_free(wl);
>> -
>> -	bcma_set_drvdata(pdev, NULL);
>> -	ieee80211_free_hw(hw);
>> -}
>> -
>>   static irqreturn_t brcms_isr(int irq, void *dev_id)
>>   {
>>   	struct brcms_info *wl;
>> @@ -1047,18 +1058,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
>>   	spin_lock_init(&wl->lock);
>>   	spin_lock_init(&wl->isr_lock);
>>
>> -	/* prepare ucode */
>> -	if (brcms_request_fw(wl, pdev) < 0) {
>> -		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
>> -			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
>> -		brcms_release_fw(wl);
>> -		brcms_remove(pdev);
>> -		return NULL;
>> -	}
>> -
>>   	/* common load-time initialization */
>>   	wl->wlc = brcms_c_attach((void *)wl, pdev, unit, false, &err);
>> -	brcms_release_fw(wl);
>>   	if (!wl->wlc) {
>>   		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
>>   			  KBUILD_MODNAME, err);
>> --
>> 1.7.10.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>


