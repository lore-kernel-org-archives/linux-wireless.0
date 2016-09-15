Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32905 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934591AbcIOOPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:15:37 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 15/21] ath10k: support CT firmware flag.
Date: Thu, 15 Sep 2016 14:15:31 +0000
Message-ID: <87bmzpb667.fsf@kamboji.qca.qualcomm.com> (sfid-20160915_161540_795986_4C4A3895)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-16-git-send-email-greearb@candelatech.com>
        <87bmzqeeox.fsf@kamboji.qca.qualcomm.com>       <57D96BC7.1080609@candelatech.com>
In-Reply-To: <57D96BC7.1080609@candelatech.com> (Ben Greear's message of "Wed,
        14 Sep 2016 08:24:55 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/14/2016 07:30 AM, Valo, Kalle wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Add placeholder so CT firmware can more easily co-exist with upstream
>>> kernel.  CT firmware should be backwards compatible with existing kerne=
ls,
>>> but it also has many new features.  Subsequent patches, if acceptable f=
or
>>> upstream, can enable and further describe those features.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>   drivers/net/wireless/ath/ath10k/core.c | 1 +
>>>   drivers/net/wireless/ath/ath10k/core.h | 3 +++
>>>   2 files changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wirel=
ess/ath/ath10k/core.c
>>> index fa71d57..49c85c3 100644
>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>> @@ -235,6 +235,7 @@ static const char *const ath10k_core_fw_feature_str=
[] =3D {
>>>   	[ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA] =3D "adaptive-cca",
>>>   	[ATH10K_FW_FEATURE_MFP_SUPPORT] =3D "mfp",
>>>   	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] =3D "peer-flow-ctrl",
>>> +	[ATH10K_FW_FEATURE_WMI_10X_CT] =3D "wmi-10.x-CT",
>>>   };
>>>
>>>   static unsigned int ath10k_core_get_fw_feature_str(char *buf,
>>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wirel=
ess/ath/ath10k/core.h
>>> index cb6aa8c..f9e3b20 100644
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -566,6 +566,9 @@ enum ath10k_fw_features {
>>>   	 */
>>>   	ATH10K_FW_FEATURE_PEER_FLOW_CONTROL =3D 13,
>>>
>>> +	/* Firmware from Candela Technologies, enables more VIFs, etc */
>>> +	ATH10K_FW_FEATURE_WMI_10X_CT =3D 31,
>>
>> The idea of firmware feature flags to enable (or disable) one particular
>> feature, not a group of features. This way it's easy to enable certain
>> features on different firmware branches. It also makes the maintenance
>> easier as you don't need to remember all the different features one flag
>> enables.
>
> One potential use for this flag:  Bug reports could be automatically dire=
cted to me instead
> of QCA.
>
> I have actually re-written much of my earlier logic so that it uses speci=
fic
> feature flags now.  I still like the idea of having the driver (and user)
> know it is using CT firmware, but I can live without this flag if needed.

You can do with firmware version string, add something like "-CT" (maybe
you already have?) and it's clearly visible in boot logs and also when
firmware crashes.

--=20
Kalle Valo=
