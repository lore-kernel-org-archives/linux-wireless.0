Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59270 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZC0NlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 09:41:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: remove user_claim stuff
Date: Fri, 27 Mar 2009 14:39:33 +0100
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1238159671.4452.3.camel@johannes.local>
In-Reply-To: <1238159671.4452.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903271439.33942.mb@bu3sch.de> (sfid-20090327_144109_183827_F0290CC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 March 2009 14:14:31 Johannes Berg wrote:
> Almost all drivers do not support user_claim, so remove it
> completely and always report -EOPNOTSUPP to userspace. Since
> userspace cannot really drive rfkill _anyway_ (due to the
> odd restrictions imposed by the documentation) having this
> code is just pointless.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I think it's a good idea to remove this code.
What about scheduling a removal of the "claim" sysfs file? Does anybody use it?

> ---
>  Documentation/rfkill.txt                  |   16 ++++------
>  drivers/net/wireless/ath9k/main.c         |    1 
>  drivers/net/wireless/b43/rfkill.c         |    1 
>  drivers/net/wireless/b43legacy/rfkill.c   |    1 
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c |    1 
>  drivers/platform/x86/acer-wmi.c           |    1 
>  drivers/platform/x86/hp-wmi.c             |    3 --
>  drivers/platform/x86/toshiba_acpi.c       |    1 
>  include/linux/rfkill.h                    |    6 ----
>  net/rfkill/rfkill.c                       |   45 ++----------------------------
>  net/wimax/op-rfkill.c                     |    1 
>  11 files changed, 9 insertions(+), 68 deletions(-)
> 
> --- wireless-testing.orig/include/linux/rfkill.h	2009-03-27 14:09:02.000000000 +0100
> +++ wireless-testing/include/linux/rfkill.h	2009-03-27 14:10:50.000000000 +0100
> @@ -58,9 +58,6 @@ enum rfkill_state {
>   * @type: Radio type which the button controls, the value stored
>   *	here should be a value from enum rfkill_type.
>   * @state: State of the switch, "UNBLOCKED" means radio can operate.
> - * @user_claim_unsupported: Whether the hardware supports exclusive
> - *	RF-kill control by userspace. Set this before registering.
> - * @user_claim: Set when the switch is controlled exlusively by userspace.
>   * @mutex: Guards switch state transitions.  It serializes callbacks
>   *	and also protects the state.
>   * @data: Pointer to the RF button drivers private data which will be
> @@ -83,9 +80,6 @@ struct rfkill {
>  	const char *name;
>  	enum rfkill_type type;
>  
> -	bool user_claim_unsupported;
> -	bool user_claim;
> -
>  	/* the mutex serializes callbacks and also protects
>  	 * the state */
>  	struct mutex mutex;
> --- wireless-testing.orig/net/rfkill/rfkill.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/net/rfkill/rfkill.c	2009-03-27 14:10:50.000000000 +0100
> @@ -200,7 +200,7 @@ static void __rfkill_switch_all(const en
>  
>  	rfkill_global_states[type].current_state = state;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		if ((!rfkill->user_claim) && (rfkill->type == type)) {
> +		if (rfkill->type == type) {
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill, state, 0);
>  			mutex_unlock(&rfkill->mutex);
> @@ -447,53 +447,14 @@ static ssize_t rfkill_claim_show(struct 
>  				 struct device_attribute *attr,
>  				 char *buf)
>  {
> -	struct rfkill *rfkill = to_rfkill(dev);
> -
> -	return sprintf(buf, "%d\n", rfkill->user_claim);
> +	return sprintf(buf, "%d\n", 0);
>  }
>  
>  static ssize_t rfkill_claim_store(struct device *dev,
>  				  struct device_attribute *attr,
>  				  const char *buf, size_t count)
>  {
> -	struct rfkill *rfkill = to_rfkill(dev);
> -	unsigned long claim_tmp;
> -	bool claim;
> -	int error;
> -
> -	if (!capable(CAP_NET_ADMIN))
> -		return -EPERM;
> -
> -	if (rfkill->user_claim_unsupported)
> -		return -EOPNOTSUPP;
> -
> -	error = strict_strtoul(buf, 0, &claim_tmp);
> -	if (error)
> -		return error;
> -	claim = !!claim_tmp;
> -
> -	/*
> -	 * Take the global lock to make sure the kernel is not in
> -	 * the middle of rfkill_switch_all
> -	 */
> -	error = mutex_lock_killable(&rfkill_global_mutex);
> -	if (error)
> -		return error;
> -
> -	if (rfkill->user_claim != claim) {
> -		if (!claim && !rfkill_epo_lock_active) {
> -			mutex_lock(&rfkill->mutex);
> -			rfkill_toggle_radio(rfkill,
> -					rfkill_global_states[rfkill->type].current_state,
> -					0);
> -			mutex_unlock(&rfkill->mutex);
> -		}
> -		rfkill->user_claim = claim;
> -	}
> -
> -	mutex_unlock(&rfkill_global_mutex);
> -
> -	return error ? error : count;
> +	return -EOPNOTSUPP;
>  }
>  
>  static struct device_attribute rfkill_dev_attrs[] = {
> --- wireless-testing.orig/Documentation/rfkill.txt	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/Documentation/rfkill.txt	2009-03-27 14:10:50.000000000 +0100
> @@ -521,16 +521,12 @@ status of the system.
>  Input devices may issue events that are related to rfkill.  These are the
>  various KEY_* events and SW_* events supported by rfkill-input.c.
>  
> -******IMPORTANT******
> -When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE OF AN RFKILL
> -SWITCH IN RESPONSE TO AN INPUT EVENT also handled by rfkill-input, unless it
> -has set to true the user_claim attribute for that particular switch.  This rule
> -is *absolute*; do NOT violate it.
> -******IMPORTANT******
> -
> -Userspace must not assume it is the only source of control for rfkill switches.
> -Their state CAN and WILL change due to firmware actions, direct user actions,
> -and the rfkill-input EPO override for *_RFKILL_ALL.
> +Userspace may not change the state of an rfkill switch in response to an
> +input event, it should refrain from changing states entirely.
> +
> +Userspace cannot assume it is the only source of control for rfkill switches.
> +Their state can change due to firmware actions, direct user actions, and the
> +rfkill-input EPO override for *_RFKILL_ALL.
>  
>  When rfkill-input is not active, userspace must initiate a rfkill status
>  change by writing to the "state" attribute in order for anything to happen.
> --- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-27 14:10:50.000000000 +0100
> @@ -1267,7 +1267,6 @@ static int ath_init_sw_rfkill(struct ath
>  	sc->rf_kill.rfkill->data = sc;
>  	sc->rf_kill.rfkill->toggle_radio = ath_sw_toggle_radio;
>  	sc->rf_kill.rfkill->state = RFKILL_STATE_UNBLOCKED;
> -	sc->rf_kill.rfkill->user_claim_unsupported = 1;
>  
>  	return 0;
>  }
> --- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/rfkill.c	2009-03-27 14:10:50.000000000 +0100
> @@ -139,7 +139,6 @@ void b43_rfkill_init(struct b43_wldev *d
>  	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>  	rfk->rfkill->data = dev;
>  	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
> -	rfk->rfkill->user_claim_unsupported = 1;
>  
>  	rfk->poll_dev = input_allocate_polled_device();
>  	if (!rfk->poll_dev) {
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.c	2009-03-27 14:10:50.000000000 +0100
> @@ -142,7 +142,6 @@ void b43legacy_rfkill_init(struct b43leg
>  	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>  	rfk->rfkill->data = dev;
>  	rfk->rfkill->toggle_radio = b43legacy_rfkill_soft_toggle;
> -	rfk->rfkill->user_claim_unsupported = 1;
>  
>  	rfk->poll_dev = input_allocate_polled_device();
>  	if (!rfk->poll_dev) {
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rfkill.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rfkill.c	2009-03-27 14:10:50.000000000 +0100
> @@ -91,7 +91,6 @@ int iwl_rfkill_init(struct iwl_priv *pri
>  	priv->rfkill->data = priv;
>  	priv->rfkill->state = RFKILL_STATE_UNBLOCKED;
>  	priv->rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
> -	priv->rfkill->user_claim_unsupported = 1;
>  
>  	priv->rfkill->dev.class->suspend = NULL;
>  	priv->rfkill->dev.class->resume = NULL;
> --- wireless-testing.orig/drivers/platform/x86/acer-wmi.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/platform/x86/acer-wmi.c	2009-03-27 14:10:50.000000000 +0100
> @@ -986,7 +986,6 @@ enum rfkill_type type, char *name, u32 c
>  	*data = cap;
>  	rfkill_dev->data = data;
>  	rfkill_dev->toggle_radio = acer_rfkill_set;
> -	rfkill_dev->user_claim_unsupported = 1;
>  
>  	err = rfkill_register(rfkill_dev);
>  	if (err) {
> --- wireless-testing.orig/drivers/platform/x86/hp-wmi.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/platform/x86/hp-wmi.c	2009-03-27 14:10:50.000000000 +0100
> @@ -432,7 +432,6 @@ static int __init hp_wmi_bios_setup(stru
>  		wifi_rfkill->name = "hp-wifi";
>  		wifi_rfkill->state = hp_wmi_wifi_state();
>  		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
> -		wifi_rfkill->user_claim_unsupported = 1;
>  		err = rfkill_register(wifi_rfkill);
>  		if (err)
>  			goto add_sysfs_error;
> @@ -444,7 +443,6 @@ static int __init hp_wmi_bios_setup(stru
>  		bluetooth_rfkill->name = "hp-bluetooth";
>  		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
>  		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
> -		bluetooth_rfkill->user_claim_unsupported = 1;
>  		err = rfkill_register(bluetooth_rfkill);
>  		if (err)
>  			goto register_bluetooth_error;
> @@ -455,7 +453,6 @@ static int __init hp_wmi_bios_setup(stru
>  		wwan_rfkill->name = "hp-wwan";
>  		wwan_rfkill->state = hp_wmi_wwan_state();
>  		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
> -		wwan_rfkill->user_claim_unsupported = 1;
>  		err = rfkill_register(wwan_rfkill);
>  		if (err)
>  			goto register_wwan_err;
> --- wireless-testing.orig/drivers/platform/x86/toshiba_acpi.c	2009-03-27 14:08:21.000000000 +0100
> +++ wireless-testing/drivers/platform/x86/toshiba_acpi.c	2009-03-27 14:10:50.000000000 +0100
> @@ -806,7 +806,6 @@ static int __init toshiba_acpi_init(void
>  
>  		toshiba_acpi.rfk_dev->name = toshiba_acpi.bt_name;
>  		toshiba_acpi.rfk_dev->toggle_radio = bt_rfkill_toggle_radio;
> -		toshiba_acpi.rfk_dev->user_claim_unsupported = 1;
>  		toshiba_acpi.rfk_dev->data = &toshiba_acpi;
>  
>  		if (hci_get_bt_on(&bt_on) == HCI_SUCCESS && bt_on) {
> --- wireless-testing.orig/net/wimax/op-rfkill.c	2009-03-27 14:10:00.000000000 +0100
> +++ wireless-testing/net/wimax/op-rfkill.c	2009-03-27 14:10:50.000000000 +0100
> @@ -364,7 +364,6 @@ int wimax_rfkill_add(struct wimax_dev *w
>  	rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
>  	rfkill->data = wimax_dev;
>  	rfkill->toggle_radio = wimax_rfkill_toggle_radio;
> -	rfkill->user_claim_unsupported = 1;
>  
>  	/* Initialize the input device for the hw key */
>  	input_dev = input_allocate_device();
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Greetings, Michael.
