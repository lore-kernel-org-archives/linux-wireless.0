Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62530 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662Ab3BLSXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 13:23:43 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so174371bkc.11
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 10:23:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511A8254.8060306@cozybit.com>
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com> <511A8254.8060306@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 12 Feb 2013 10:23:21 -0800
Message-ID: <CAG6hwVMwws5D=0WRYR6CtmmDKo=_wSTAi4gpK9KDafCcMkaWqg@mail.gmail.com> (sfid-20130212_192355_013933_B38E9103)
Subject: Re: [PATCH 1/3] mac80211: consolidate MBSS change notification
To: Marco Porsch <marco@cozybit.com>
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2013 at 9:56 AM, Marco Porsch <marco@cozybit.com> wrote:
> On 02/11/2013 10:07 PM, Thomas Pedersen wrote:
>> +       if (ifmsh->nonpeer_pm != nonpeer_pm ||
>> +           ifmsh->ps_peers_light_sleep != light_sleep_cnt ||
>> +           ifmsh->ps_peers_deep_sleep != deep_sleep_cnt)
>> +               changed = BSS_CHANGED_BEACON;
>
>
> Here it only affects the beacon if the number of light/deep sleep peers
> changed from/to zero or non-zero.
> The following should avoid some unnecessary updates:
>
> !ifmsh->ps_peers_deep_sleep != !deep_sleep_cnt ||
> !ifmsh->ps_peers_deep_sleep != !deep_sleep_cnt)

Ah nice. I'll add this to the v2, not checking deep_sleep_cnt twice of course :)

--
Thomas
