Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36387 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1DTIvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 04:51:31 -0400
Received: by pzk9 with SMTP id 9so281476pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 01:51:31 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.40745.97648.620379@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 14:24:01 +0530
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 2/5] ath9k_htc: Fix AMPDU subframe handling
In-Reply-To: <4DAE9759.9020005@gmail.com>
References: <19886.28554.581823.283614@gargle.gargle.HOWL>
	<4DAE9759.9020005@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paulius Zaleckas wrote:
> 
> 
> On 04/20/2011 08:30 AM, Sujith wrote:
> > From: Sujith Manoharan<Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>
> >
> > * Register the driver's maximum ampdu subframe limit to mac80211.
> > * Cleanup the target capabilities structure and fix an endian issue.
> > * Fix BTCOEX by sending a command to the target when the BT priority
> >    changes.
> > * Bump the required firmware version to 1.1
> >
> > Signed-off-by: Sujith Manoharan<Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>
> 
> [...]
> 
> > +	/*
> > +	 * Check if the available FW matches the driver's
> > +	 * required version.
> > +	 */
> > +	if (priv->fw_version_major<  MAJOR_VERSION_REQ ||
> > +	    priv->fw_version_minor<  MINOR_VERSION_REQ) {
> 
> Wrong version check logic. Version 2.0 will fail this 1.1 check, because 
> of minor version number.
> Should be something like:
> if (priv->fw_version_major < MAJOR_VERSION_REQ ||
>      (priv->fw_version_major == MAJOR_VERSION_REQ &&
>       priv->fw_version_minor < MINOR_VERSION_REQ))
> 

Actually, I think a much more strict check is required, since the driver can't
be compatible with both a lower or a higher version of the firmware.

Sujith
