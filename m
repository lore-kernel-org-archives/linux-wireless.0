Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41650 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2ASRhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 12:37:11 -0500
Received: by bkas6 with SMTP id s6so163524bka.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 09:37:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120119083102.873553392@sipsolutions.net>
References: <20120119082956.486569312@sipsolutions.net> <20120119083102.873553392@sipsolutions.net>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Thu, 19 Jan 2012 19:36:53 +0200
Message-ID: <CA+XVXff7LdscHL046d0h=s7W9b-YdfLa24EVSed9yrdv0OU75A@mail.gmail.com> (sfid-20120119_183716_042901_2DB0C403)
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2012 at 10:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> Similar to the previous beacon filtering patch,
> make CQM RSSI support depend on the flags that
> the driver set for virtual interfaces.

Up until now we circumvented the issue by having mode specific HW
flags (e.g. IEEE80211_HW_AP_LINK_PS). Usually the mode of the FW
determines the HW capabilities and this is enough.
It also has the advantages of only touching mode-specific code-paths.

Since this is a STA-mode only flag I assume this is something for
multi-role (multiple stations)?

Arik
