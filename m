Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:10080 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbYFLUFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 16:05:38 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3016214waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 13:05:37 -0700 (PDT)
Message-ID: <1ba2fa240806121305h721c6bd2x8073660d41653b92@mail.gmail.com> (sfid-20080612_220559_589283_8B1809D7)
Date: Thu, 12 Jun 2008 23:05:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix beacon interval value
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213299706.3730.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
	 <1213299706.3730.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 10:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> 1. in register_hw it honors value requested by the driver
>
> I don't think the driver should be able to "request" a value.

Yes and no.
The problem is that we don't have user space interface to tune this
for IBSS so in this circumstances
driver can choose what value is best for it.

Tomas

>
>> 2. It uses default 100 instead of 1000 or 10000. Scanning for beacon
>> interval ~1sec and above is not sane
>
> Yeah, 10000 seems a bit excessive.

Actually this never took affect as there is no way that 0 is assigned
to hw->conf.beacon_int but even 1000 is edgy and not suitable for a
default value.

Tomas
