Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36198 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbcCAUE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 15:04:27 -0500
Received: by mail-wm0-f47.google.com with SMTP id n186so54515492wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 12:04:27 -0800 (PST)
Reply-To: arend@broadcom.com
Subject: Re: [PATCH V10 1/2] nl80211: add feature for BSS selection support
References: <1456739065-470-1-git-send-email-arend@broadcom.com>
 <CAB3XZEehKfMzRgfbDkwWieKrzAAXwBcNbAMNGfhn6qBRAktGdA@mail.gmail.com>
To: Eliad Peller <eliad@wizery.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56D5F5C7.40204@broadcom.com> (sfid-20160301_210430_808286_886FFF5F)
Date: Tue, 1 Mar 2016 21:04:23 +0100
MIME-Version: 1.0
In-Reply-To: <CAB3XZEehKfMzRgfbDkwWieKrzAAXwBcNbAMNGfhn6qBRAktGdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1-3-2016 9:42, Eliad Peller wrote:
> On Mon, Feb 29, 2016 at 11:44 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> Introducing a new feature that the driver can use to
>> indicate the driver/firmware supports configuration of BSS
>> selection criteria upon CONNECT command. This can be useful
>> when multiple BSS-es are found belonging to the same ESS,
>> ie. Infra-BSS with same SSID. The criteria can then be used to
>> offload selection of a preferred BSS.
>>
> [...]
> 
>> +       /* only do bss selection when no BSSID is specified. */
>> +       if (!connect.bssid && info->attrs[NL80211_ATTR_BSS_SELECT]) {
>> +               if (connect.bssid) {
> 
> i guess you wanted to remove the !connect.bssid condition in the outer if :)
> other than that, looks go to me.

Good guess. Will fix that.

Regards,
Arend
