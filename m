Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:58091 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763037AbYETVvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 17:51:05 -0400
Received: by el-out-1112.google.com with SMTP id s27so733636ele.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 14:51:04 -0700 (PDT)
Message-ID: <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com> (sfid-20080521_002305_536828_A261F150)
Date: Tue, 20 May 2008 17:51:03 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 5:41 PM, Tomas Winkler <tomasw@gmail.com> wrote=
:
> On Tue, May 20, 2008 at 8:01 PM, Stefanik G=E1bor <netrolller.3d@gmai=
l.com> wrote:
>> This patch fixes packet injection on iwlwifi devices (iwl3945 and
>> iwl4965). Tested with packetspammer and aireplay-ng, also works in
>> monitor-while-associated mode. If possible, please apply to 2.6.26,
>> else to 2.6.27. The patch is also available as an attachment, in cas=
e
>> Gmail decides to word-wrap or whitespace-damage the inline version.
>>
>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>> ---
>>
>> <snip>
>
> This is certainly no go for 4965. Station must be present in uCode
> table. Maybe this work for monitor mode but there is a race in regula=
r
> cases, when sta_id !=3D broadcast id at least priv->assoc_station_add=
ed
> =3D=3D 1 has to be true. Have you tested it with 4965 ?
>
> I suggest to proceed with 3945 part only of this patch.
>
> Tomas

Which change does this comment apply to? The "IWL_DEBUG_DROP("Dropping
- !priv->vif\n");" one? Or the "drop all data frame if we are not
associated" one? Also, doesn't the "if (sta_id =3D=3D
IWL_INVALID_STATION)" part protect against such cases? Also, what
happens if we simply pass broadcast in such a case?

Thanks,
G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
