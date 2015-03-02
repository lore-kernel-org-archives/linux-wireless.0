Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:33175 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbCBKRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 05:17:02 -0500
Received: by wevk48 with SMTP id k48so32280745wev.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 02:17:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425288321.1906.1.camel@sipsolutions.net>
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
	<1425287344-30594-2-git-send-email-michal.kazior@tieto.com>
	<1425287785.1906.0.camel@sipsolutions.net>
	<CA+BoTQnrS74yx=V_sPvTgzkoZeWbOBFawqXZMAv6oEhUypmoQA@mail.gmail.com>
	<1425288321.1906.1.camel@sipsolutions.net>
Date: Mon, 2 Mar 2015 11:17:00 +0100
Message-ID: <CA+BoTQnk8FBRwqTuq=ZAp__exwHejO1HncNhcVOASwn8+dKu=g@mail.gmail.com> (sfid-20150302_111706_737169_03F202E1)
Subject: Re: [PATCH 2/3] ath10k: always save/restore pci config space
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 March 2015 at 10:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-03-02 at 10:23 +0100, Michal Kazior wrote:
>
>> > I believe the whole thing isn't necessary at all since the kernel's PCIe
>> > layer will take care of it.
>>
>> You mean only the pci_save_state() and pci_disable_device() or, the
>> resume counterpart as well? Hmm.
>
> Resume as well - but I believe it's all-or-nothing.
>
>> Earlier the resume counterpart didn't do any restore stuff and the
>> device ended up pretty confused..
>
> which may explain this.

Hmm.. I removed the save/restore/enable/disable completely and
re-tested. It seems to work fine as well.

I'll post a v2 later then. Thanks!


Michał
