Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62806 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966266Ab2EOTIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 15:08:13 -0400
Received: by bkcji2 with SMTP id ji2so5129389bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 12:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB1C6F8.7060902@lwfinger.net>
References: <1337036779-16348-1-git-send-email-stas.yakovlev@gmail.com>
	<4FB1C6F8.7060902@lwfinger.net>
Date: Tue, 15 May 2012 12:08:11 -0700
Message-ID: <CA++WF2MFg4fA11hxKE=9FSf-V6QH2bBEshKoM8Z9G_8AO80KsA@mail.gmail.com> (sfid-20120515_210817_800488_36A3AA2A)
Subject: Re: [PATCH] net/wireless: ipw2100: Fix WARN_ON occurring in
 wiphy_register called by ipw2100_pci_init_one
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2012 20:01, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/14/2012 06:06 PM, Stanislav Yakovlev wrote:
>>
>> The problem was found by Larry Finger:
>> http://marc.info/?l=linux-wireless&m=133702401700614&w=2
>>
>> The problem is identical to the one for ipw2200 which is already fixed:
>> http://marc.info/?l=linux-wireless&m=133457257407196&w=2
>>
>> [   17.766431] ------------[ cut here ]------------
>> [   17.766467] WARNING: at net/wireless/core.c:562
>> ...
>> [   17.766769] ---[ end trace 559898c6bb0d1c75 ]---
>> [   17.767093] ipw2100: probe of 0000:02:03.0 failed with error -5
>>
>> This warning appears only if we apply Ben Hutchings' fix
>> http://marc.info/?l=linux-wireless&m=132720204412667&w=2
>> for the bug reported by Cesare Leonardi
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=656813
>> with cfg80211 warning during device registration
>> ("cfg80211: failed to add phy80211 symlink to netdev!").
>>
>> We separate device bring up and registration with network stack
>> to avoid the problem.
>>
>> Signed-off-by: Stanislav Yakovlev<stas.yakovlev@gmail.com>
>> ---
>>
>> Larry, can you test it once again?
>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Yes, this patch fixes the problem.

Thanks!

Stanislav.
