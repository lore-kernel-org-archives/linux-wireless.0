Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65383 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab0DPT5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 15:57:06 -0400
Received: by pwj9 with SMTP id 9so2305928pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 12:57:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100416194335.GF8554@tuxdriver.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
	<1271367582-992-10-git-send-email-lrodriguez@atheros.com>
	<20100416194335.GF8554@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 16 Apr 2010 12:56:44 -0700
Message-ID: <t2g43e72e891004161256l3f48b79avc520be4cf2dafbf6@mail.gmail.com>
Subject: Re: [PATCH v3 09/97] ath9k_hw: Move some RF ops to the private
	callbacks
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 12:43 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Apr 15, 2010 at 05:38:14PM -0400, Luis R. Rodriguez wrote:
>> The PHY split is easier done in a few steps. First move
>> the RF ops to the private ops and rename them accordingly.
>> We split PHY stuff up first for the AR5008 and AR9002
>> families. There are some callbacks that AR9002 share
>> with the AR5008 familiy so we set those first, if AR9002
>> has some different callbacks it will override them upon
>> hardware init.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/Makefile            |    3 +-
>>  drivers/net/wireless/ath/ath9k/ani.c               |    1 +
>>  .../net/wireless/ath/ath9k/{phy.c => ar5008_phy.c} |  884 ++++++++++----------
>
> In general, it is better to do renames in a separate patch -- the
> fixups are easier in cases where something else hit that file before
> your patch is applied.  It might also help if you based big patches
> (or big series) on wireless-next-2.6 instead of wireless-testing, as I
> need to apply them to wireless-next-2.6 before I can send them to Dave.
>
> In this case, a patch that wireless-testing picked-up from linux-2.6
> and which isn't in wireless-next-2.6 (and probably not net-next-2.6
> either) causes this patch to fail to apply to wirless-next-2.6.
> I'll fix it up, in the interest of putting this series behind us...

Thanks for addressing it on your end this time, next time we'll rebase
on top of wireless-next-2.6 when doing a larger series. I don't expect
this to happen quite often though. This was just a new hardware
family, which happens so far about every what, 4-5 years?

Thanks!!!

  Luis
