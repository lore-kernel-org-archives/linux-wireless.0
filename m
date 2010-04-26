Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab0DZJg0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 05:36:26 -0400
Message-ID: <4BD55EFE.3080009@redhat.com>
Date: Mon, 26 Apr 2010 11:38:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [WIP] p54pci: fix resume p54 cardbus
References: <201004251525.19796.chunkeey@googlemail.com>
In-Reply-To: <201004251525.19796.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Thanks for working on this and thanks for CC-ing me, but I don't
understand why you're making the firmware loading asynchronous...

On 04/25/2010 03:25 PM, Christian Lamparter wrote:
> This patch tries to fix the resume freeze, which is described in
> https://bugzilla.redhat.com/show_bug.cgi?id=583623
>
> Unlike (normal) PCI cards, cardbus cards are easily removable.
> Therefore, the user might replace/remove the card while
> the system is suspended. The pcmcia subsystem takes special
> precautions to deal with such cases and un- and rebinds
> all devices on the pci-bridge during the resume process.
>
> But here's the catch: p54pci uses request_firmware
> which blocks until the filesystem is available.
> This deadlocks, because the filesystem won't
> be initialized until all pci devices are ready again.

p54pci uses request_firmware only from its probe function,
which does not get called during a suspend resume AFAIK.

And if the card was inserted during a suspend / resume. I would
not expect its driver to get loaded until the resume has completed
and udev runs again.

Hmm, I think while typing this message I just understood what you're
trying to fix. The problem could occur when the driver is already loaded
(for some reason), but not yet bound to the device as the card got
inserted during suspend. Does the probe function get called during
resume then ?

This would seem like a driver core bug to me. It should not start
binding drivers to "new" devices, until the resume is completed IMHO.

Note that the problem which I'm mostly seeing with suspend resume,
is that the card fails shortly after resume. It seems to be come up
and I can send / receive some packets and then it fails. The changes
you're making to resume where you're actually calling pci enable
on the device, and re-doing some pci config space settings might help
here (I'm currently unloading the driver before suspend and reloading
it after resume and then things work fine).

The one actual lockup I experienced in combination with suspend / resume
was before the other p54pci bug we've working on together was fixed,
as the driver was unstable at that time in general, so I'm not overly
worried about that one lockup.

Regards,

Hans




