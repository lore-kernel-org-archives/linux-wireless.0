Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58254 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaFKIj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:39:27 -0400
Received: by mail-ie0-f179.google.com with SMTP id tr6so2816138ieb.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XQoPOot0gvzgEm-ZtPh+1_8-jZR+ME50tFccmrnFkezA@mail.gmail.com>
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
	<CAB=NE6XQoPOot0gvzgEm-ZtPh+1_8-jZR+ME50tFccmrnFkezA@mail.gmail.com>
Date: Wed, 11 Jun 2014 11:39:26 +0300
Message-ID: <CAB3XZEdOqC2m_XCWQS5mytvcg03A4bYj5Z-o_sBpHn=R=hismw@mail.gmail.com> (sfid-20140611_103934_053673_5624AA07)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 11:30 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Jun 11, 2014 at 12:23 AM, Arik Nemtsov <arik@wizery.com> wrote:
>> From: Eliad Peller <eliad@wizery.com>
>>
>> alpha2 is defined as 2-chars array, but is used in multiple
>> places as string (e.g. with nla_put_string calls), which
>> might leak kernel data.
>>
>> Solve it by simply adding an extra char for the NULL
>> terminator, making such operations safe.
>>
>> Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
>> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>
> Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>
> Thanks for the patch ! Curious how you ended up down finding the issue though.
>
i'm not sure. i think i noticed some crap in hostapd log and looked for it.

Eliad.
