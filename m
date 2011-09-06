Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61596 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1IFGm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 02:42:59 -0400
Message-ID: <4E65C0EB.105@qca.qualcomm.com> (sfid-20110906_084304_448097_C6580BA3)
Date: Tue, 6 Sep 2011 09:42:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Process regulatory requests from firmware.
References: <1315215774-13931-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1315215774-13931-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2011 12:42 PM, Vivek Natarajan wrote:
> Process the regulatory code from eeprom and pass the
> country information to cfg80211.

Minor comments:

> +static struct country_code_to_enum_rd*
> +ath6kl_regd_find_country(u16 countryCode)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
> +		if (allCountries[i].countryCode == countryCode)
> +			return &allCountries[i];
> +	}

Insert space here.

> +	return NULL;
> +}
> +
> +static struct reg_dmn_pair_mapping*
> +ath6kl_get_regpair(u16 regdmn)
> +{
> +	int i;
> +
> +	if (regdmn == NO_ENUMRD)
> +		return NULL;

Space here as well

> +	for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++) {
> +		if (regDomainPairs[i].regDmnEnum == regdmn)
> +			return &regDomainPairs[i];
> +	}

And here :)

> +	return NULL;
> +}
> +
> +static struct country_code_to_enum_rd*
> +ath6kl_regd_find_country_by_rd(u16 regdmn)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
> +		if (allCountries[i].regDmnEnum == regdmn)
> +			return &allCountries[i];
> +	}

Here also

> +	return NULL;
> +}
> +
> +static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap,
int len)
> +{
> +
> +	struct ath6kl_wmi_regdomain *ev;
> +	struct country_code_to_enum_rd *country = NULL;
> +	struct reg_dmn_pair_mapping *regpair = NULL;
> +	char alpha2[2];
> +	u32 reg_code;
> +
> +	ev = (struct ath6kl_wmi_regdomain *) datap;
> +	reg_code = le32_to_cpu(ev->reg_code);
> +
> +	if ((reg_code >> COUNTRY_RD_SHIFT) & COUNTRY_ERD_FLAG)
> +		country = ath6kl_regd_find_country((u16) reg_code);
> +	else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
> +
> +		regpair = ath6kl_get_regpair((u16) reg_code);
> +		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
> +		printk(KERN_DEBUG "ath6kl: Regpair used: 0x%0x\n",
> +				regpair->regDmnEnum);

ath6kl_dbg() is more approriate here.

> +	}
> +
> +	if (country) {
> +		alpha2[0] = country->isoName[0];
> +		alpha2[1] = country->isoName[1];
> +
> +		regulatory_hint(wmi->parent_dev->wdev->wiphy, alpha2);
> +
> +		printk(KERN_DEBUG "ath6kl: Country alpha2 being used: %c%c\n",
> +				alpha2[0], alpha2[1]);

Please use ath6kl_dbg() or, if we really need to log this, you can use
ath6kl_info(). But is there a reason to log this everytime?

> +#define COUNTRY_RD_SHIFT        16

Please add ATH6KL_ prefix.

Kalle
