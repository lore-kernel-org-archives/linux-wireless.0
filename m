Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:45323 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbcCDSkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 13:40:01 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 02/43] iwlwifi: mvm: add registration to thermal zone
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
	<1456905404-14435-2-git-send-email-emmanuel.grumbach@intel.com>
Date: Fri, 04 Mar 2016 19:39:55 +0100
In-Reply-To: <1456905404-14435-2-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Wed, 2 Mar 2016 09:56:03 +0200")
Message-ID: <877fhi9jes.fsf@nemi.mork.no> (sfid-20160304_194015_408962_9FF01EE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
>
> Register to thermal_zone interface and implement the
> thermal ops.

And there it was :)


> +static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
> +{
> +	int i;
> +	char name[] = "iwlwifi";
> +
> +	if (!iwl_mvm_is_tt_in_fw(mvm)) {
> +		mvm->tz_device.tzone = NULL;
> +
> +		return;
> +	}
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(name) >= THERMAL_NAME_LENGTH);
> +
> +	mvm->tz_device.tzone = thermal_zone_device_register(name,


Why not simply 
        mvm->tz_device.tzone = thermal_zone_device_register(DRV_NAME,
?




> +							IWL_MAX_DTS_TRIPS,
> +							IWL_WRITABLE_TRIPS_MSK,
> +							mvm, &tzone_ops,
> +							NULL, 0, 0);
> +	if (IS_ERR(mvm->tz_device.tzone)) {
> +		IWL_DEBUG_TEMP(mvm,
> +			       "Failed to register to thermal zone (err = %ld)\n",
> +			       PTR_ERR(mvm->tz_device.tzone));
> +		return;
> +	}

So you return with an ERR_PTR in mvm->tz_device.tzone?


> +static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
> +{
> +	if (!iwl_mvm_is_tt_in_fw(mvm))
> +		return;
> +
> +	if (mvm->tz_device.tzone) {
> +		IWL_DEBUG_TEMP(mvm, "Thermal zone device unregister\n");
> +		thermal_zone_device_unregister(mvm->tz_device.tzone);

Won't that ERR_PTR blow up when dereferenced by
thermal_zone_device_unregister() ?



Bjørn
