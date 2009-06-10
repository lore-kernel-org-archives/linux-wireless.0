Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54690 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbZFJBz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 21:55:56 -0400
Date: Tue, 9 Jun 2009 22:55:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v4] rfkill: remove set_global_sw_state
Message-ID: <20090610015555.GC593@khazad-dum.debian.net>
References: <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com> <20090607125715.GC3340@khazad-dum.debian.net> <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk> <4A2CE4A2.2090308@tuffmail.co.uk> <1244457159.18863.7.camel@johannes.local> <4A2CF3C1.20607@tuffmail.co.uk> <4A2CF465.5090704@tuffmail.co.uk> <4A2CF4DB.60105@tuffmail.co.uk> <4A2D03AF.8060702@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A2D03AF.8060702@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 08 Jun 2009, Alan Jenkins wrote:
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -1168,21 +1168,6 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
>  
>  	BUG_ON(id >= TPACPI_RFK_SW_MAX || tpacpi_rfkill_switches[id]);
>  
> -	initial_sw_status = (tp_rfkops->get_status)();
> -	if (initial_sw_status < 0) {
> -		printk(TPACPI_ERR
> -			"failed to read initial state for %s, error %d; "
> -			"will turn radio off\n", name, initial_sw_status);
> -	} else {
> -		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
> -		if (set_default) {
> -			/* try to set the initial state as the default for the
> -			 * rfkill type, since we ask the firmware to preserve
> -			 * it across S5 in NVRAM */
> -			rfkill_set_global_sw_state(rfktype, initial_sw_state);
> -		}
> -	}
> -
>  	atp_rfk = kzalloc(sizeof(struct tpacpi_rfk), GFP_KERNEL);
>  	if (atp_rfk)
>  		atp_rfk->rfkill = rfkill_alloc(name,
> @@ -1200,8 +1185,20 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
>  	atp_rfk->id = id;
>  	atp_rfk->ops = tp_rfkops;
>  
> -	rfkill_set_states(atp_rfk->rfkill, initial_sw_state,
> -				tpacpi_rfk_check_hwblock_state());
> +	initial_sw_status = (tp_rfkops->get_status)();
> +	if (initial_sw_status < 0) {
> +		printk(TPACPI_ERR
> +			"failed to read initial state for %s, error %d\n",
> +			name, initial_sw_status);
> +	} else {
> +		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
> +		if (set_default) {
> +			/* try to keep the initial state, since we ask the
> +			 * firmware to preserve it across S5 in NVRAM */
> +			rfkill_set_sw_state(atp_rfk->rfkill, initial_sw_state);
> +		}
> +	}
> +	rfkill_set_hw_state(atp_rfk->rfkill, tpacpi_rfk_check_hwblock_state());
>  
>  	res = rfkill_register(atp_rfk->rfkill);
>  	if (res < 0) {

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
