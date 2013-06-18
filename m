Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3FROgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:36:44 -0400
Message-ID: <1371566195.8318.28.camel@jlt4.sipsolutions.net> (sfid-20130618_163655_706112_5E6F0D08)
Subject: Re: [PATCHv2] Revert "mac80211: in IBSS use the Auth frame to
 trigger STA reinsertion"
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 18 Jun 2013 16:36:35 +0200
In-Reply-To: <1371558040-2821-1-git-send-email-ordex@autistici.org>
References: <1371558040-2821-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 14:20 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> This reverts commit 6d810f10325522cfcf498dc6d64b9f96e1f5153f
> 
> In this way an IBSS station will not use the AUTH messages
> to trigger a state reinitialisation anymore.
> 
> The behaviour was racy and was not working properly.
> It has been introduced to help wpa_supplicant to support
> IBSS/RSN, however all the logic is now getting moved into
> wpa_s itself which will also be in charge of handling the
> AUTH messages thanks to the mgmt frame registration.
> 
> If userspace does not register for receiving AUTH frames
> then mac80211 will still reply by itself.
> 
> At the same time, the auth frame registration counter can be
> removed since it is not needed anymore.

Applied.

johannes

