Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:30664 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbYETWS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 18:18:28 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2593036waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 15:18:28 -0700 (PDT)
Message-ID: <1ba2fa240805201518h78f9825fw389d0afd42f0130b@mail.gmail.com> (sfid-20080521_002050_496773_C2051B34)
Date: Wed, 21 May 2008 01:18:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
	 <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 12:51 AM, Stefanik G=E1bor
<netrolller.3d@gmail.com> wrote:
> On Tue, May 20, 2008 at 5:41 PM, Tomas Winkler <tomasw@gmail.com> wro=
te:
>> On Tue, May 20, 2008 at 8:01 PM, Stefanik G=E1bor <netrolller.3d@gma=
il.com> wrote:
>>> This patch fixes packet injection on iwlwifi devices (iwl3945 and
>>> iwl4965). Tested with packetspammer and aireplay-ng, also works in
>>> monitor-while-associated mode. If possible, please apply to 2.6.26,
>>> else to 2.6.27. The patch is also available as an attachment, in ca=
se
>>> Gmail decides to word-wrap or whitespace-damage the inline version.
>>>
>>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>>> ---
>>>
>>> <snip>
>>
>> This is certainly no go for 4965. Station must be present in uCode
>> table. Maybe this work for monitor mode but there is a race in regul=
ar
>> cases, when sta_id !=3D broadcast id at least priv->assoc_station_ad=
ded
>> =3D=3D 1 has to be true. Have you tested it with 4965 ?
>>
>> I suggest to proceed with 3945 part only of this patch.
>>
>> Tomas
>
> Which change does this comment apply to? The "IWL_DEBUG_DROP("Droppin=
g
> - !priv->vif\n");" one? Or the "drop all data frame if we are not
> associated" one? Also, doesn't the "if (sta_id =3D=3D
> IWL_INVALID_STATION)" part protect against such cases? Also, what
> happens if we simply pass broadcast in such a case?
>
The station can be in driver data structure but it's not guaranties
it's also in the uCode. It will
return correct station id but the table in uCode will be empty.
Retuning to new channel clears the station table in the uCode so it
must to be reapplied also you must have applied rate command (LQ).
Simply currently there is a window big enough for a race. It can be
solved but there is more coding than this patch.

Thanks
Tomas
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
