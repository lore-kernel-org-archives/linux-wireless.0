Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49206 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbcCDSyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 13:54:15 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 02/43] iwlwifi: mvm: add registration to thermal zone
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
	<1456905404-14435-2-git-send-email-emmanuel.grumbach@intel.com>
	<877fhi9jes.fsf@nemi.mork.no>
Date: Fri, 04 Mar 2016 19:53:55 +0100
In-Reply-To: <877fhi9jes.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Fri, 04
	Mar 2016 19:39:55 +0100")
Message-ID: <8737s69irg.fsf@nemi.mork.no> (sfid-20160304_195419_254952_7DA74369)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjørn Mork <bjorn@mork.no> writes:

>> +static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
>> +{
>> +	if (!iwl_mvm_is_tt_in_fw(mvm))
>> +		return;
>> +
>> +	if (mvm->tz_device.tzone) {
>> +		IWL_DEBUG_TEMP(mvm, "Thermal zone device unregister\n");
>> +		thermal_zone_device_unregister(mvm->tz_device.tzone);
>
> Won't that ERR_PTR blow up when dereferenced by
> thermal_zone_device_unregister() ?

To answer myself:  No, it won't.  I was tricked by the oddly placed
  tzp = tz->tzp;
line here, but we will return before that becomes a problem:

void thermal_zone_device_unregister(struct thermal_zone_device *tz)
{
        int i;
        const struct thermal_zone_params *tzp;
        struct thermal_cooling_device *cdev;
        struct thermal_zone_device *pos = NULL;

        if (!tz)
                return;

        tzp = tz->tzp;

        mutex_lock(&thermal_list_lock);
        list_for_each_entry(pos, &thermal_tz_list, node)
            if (pos == tz)
                break;
        if (pos != tz) {
                /* thermal zone device not found */
                mutex_unlock(&thermal_list_lock);
                return;
        }


Still think it's unwise to leave ERR_PTR's around though.



Bjørn
