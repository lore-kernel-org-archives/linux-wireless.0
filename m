Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51549 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZAEOnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 09:43:50 -0500
Received: by bwz14 with SMTP id 14so22656016bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 06:43:46 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Date: Mon, 5 Jan 2009 15:43:21 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	"reinette chatre" <reinette.chatre@intel.com>
References: <200812011311.17346.helmut.schaa@gmail.com> <200812011604.05700.helmut.schaa@gmail.com> <1ba2fa240812010943p4cc1617asbe66d090ee8f4aa0@mail.gmail.com>
In-Reply-To: <1ba2fa240812010943p4cc1617asbe66d090ee8f4aa0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901051543.22355.helmut.schaa@gmail.com> (sfid-20090105_154353_159682_9D66CC75)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Dezember 2008 schrieb Tomas Winkler:
> >> In 3495  rfkill interrupt is not available and rfkill state is
> >> delivered only when firmware is loaded, therefore this is not
> >> possible to bring device down and also expect rfill switch event.
> >
> > Would it be possible to poll CSR_GP_CNTRL for that information on iwl3945?
> 
> Not sure, need to run and check

JFYI, I've just checked that:
It is possible to poll CSR_GP_CNTRL without the firmware begin loaded.
Hence the 3945 could also report the killswitch state to userspace while
being "down" by polling (instead of listening to interrupts like 4965).

Helmut
