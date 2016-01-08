Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52757 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbcAHIId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 03:08:33 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 01/21] iwlwifi: dvm: fix WoWLAN
Date: Fri, 8 Jan 2016 08:08:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E984EE3@hasmsx107.ger.corp.intel.com> (sfid-20160108_090837_892223_ADBA9DB8)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
 <1452170861-10060-1-git-send-email-emmanuel.grumbach@intel.com>
 <87k2nljdl4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/07/2016 11:15 PM, Kalle Valo wrote:
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>
>> My commit below introduced a mutex in the transport to
>> prevent concurrent operations. To do so, it added a flag
>> (is_down) to make sure the transport is in the right state.
>> This uncoverred an bug that didn't cause any harm until
>> now: iwldvm calls stop_device and then starts the firmware
>> without calling start_hw in between. While this flow is
>> fine from the device configuration point of view (register,
>> etc...), it is now forbidden by the new is_down flag.
>> This led to this error to appear:
>> iwlwifi 0000:05:00.0: Can't start_fw since the HW hasn't been started
>> and the suspend would fail.
>>
>> This fixes:
>> https://bugzilla.kernel.org/show_bug.cgi?id=109591
>>
>> CC: <stable@vger.kernel.org> [4.3+]
>> Reported-by: Bogdan Bogush <bogdan.s.bogush@gmail.com>
>> Fixes=fa9f3281cbb1 ("iwlwifi: pcie: lock start_hw / start_fw / stop_device")
> No need to change this anymore, but this should be:
>
> Fixes: fa9f3281cbb1 ("iwlwifi: pcie: lock start_hw / start_fw / stop_device")
>
Added to my "do_no_screw_up_before_upstreaming.sh" script.
