Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43522 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbcAHIMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 03:12:07 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2016-01-07
Date: Fri, 8 Jan 2016 08:12:02 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E984F12@hasmsx107.ger.corp.intel.com> (sfid-20160108_091211_790204_7E8F5BB0)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E9844E2@hasmsx107.ger.corp.intel.com>
 <87oacxjdxj.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/07/2016 11:08 PM, Kalle Valo wrote:
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
>
>> Me again,
>>
>> On 01/07/2016 02:46 PM, Grumbach, Emmanuel wrote:
>>> Hi Kalle,
>>>
>>> Here is the last round of patches for 4.5. Most of them are small and / or fixes.
>>> Let me know if you have issues.
>>> FYI - I scripted a few checks so that I hope that the internal tags that leaked
>>> in the previous pull request won't leak any more.
>>>
>>> The following changes since commit e5d15cb530082cc13a6c9457eddd6f75b0f4de65:
>> I had to edit one commit. I re-pushed to the same tag and added another
>> _2 tag if you prefer to be sure.
> Heh, you sent this just in the last minute (if Linus releases 4.4 this
> weekend as planned). I pulled iwlwifi-next-for-kalle-2016-01-07_2 now,
> thanks.

Right, OTOH, most of the patches here are really fixes.

> BTW, I would prefer that you don't change the tag after you have sent a
> pull request for it, instead just create a new tag and leave the old one
> intact. This way it's easy for me to check what has changed etc.
>


FWIW:

$ git diff ccecff6..iwlwifi-next-for-kalle-2016-01-07_2
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index fd409ad..4841be2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -1250,7 +1250,6 @@ int iwlagn_suspend(struct iwl_priv *priv, struct
cfg80211_wowlan *wowlan)
 
        ret = iwlagn_send_patterns(priv, wowlan);
  out:
-       iwl_trans_stop_device(priv->trans);
        kfree(key_data.rsc_tsc);
        return ret;
 }