> ---
> highly experimental and possibly unstable
> ---
> diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
> index 7bbd9d3..810197c 100644
> --- a/drivers/net/wireless/p54/main.c
> +++ b/drivers/net/wireless/p54/main.c
> @@ -603,6 +603,8 @@ int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
>   		return err;
>   	}
>
> +	priv->registered = true;
> +
>   #ifdef CONFIG_P54_LEDS
>   	err = p54_init_leds(priv);
>   	if (err)
> @@ -638,6 +640,9 @@ void p54_unregister_common(struct ieee80211_hw *dev)
>   {
>   	struct p54_common *priv = dev->priv;
>
> +	if (!priv->registered)
> +		return;
> +
>   #ifdef CONFIG_P54_LEDS
>   	p54_unregister_leds(priv);
>   #endif /* CONFIG_P54_LEDS */
> diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
> index 43a3b2e..850e6bb 100644
> --- a/drivers/net/wireless/p54/p54.h
> +++ b/drivers/net/wireless/p54/p54.h
> @@ -172,6 +172,7 @@ struct p54_common {
>   	struct sk_buff_head tx_pending;
>   	struct sk_buff_head tx_queue;
>   	struct mutex conf_mutex;
> +	bool registered;
>
>   	/* memory management (as seen by the firmware) */
>   	u32 rx_start;
> diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
> index c916e46..353085d 100644
> --- a/drivers/net/wireless/p54/p54pci.c
> +++ b/drivers/net/wireless/p54/p54pci.c
> @@ -50,7 +50,6 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
>   {
>   	struct p54p_priv *priv = dev->priv;
>   	__le32 reg;
> -	int err;
>   	__le32 *data;
>   	u32 remains, left, device_addr;
>
> @@ -75,11 +74,7 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
>   	wmb();
>
>   	/* wait for the firmware to reset properly */
> -	mdelay(10);
> -
> -	err = p54_parse_firmware(dev, priv->firmware);
> -	if (err)
> -		return err;
> +	mdelay(50);
>
>   	if (priv->common.fw_interface != FW_LM86) {
>   		dev_err(&priv->pdev->dev, "wrong firmware, "
> @@ -360,8 +355,12 @@ static void p54p_stop(struct ieee80211_hw *dev)
>   {
>   	struct p54p_priv *priv = dev->priv;
>   	struct p54p_ring_control *ring_control = priv->ring_control;
> -	unsigned int i;
>   	struct p54p_desc *desc;
> +	unsigned int i;
> +
> +	mutex_lock(&priv->mutex);
> +	if (!priv->started)
> +		goto out_unlock;
>
>   	P54P_WRITE(int_enable, cpu_to_le32(0));
>   	P54P_READ(int_enable);
> @@ -420,6 +419,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
>   	}
>
>   	memset(ring_control, 0, sizeof(*ring_control));
> +	priv->started = false;
> +
> +out_unlock:
> +	mutex_unlock(&priv->mutex);
>   }
>
>   static int p54p_open(struct ieee80211_hw *dev)
> @@ -427,19 +430,25 @@ static int p54p_open(struct ieee80211_hw *dev)
>   	struct p54p_priv *priv = dev->priv;
>   	int err;
>
> +	mutex_lock(&priv->mutex);
> +	if (WARN_ON(priv->started)) {
> +		err = -EBUSY;
> +		goto out_unlock;
> +	}
> +
>   	init_completion(&priv->boot_comp);
>   	err = request_irq(priv->pdev->irq, p54p_interrupt,
>   			  IRQF_SHARED, "p54pci", dev);
>   	if (err) {
>   		dev_err(&priv->pdev->dev, "failed to register IRQ handler\n");
> -		return err;
> +		goto out_unlock;
>   	}
>
>   	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
>   	err = p54p_upload_firmware(dev);
>   	if (err) {
>   		free_irq(priv->pdev->irq, dev);
> -		return err;
> +		goto out_unlock;
>   	}
>   	priv->rx_idx_data = priv->tx_idx_data = 0;
>   	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
> @@ -464,10 +473,10 @@ static int p54p_open(struct ieee80211_hw *dev)
>   	P54P_READ(dev_int);
>
>   	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
> -		printk(KERN_ERR "%s: Cannot boot firmware!\n",
> -		       wiphy_name(dev->wiphy));
> +		dev_err(&priv->pdev->dev, "Cannot boot firmware!");
>   		p54p_stop(dev);
> -		return -ETIMEDOUT;
> +		err = -ETIMEDOUT;
> +		goto out_unlock;
>   	}
>
>   	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
> @@ -480,7 +489,78 @@ static int p54p_open(struct ieee80211_hw *dev)
>   	wmb();
>   	udelay(10);
>
> -	return 0;
> +	priv->started = true;
> +
> +out_unlock:
> +	mutex_unlock(&priv->mutex);
> +	return err;
> +}
> +
> +const static char *p54p_fws[] = { "isl3886pci", "isl3886" };
> +
> +static void p54p_fw_callback(const struct firmware *fw, void *context);
> +static int p54p_request_fw(struct p54p_priv *priv)
> +{
> +
> +	if (ARRAY_SIZE(p54p_fws)<= priv->fw_idx)
> +		return -ENOENT;
> +
> +	return request_firmware_nowait(THIS_MODULE, 1, p54p_fws[priv->fw_idx],
> +				&priv->pdev->dev, GFP_KERNEL, priv,
> +				       p54p_fw_callback);
> +}
> +
> +static void p54p_fw_callback(const struct firmware *fw, void *context)
> +{
> +	struct p54p_priv *priv = context;
> +	struct ieee80211_hw *dev = pci_get_drvdata(priv->pdev);
> +	int err;
> +
> +	if (!fw) {
> +		dev_err(&priv->pdev->dev, "Cannot find firmware (\"%s\")",
> +			p54p_fws[priv->fw_idx]);
> +		priv->fw_idx++;
> +
> +		err = p54p_request_fw(priv);
> +		if (err)
> +			goto err_out;
> +
> +		return;
> +	}
> +
> +	priv->firmware = fw;
> +
> +	err = p54_parse_firmware(dev, priv->firmware);
> +	if (err) {
> +		dev_err(&priv->pdev->dev, "Failed to parse firmware");
> +		goto err_out;
> +	}
> +
> +	err = p54p_open(dev);
> +	if (err)
> +		goto err_out;
> +	err = p54_read_eeprom(dev);
> +	p54p_stop(dev);
> +	if (err)
> +		goto err_out;
> +
> +	err = p54_register_common(dev,&priv->pdev->dev);
> +	if (err)
> +		goto err_out;
> +
> +	return;
> +
> +err_out:
> +	device_release_driver(&priv->pdev->dev);
> +}
> +
> +static void p54p_init_dev(struct pci_dev *pdev)
> +{
> +	pci_set_master(pdev);
> +	pci_try_set_mwi(pdev);
> +
> +	pci_write_config_byte(pdev, 0x40, 0);
> +	pci_write_config_byte(pdev, 0x41, 0);
>   }
>
>   static int __devinit p54p_probe(struct pci_dev *pdev,
> @@ -518,11 +598,7 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
>   		goto err_free_reg;
>   	}
>
> -	pci_set_master(pdev);
> -	pci_try_set_mwi(pdev);
> -
> -	pci_write_config_byte(pdev, 0x40, 0);
> -	pci_write_config_byte(pdev, 0x41, 0);
> +	p54p_init_dev(pdev);
>
>   	dev = p54_init_common(sizeof(*priv));
>   	if (!dev) {
> @@ -556,34 +632,16 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
>   	priv->common.tx = p54p_tx;
>
>   	spin_lock_init(&priv->lock);
> +	mutex_init(&priv->mutex);
>   	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
>
> -	err = request_firmware(&priv->firmware, "isl3886pci",
> -			&priv->pdev->dev);
> -	if (err) {
> -		dev_err(&pdev->dev, "Cannot find firmware (isl3886pci)\n");
> -		err = request_firmware(&priv->firmware, "isl3886",
> -				&priv->pdev->dev);
> -		if (err)
> -			goto err_free_common;
> -	}
> -
> -	err = p54p_open(dev);
> -	if (err)
> -		goto err_free_common;
> -	err = p54_read_eeprom(dev);
> -	p54p_stop(dev);
> -	if (err)
> -		goto err_free_common;
> -
> -	err = p54_register_common(dev,&pdev->dev);
> +	err = p54p_request_fw(priv);
>   	if (err)
>   		goto err_free_common;
>
>   	return 0;
>
>    err_free_common:
> -	release_firmware(priv->firmware);
>   	pci_free_consistent(pdev, sizeof(*priv->ring_control),
>   			    priv->ring_control, priv->ring_control_dma);
>
> @@ -611,6 +669,8 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
>
>   	p54_unregister_common(dev);
>   	priv = dev->priv;
> +	p54p_stop(dev);
> +	mutex_destroy(&priv->mutex);
>   	release_firmware(priv->firmware);
>   	pci_free_consistent(pdev, sizeof(*priv->ring_control),
>   			    priv->ring_control, priv->ring_control_dma);
> @@ -624,32 +684,48 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
>   static int p54p_suspend(struct pci_dev *pdev, pm_message_t state)
>   {
>   	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
> -	struct p54p_priv *priv = dev->priv;
> -
> -	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
> -		ieee80211_stop_queues(dev);
> -		p54p_stop(dev);
> -	}
>
> +	p54p_stop(dev);
>   	pci_save_state(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -	return 0;
> +	pci_disable_device(pdev);
> +	return pci_set_power_state(pdev, pci_choose_state(pdev, state));
>   }
>
>   static int p54p_resume(struct pci_dev *pdev)
>   {
>   	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
>   	struct p54p_priv *priv = dev->priv;
> +	int err;
> +
> +	err = pci_set_power_state(pdev, PCI_D0);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to power-up device");
> +		return err;
> +	}
>
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to reenable device");
> +		return err;
> +	}
> +
> +	err = pci_restore_state(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to restore device state");
> +		return err;
> +	}
> +
> +	p54p_init_dev(pdev);
>
>   	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
> -		p54p_open(dev);
> -		ieee80211_wake_queues(dev);
> +		err = p54p_open(dev);
> +		if (err) {
> +			dev_err(&pdev->dev, "failed to bring up link");
> +			return err;
> +		}
>   	}
>
> -	return 0;
> +	return err;
>   }
>   #endif /* CONFIG_PM */
>
> diff --git a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
> index 9fd822f..d4a9bdc 100644
> --- a/drivers/net/wireless/p54/p54pci.h
> +++ b/drivers/net/wireless/p54/p54pci.h
> @@ -95,7 +95,10 @@ struct p54p_priv {
>   	struct pci_dev *pdev;
>   	struct p54p_csr __iomem *map;
>   	struct tasklet_struct tasklet;
> +	unsigned int fw_idx;
>   	const struct firmware *firmware;
> +	bool started;
> +	struct mutex mutex;
>   	spinlock_t lock;
>   	struct p54p_ring_control *ring_control;
>   	dma_addr_t ring_control_dma;
