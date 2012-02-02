Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53163 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2BBPXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 10:23:13 -0500
Received: by iacb35 with SMTP id b35so3264779iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 07:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d8z54m0Jh68U9r6qeVOiAuF6S8e2vWQP8NtNajUW1pD0A@mail.gmail.com>
References: <1328181189-5461-1-git-send-email-eliad@wizery.com>
	<CAGXE3d8z54m0Jh68U9r6qeVOiAuF6S8e2vWQP8NtNajUW1pD0A@mail.gmail.com>
Date: Thu, 2 Feb 2012 17:23:13 +0200
Message-ID: <CAB3XZEd+vYN55-WDyP85t9=znGzseim5rDEW8QmkcPpkNMv2Rg@mail.gmail.com> (sfid-20120202_162317_456325_2548785B)
Subject: Re: [PATCH] mac80211: support hw scan while idle
From: Eliad Peller <eliad@wizery.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 5:13 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Thu, Feb 2, 2012 at 12:13 PM, Eliad Peller <eliad@wizery.com> wrote:
> [...]
>> -       if (local->scan_sdata) {
>> +       if (local->scan_sdata &&
>> +           !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {
>
> Maybe check for the existence of the hw_scan callback here? Otherwise a
> driver setting this flag without providing a hw_scan callback might cause
> trouble ...
>
i'll add a check in ieee80211_register_hw().

thanks.
