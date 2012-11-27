Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40536 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2K0LyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 06:54:24 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so8014771iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 03:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354008888.950.62.camel@cumari.coelho.fi>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
 <1353998701-18171-4-git-send-email-arik@wizery.com> <1354008888.950.62.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 27 Nov 2012 13:54:08 +0200
Message-ID: <CA+XVXfexJew14BSu79JC2OPnQMiEaw6--bOwwbDDCkr=wQMy4w@mail.gmail.com> (sfid-20121127_125427_989434_88B2DB83)
Subject: Re: [PATCH 03/20] wlcore: Allow memory access when the FW crashes
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 11:34 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
>> From: Ido Yariv <ido@wizery.com>
>>
>> When the no_recovery flag is used, the recovery work will not restart
>> the FW and the state will not be set to 'on'. To enable post-mortem
>> analysis, allow memory access in the 'restarting' state.
>>
>> Also, since the FW might not be operational, don't fail the read/write
>> operations if elp_wakeup fails.
>>
>> Reported-by: Arkady Miasnikov <a-miasnikov@ti.com>
>> Signed-off-by: Ido Yariv <ido@wizery.com>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> This is weird.  This patch is already in (d5560238) and the one here is
> actually just part of it and probably won't apply.

Heh. It seems Eliad and I are to blame (all the rebases can really
mess with the mind).

There's a patch by Eliad to reverse the patch you just mentioned:

commit fd8e73af670e6b57708eafe927f5d0364018b4e5
Author: Eliad Peller <eliad@wizery.com>
Date:   Wed Nov 14 02:28:26 2012 +0200

    wlcore: don't allow access to FW mem when chip is off

(which I submitted earlier in my part 1 series)

And the current patch simply cancels it out. So please ignore the
previous patch as well as this one. Good catch :)

Arik
