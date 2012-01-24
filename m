Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45733 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2AXTPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 14:15:37 -0500
Received: by ggnb1 with SMTP id b1so2162226ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 11:15:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327431354.3625.186.camel@cumari>
References: <1327421923-25586-1-git-send-email-eliad@wizery.com>
	<1327421923-25586-2-git-send-email-eliad@wizery.com>
	<1327431354.3625.186.camel@cumari>
Date: Tue, 24 Jan 2012 21:15:36 +0200
Message-ID: <CAB3XZEdw8VUuSNAibmGE6bHtthVaTCrRWD5LaKWo9zgTVvAFJw@mail.gmail.com> (sfid-20120124_201601_040179_CFDD04DC)
Subject: Re: [PATCH 2/2] wl12xx: remove wl1271_tx_update_filters
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 8:55 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-01-24 at 18:18 +0200, Eliad Peller wrote:
>> wl1271_tx_update_filters() is used as some workaround
>> to open filters while roaming on the same channel.
>>
>> However, it doesn't handle roaming to a different channel,
>> and it might also sleep in the tx path, which is a bug.
>>
>> With the new auth/assoc redesign, roaming is much simpler,
>> and this function is not needed anymore.
>
> And is this okay without the redesign?
>
yes.
it will only break roaming on the same channel. but as roaming to
another channel is already broken, and it also fixes a scheduling bug,
i think it should be applied even before the redesign patches..

Eliad.
