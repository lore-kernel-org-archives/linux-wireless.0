Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52054 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3J1OuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:50:04 -0400
Received: by mail-lb0-f174.google.com with SMTP id q8so2895780lbi.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 07:50:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382971344.17956.27.camel@jlt4.sipsolutions.net>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
 <1382376158-25586-2-git-send-email-mcgrof@do-not-panic.com> <1382971344.17956.27.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 28 Oct 2013 15:49:42 +0100
Message-ID: <CAB=NE6XXwRR34Pt6vF=ZHsqMPqCtXFidj7j5b97gx-v3LDhPCw@mail.gmail.com> (sfid-20131028_155057_958064_6E46AAE8)
Subject: Re: [PATCH 01/14] cfg80211: consolidate passive-scan and no-ibss flags
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 3:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I don't think you can make this change, it breaks API and ABI because
> the old IBSS flag is now ignored on input from old CRDA?

I addressed that by mapping it to NO-IR in-kernel, if it was used. In
other words if userspace sends it we'll respect it in the same way.

  Luis
